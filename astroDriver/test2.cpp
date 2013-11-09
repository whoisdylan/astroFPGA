#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <fcntl.h>
#include <errno.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <unistd.h>
#include <stdint.h>
#include <ctime>

using namespace std;

char devname[] = "/dev/xpcie";
int g_devFile = -1;

//#define NUM_ROWS    1000000
//#define NUM_COLS    524288
#define NUM_ROWS    100
#define NUM_COLS    249750//524288
#define TIMER
#define DDEBUG
#define OFFSET_INST 2097144

typedef struct dataSet{
// 64 bits reserved for flags and stuff.
	unsigned int instruction;

// 16x16 pixels
// 16x16/4. 4 pixels per int.
	 unsigned int descriptor[64];
// 80x80/4 pixels window
//
	unsigned int window[1600];

// 1665 *4 = 6660B
// 999000B per image
}dataSet; 


struct TransferData  {

    //unsigned int data[524288];
    unsigned int data[NUM_COLS];

} *gReadData, *gWriteData;


int WriteData(char* buff, int size, loff_t offset)
{
    int ret = pwrite(g_devFile, buff, size, offset);

    return (ret);
}

int ReadData(char *buff, int size, loff_t offset)
{
    int ret = pread(g_devFile, buff, size, offset);

    return (ret);
}


void set_instruction(uint32_t *instruction){
	// for sending instruction
	loff_t offset = OFFSET_INST;
	
	int ret = pwrite(g_devFile, instruction ,sizeof(uint32_t),offset);

}

void get_instruction(uint32_t *instruction){
	loff_t offset = OFFSET_INST;

	int ret = pread(g_devFile, instruction, sizeof(uint32_t),offset);

}

int main()
{
    int i, j,k;
    int iter_count = NUM_ROWS;
    ifstream inputFile("file.txt");
    string line;
    istringstream ss;
    loff_t offset = 0;
	uint32_t* instruction;
	int flag;
    char* devfilename = devname;
    g_devFile = open(devfilename, O_RDWR);

    if ( g_devFile < 0 )  {
        printf("Error opening device file\n");
        return 0;
    }
	flag = 1;
    gReadData = (TransferData  *) malloc(sizeof(struct TransferData));	
    gWriteData = (TransferData  *) malloc(sizeof(struct TransferData));	
	instruction = (uint32_t *) malloc(sizeof(uint32_t));
    time_t start = time(NULL);

    printf("Starting...\n");
    for (j = 0; j < NUM_ROWS; j++) 
    {
        //getline(inputFile, line);
        for(i=0; i< NUM_COLS; i++) {
            //ss >> gWriteData->data[0];
            gWriteData->data[i]=i+1;
        }
        WriteData((char*) gWriteData, 4*NUM_COLS, offset);
		flag = 1;
		*instruction = 0x00000100;

		set_instruction(instruction);
		
		while(flag == 1){
			get_instruction(instruction);
			//printf("instruction = %x\n", *instruction);
			if(*instruction == 0x04000000){
				flag =0;
			}
		}
	


        ReadData((char *) gReadData, 4*NUM_COLS, offset);
		*instruction = 0x00000000;
		set_instruction(instruction);
/*
        for(i=0; i<NUM_COLS; i++) {
			//printf("read value at [%d] is %x\n", i, gReadData->data[i]);
            if (gReadData->data[i] != gWriteData->data[i]+1)
                printf("DWORD miscompare [%d] -> expected %x : found %x \n", i, gWriteData->data[i], gReadData->data[i]);
        }
*/
    }
    time_t end = time(NULL);
    int time = end-start;
    cout << "elapsed time: " << time << " s" << endl;

    return 0;
}

