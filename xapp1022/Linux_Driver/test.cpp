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

#define NUM_ROWS    1600
#define NUM_COLS    256
#define TIMER
#define DDEBUG

struct TransferData  {

    unsigned int data[2048];

} *gReadData, *gWriteData;


int WriteData(char* buff, int size)
{
    int ret = write(g_devFile, buff, size);

    return (ret);
}

int ReadData(char *buff, int size)
{
    int ret = read(g_devFile, buff, size);

    return (ret);
}

int main()
{
    int i, j;
    int iter_count = NUM_ROWS;
    ifstream inputFile("file.txt");
    string line;
    istringstream ss;


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
        WriteData((char*) gWriteData, 4*NUM_COLS);
        ReadData((char *) gReadData, 4*NUM_COLS);
        for(i=0; i<NUM_COLS; i++) {
            if (gReadData->data[i] != gWriteData->data[i])
                printf("DWORD miscompare [%d] -> expected %x : found %x \n", i, gWriteData->data[i], gReadData->data[i]);
        }
    }
    time_t end = time(NULL);
    int time = end-start;
    cout << "elapsed time: " << time << " s" << endl;

    return 0;
}

