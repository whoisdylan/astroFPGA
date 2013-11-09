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
#include <ctime>

using namespace std;

char devname[] = "/dev/xpcie";
int g_devFile = -1;

//#define NUM_ROWS    1000000
//#define NUM_COLS    524288
#define NUM_ROWS    1
#define NUM_COLS    512
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


void set_instruction(uint64_t *instruction){
	// for sending instruction
	
	int ret = pwrite(g_devFile, instruction ,sizeof(uint64_t),OFFSET_INST);

}

void get_instruction(uint64_t *instruction){

	int ret = pread(g_devFile, instruction, sizeof(uint64_t),OFFSET_INST);

}

int main()
{
    int i, j;
    int iter_count = NUM_ROWS;
    ifstream inputFile("file.txt");
    string line;
    istringstream ss;
    loff_t offset = 16;
	uint64_t

    char* devfilename = devname;
    g_devFile = open(devfilename, O_RDWR);

    if ( g_devFile < 0 )  {
        printf("Error opening device file\n");
        return 0;
    }

    gReadData = (TransferData  *) malloc(sizeof(struct TransferData));	
    gWriteData = (TransferData  *) malloc(sizeof(struct TransferData));	

    time_t start = time(NULL);

    printf("Starting...\n");
    for (j = 0; j < NUM_ROWS; j++) 
    {
        getline(inputFile, line);
        for(i=0; i< NUM_COLS; i++) {
            //ss >> gWriteData->data[0];
            gWriteData->data[i]=i;
        }
        WriteData((char*) gWriteData, 2*NUM_COLS, offset);
        ReadData((char *) gReadData, 2*NUM_COLS, offset);
        for(i=0; i<NUM_COLS/2; i++) {
            if (gReadData->data[i] != gWriteData->data[i])
                printf("DWORD miscompare [%d] -> expected %x : found %x \n", i, gWriteData->data[i], gReadData->data[i]);
        }
    }
    time_t end = time(NULL);
    int time = end-start;
    cout << "elapsed time: " << time << " s" << endl;

    return 0;
}

