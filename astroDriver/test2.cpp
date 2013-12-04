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
#define NUM_ROWS    10000
#define NUM_COLS    249750//524288
#define TIMER
#define DDEBUG
#define OFFSET_INST 2097144
#define DESC_SIZE   16
#define WIN_SIZE    80

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

inline uint32_t PACK(uint8_t byte0, uint8_t byte1, uint8_t byte2, uint8_t byte3) {
    return (byte0 << 24) | (byte1 << 16) | (byte2 << 8) | byte3;
}

int main()
{
    int i, j,k;
    int iter_count = NUM_ROWS;
    string line;
    istringstream ss;
    loff_t offset = 0;
    uint32_t* instruction;
    int flag;
    char* devfilename = devname;
    g_devFile = open(devfilename, O_RDWR);

    char descriptorLLFile[100]; 
    char windowLLFile[100];

    uint32_t byte0, byte1, byte2, byte3;
    uint32_t packedBytes;

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

    printf("Reading descriptors and windows...\n");
    ifstream descFile, winFile;
    descFile.open("/afs/ece.cmu.edu/usr/wtabib/astroFPGA/astrovision/output/descriptorsLL0001.txt");
    winFile.open("/afs/ece.cmu.edu/usr/wtabib/astroFPGA/astrovision/output/windowsLL0001.txt");

    if (descFile.fail()) {
        cout << "failed to open descFile" << endl;
        exit(0);
    }
    if (winFile.fail()) {
        cout << "failed to open winFile" << endl;
        exit(0);
    }


    i = 0; j = 0; k = 0;
    int count = 0;
    *instruction = 0x00000100;
    while (i < 150) {
        gWriteData->data[count] = 0;
        int meanIndex = count;
        count++;
        int mean = 0; 

        //load the descriptor 
        for(j = 0; j < DESC_SIZE*DESC_SIZE/4; j++) {
            descFile >> byte0;
            descFile >> byte1;
            descFile >> byte2;
            descFile >> byte3;

            //compute the mean as you see pixel values
            mean = mean + byte0 + byte1 + byte2 + byte3;
            packedBytes = PACK(byte0, byte1, byte2, byte3);
            gWriteData->data[count] = packedBytes;
            count++;
        }


        //store the mean in the write buffer
        mean = mean >> 8;
        gWriteData->data[meanIndex] = mean;
        
        //load the window
        for(k = 0; k < WIN_SIZE*WIN_SIZE/4; k++) {
            winFile >> byte0;
            winFile >> byte1;
            winFile >> byte2;
            winFile >> byte3;
            packedBytes = PACK(byte0, byte1, byte2, byte3);
            gWriteData->data[count] = packedBytes;
            count++;
        }

        i++;
    }

    WriteData((char*) gWriteData, 4*NUM_COLS, offset);
    flag = 1;
    *instruction = 0x00000100;

    set_instruction(instruction);

    while(flag == 1){
		sleep(1);
        get_instruction(instruction);
        	printf("instruction = %x\n", *instruction);
        if((*instruction & 0xFFFF0000) == 0x04000000){
            flag =0;
        }
    }

	offset = 990000;
    ReadData((char *) gReadData, 3*150, offset);

	for(i =0; i <150; i++){
		printf("result back is %x\n",gReadData->data[i]);
	}
	
	//TODO write gReadData to a file!
	const char resultsDir[] = "/Users/dylan/Dropbox/files/fpgaResults.txt";
	// char resultsLoc[100];
	// sprintf(resultsLoc, "%s%03d%s", resultsDir, 
	saveResults(gReadData, resultsDir, 150);

/*
    for(i=0; i<NUM_COLS; i++) {
        if (gReadData->data[i] != gWriteData->data[i])
            printf("DWORD miscompare [%d] -> expected %x : found %x \n", i, gWriteData->data[i], gReadData->data[i]);
    }
*/
    time_t end = time(NULL);
    int time = end-start;
    cout << "elapsed time: " << time << " s" << endl;

    return 0;
}

void saveResults(const unsigned int readDataBuffer[], const char filename[], const int numPoints) {
	ofstream resultsFile;
	resultsFile.open(filename);
	for (int i = 0; i < numPoints; i++) {
		unsigned int windowIndex = readDataBuffer[i*3];
		//only need 13 MSB of windowIndex;
		windowIndex = windowIndex >> 19;
		unsigned int corrCoeffInt = readDataBuffer[(i+1)*3];
		unsigned int corrCoeffDec = readDataBuffer[(i+2)*3];
		unsigned int exponent = findFirstOne(corrCoeffInt);
		double corrCoeff = exponent << 52;
		double corrCoeff = corrCoeff || corrCoeffDec;
		resultsFile << windowIndex << "\t" << corrCoeff << endl;
	}
	resultsFile.close();
}

unsigned int findFirstOne(unsigned int x) {
	static const unsigned int bval[] =
	{0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4};

	unsigned int r = 0;
	if (x & 0xFFFF0000) { r += 16/1; x >>= 16/1; }
	if (x & 0x0000FF00) { r += 16/2; x >>= 16/2; }
	if (x & 0x000000F0) { r += 16/4; x >>= 16/4; }
	return r + bval[x];
}
