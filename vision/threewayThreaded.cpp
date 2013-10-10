#include <cstdio>
#include <string>
#include <cmath>
#include <ctime>
#include <iostream>
#include <fstream>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
using namespace cv;		using namespace std;

#define SAVE_CORRESPONDENCES
// #define DISPLAY_CORNER_COUNT
// #define DISPLAY_MATCH_COUNT
// #define VERBOSE
#define TIMER
#define BINS
// #define NMS

const int numImages = 150;
const int numPoints = 300;
const double cornerThreshold = .001;
//image directories for ubuntu
// const char imDir[] = "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/datasets/zipline/left_rect_";
// const char imDirR[] = "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/datasets/zipline/right_rect_";
const char imDir[] = "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/datasets/zipline2/descent1_images/left_rect_";
const char imDirR[] = "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/datasets/zipline2/descent1_images/right_rect_";
//image directories for mac
// const char imDir[] = "/Users/dylan/Dropbox/datasets/zipline/left_rect_";
// const char imDirR[] = "/Users/dylan/Dropbox/datasets/zipline/right_rect_";
// const char imDir[] =  "/Users/dylan/Dropbox/datasets/Hongbin/roof_images/rectified/L_";
// const char imDirR[] = "/Users/dylan/Dropbox/datasets/Hongbin/roof_images/rectified/R_";
const char imExt[] = ".png";
const int imLocLength = strlen(imDirR) + strlen(imExt) + 5;
/* for hongbin construction images */
// const char imDir[] = "/Users/dylan/Dropbox/Hongbin/construction_images/L_";
// const char imExt[] = ".png";
// const int imLocLength = strlen(imDir) + strlen(imExt) + 1;
const int shrinkScale = 5;
const int descHalfSize = 8*shrinkScale;
const int windowHalfSize = 40*shrinkScale;
const int epiHalfSize = descHalfSize + 4;
// const int epiHalfSize = windowHalfSize;
const int blackBorder = 55;
const int halfSize = windowHalfSize + blackBorder;
const int outOfBoundsBorder = blackBorder;

struct imageData {
	imageData():correspondencesPrev(numPoints, 2, CV_32FC1),
				correspondencesNext(numPoints, 2, CV_32FC1),
				correspondencesLR(numPoints, 2, CV_32FC1),
				maskPrev(numPoints, 2, CV_8UC1),
				maskNext(numPoints, 2, CV_8UC1),
				maskLR(numPoints, 2, CV_8UC1){}
	imageData(const imageData& other) {
		other.correspondencesPrev.copyTo(correspondencesPrev);
		other.correspondencesNext.copyTo(correspondencesNext);
		other.correspondencesLR.copyTo(correspondencesLR);
		other.maskPrev.copyTo(maskPrev);
		other.maskNext.copyTo(maskNext);
		other.maskLR.copyTo(maskLR);
	}
	imageData& operator=(const imageData& other) {
		other.correspondencesPrev.copyTo(correspondencesPrev);
		other.correspondencesNext.copyTo(correspondencesNext);
		other.correspondencesLR.copyTo(correspondencesLR);
		other.maskPrev.copyTo(maskPrev);
		other.maskNext.copyTo(maskNext);
		other.maskLR.copyTo(maskLR);
		return *this;
	}
	Mat correspondencesPrev;
	Mat correspondencesNext;
	Mat correspondencesLR;
	Mat maskPrev;
	Mat maskNext;
	Mat maskLR;
};

#ifdef SAVE_CORRESPONDENCES
vector<imageData> imageSetLefts;
#endif

//function definitions
void nccPyramidMatchLL(const Mat&, const Mat&, const imageData&, imageData&);
void nccPyramidMatchLR(const Mat&, const Mat&, imageData&);
void detectNewPoints(const Mat&, imageData&, int&);
int harris(const Mat&, vector<double>&, vector<Point2f>&);
void nms(vector<Point2f>&, vector<double>&, Mat&);
// void astrovision(const Mat&, const Mat&, const Mat&, imageData&, imageData&, bool);
void suppressSection(const int, const int, const vector<Point2f>&, const vector<double>&, vector< pair<float,float> >&);
void suppress(const vector<Point2f>&, const vector<double>&, Mat&);
double findMax(const Mat&, Point&);
double findMaxGen(const Mat&, Point&);
double findMaxGran(const Mat&, Point&);
// void ncc(const Mat&, const Mat&, Mat&);
bool comparePair(const pair<float, float>&, const pair<float, float>&);
bool outOfBounds(double, double, int, int);
// void invalidatePoint(int, Mat&, Mat&, Mat&);
void writeMat(const Mat&, const char *);

int main() {
	#ifdef SAVE_CORRESPONDENCES
	imageSetLefts.reserve(numImages);
	#endif
	imageData currIm1Data, currIm2Data;
	Mat currIm1, currIm2, currImR;
	Mat zeroMask = Mat::zeros(numPoints, 2, CV_32FC1);
	vector<Point2f> corners;
	currIm1Data.correspondencesNext.create(numPoints,2,CV_32FC1);
	vector<double> strengths;
	int startIndex = 100;
	int exitStatus = 0;
	vector<Mat> leftImages, rightImages;
	leftImages.reserve(numImages);
	rightImages.reserve(numImages);
	char imageLocation[imLocLength];
	boost::thread_group threadGroup;

	//preload all images
	#ifdef VERBOSE
	cout << "loading all images" << endl;
	#endif
	bool skipNextPair = false;
	for (int i = 0; i < numImages; i++) {
		sprintf(imageLocation, "%s%04d%s", imDir,startIndex+i,imExt);
		Mat imL = imread(imageLocation, CV_LOAD_IMAGE_GRAYSCALE);
		sprintf(imageLocation, "%s%04d%s", imDirR,startIndex+i,imExt);
		Mat imR = imread(imageLocation, CV_LOAD_IMAGE_GRAYSCALE);
		if (imL.empty() || imR.empty()) {
			skipNextPair = true;
		}
		else if (!skipNextPair) {
			leftImages.push_back(imL);
			rightImages.push_back(imR);
			skipNextPair = false;
		}
	}

	#ifdef VERBOSE
	cout << "setting up first image" << endl;
	#endif
	#ifdef TIMER
	time_t start = time(NULL);
	#endif
	currIm1 = leftImages[0];
	currIm2 = leftImages[1];
	currImR = rightImages[0];
	detectNewPoints(currIm1, currIm1Data, exitStatus);

	threadGroup.create_thread(boost::bind(&nccPyramidMatchLL, boost::cref(currIm1), boost::cref(currIm2), boost::cref(currIm1Data), boost::ref(currIm2Data)));
	threadGroup.create_thread(boost::bind(&nccPyramidMatchLR, boost::cref(currIm1), boost::cref(currImR), boost::ref(currIm1Data)));
	threadGroup.create_thread(boost::bind(&detectNewPoints, boost::cref(currIm2), boost::ref(currIm2Data), boost::ref(exitStatus)));
	threadGroup.join_all();
	bitwise_or(currIm2Data.maskPrev, currIm1Data.maskLR, currIm1Data.maskNext, Mat ());
	bitwise_and(currIm1Data.correspondencesNext, zeroMask, currIm1Data.correspondencesNext, currIm1Data.maskNext);
	bitwise_and(currIm1Data.correspondencesLR, zeroMask, currIm1Data.correspondencesLR, currIm1Data.maskNext);
	bitwise_and(currIm2Data.correspondencesPrev, zeroMask, currIm2Data.correspondencesPrev, currIm1Data.maskNext);
	#ifdef SAVE_CORRESPONDENCES
	imageSetLefts.push_back(currIm1Data);
	#endif

	for (int i = 2; i < numImages; i++) {
		skipNextPair = false;
		exitStatus = 0;
		#ifdef VERBOSE
		cout << "processing images " << i << " and " << i+1 << endl;
		#endif
		currIm1Data = currIm2Data;
		currIm1 = currIm2;
		currIm2 = leftImages[i];
		currImR = rightImages[i-1];
		if (!skipNextPair) {
			threadGroup.create_thread(boost::bind(&nccPyramidMatchLL, boost::cref(currIm1), boost::cref(currIm2), boost::cref(currIm1Data), boost::ref(currIm2Data)));
			threadGroup.create_thread(boost::bind(&nccPyramidMatchLR, boost::cref(currIm1), boost::cref(currImR), boost::ref(currIm1Data)));
		}
		threadGroup.create_thread(boost::bind(&detectNewPoints, boost::cref(currIm2), boost::ref(currIm2Data), boost::ref(exitStatus)));
		threadGroup.join_all();
		if (exitStatus) {
			skipNextPair = true;
		}
		bitwise_or(currIm2Data.maskPrev, currIm1Data.maskLR, currIm1Data.maskNext, Mat ());
		bitwise_and(currIm1Data.correspondencesNext, zeroMask, currIm1Data.correspondencesNext, currIm1Data.maskNext);
		bitwise_and(currIm1Data.correspondencesLR, zeroMask, currIm1Data.correspondencesLR, currIm1Data.maskNext);
		bitwise_and(currIm2Data.correspondencesPrev, zeroMask, currIm2Data.correspondencesPrev, currIm1Data.maskNext);
		#ifdef SAVE_CORRESPONDENCES
		imageSetLefts.push_back(currIm1Data);
		#endif
	}
	#ifdef SAVE_CORRESPONDENCES
	imageSetLefts.push_back(currIm2Data);
	#endif
	//last image does not have left-right correspondences!
	#ifdef TIMER
	time_t end = time(NULL);
	int time = end-start;
	cout << "elapsed time: " << time << " s" << endl;
	cout << "processing rate: " << (float) numImages/time << " fps" << endl;
	cout << "finished processing images" << endl;
	#endif

	/* save the correspondence matrix pairs */
	#ifdef SAVE_CORRESPONDENCES
	cout << "saving correspondence matrices" << endl;
	char resultNextFile[100];
	char resultRightFile[100];
	char resultPrevFile[100];
	int k = 1;
	for (int i = 1; i < (int) imageSetLefts.size(); i++) {
		// cout << "saving astromat " << i << endl;
		currIm1Data = imageSetLefts[i-1];
		currIm2Data = imageSetLefts[i];
		if (!(currIm1Data.correspondencesNext.empty()) && !(currIm2Data.correspondencesPrev.empty())) {
			sprintf(resultNextFile, "%s%04d%s", "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/astromats_three/corrNext", k, ".txt");
			sprintf(resultRightFile, "%s%04d%s", "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/astromats_three/corrRight", k, ".txt");
			sprintf(resultPrevFile, "%s%04d%s", "/home/likewise-open/ASTROBOTIC/dylan.koenig/Documents/astromats_three/corrPrev", k+1, ".txt");
			writeMat(currIm1Data.correspondencesNext, resultNextFile);
			writeMat(currIm1Data.correspondencesLR, resultRightFile);
			writeMat(currIm2Data.correspondencesPrev, resultPrevFile);
			k++;
		}
	}
	#endif
	cout << "all done" << endl;
}

// void astrovision(const Mat& im1, const Mat& im2, const Mat& imR, imageData& im1Data, imageData& im2Data, bool firstSet) {
// 	if (firstSet) {
// 		vector<double> im1Strengths;
// 		vector<Point2f> im1Corners;
// 		harris(im1, im1Strengths, im1Corners);
// 		suppress(im1Corners, im1Strengths, im1Data.correspondencesNext);
// 	}
// 	boost::thread_group threadGroup;
// 	threadGroup.create_thread(boost::bind(&nccPyramidMatchLL, im1, im2, im1Data, im2Data));
// 	threadGroup.create_thread(boost::bind(&nccPyramidMatchLR, im1, imR, im1Data));
// 	threadGroup.create_thread(boost::bind(&detectNewPoints, im2, im2Data));
// 	threadGroup.join_all();
// 	#ifdef SAVE_CORRESPONDENCES
// 	imageSetLefts.push_back(im1Data);
// 	#endif
// }

void nccPyramidMatchLL(const Mat& im1, const Mat& im2, const imageData& im1Data, imageData& im2Data) {
	const double threshCorr = .7;
	// const double russianGranny = -2147483648;
	// const double russianGranny = 1.05;
	const int imHeight = im1.rows, imWidth = im1.cols, descHalfSize2 = 4, windowHalfSize2 = 5;
	const int imScale = 4;
	// const int xccSize = windowHalfSize*2 - descHalfSize*2 + 1;
	// const int xcc2Size = imScale*(windowHalfSize2*2 - descHalfSize2*2) + 1;
	// const int xDim, yDim;
	// const bool top, left;
	float invalidCount = 0;
	// float maxRowOffset = 0, maxColOffset = 0;
	float currIm2Row, currIm2Col;
	double rowOffset, colOffset, newRow, newCol, currRow, currCol;
	double peakCorrVal;
	Mat mean, stdDev;
	// double secondPeakVal, secoundPeakValR;
	Point peakCorrLoc;
	Mat currDesc(descHalfSize+descHalfSize,descHalfSize+descHalfSize,CV_8UC1);
	Mat newDesc(descHalfSize2+descHalfSize2,descHalfSize2+descHalfSize2,CV_8UC1);
	// Mat descResize((descHalfSize2+descHalfSize2)*imScale,(descHalfSize2+descHalfSize2)*imScale,CV_8UC1);
	Mat descResize;
	Mat currWindow(windowHalfSize+windowHalfSize,windowHalfSize+windowHalfSize,CV_8UC1);
	Mat currWindowShrink, currDescShrink;
	Mat newWindow(windowHalfSize2+windowHalfSize2,windowHalfSize2+windowHalfSize2,CV_8UC1);
	// Mat windowResize((windowHalfSize2+windowHalfSize2)*imScale,(windowHalfSize2+windowHalfSize2)*imScale,CV_8UC1);
	Mat windowResize;
	Mat xcc, xcc2;
	// Mat xcc(xccSize, xccSize, CV_32FC1);
	// Mat xccR(xccSize, xccSize, CV_32FC1);
	// Mat xcc2(xcc2Size, xcc2Size, CV_32FC1);
	// Mat xccR2(xcc2Size, xcc2Size, CV_32FC1);
	im2Data.correspondencesPrev.create(numPoints, 2, CV_32FC1);
	im2Data.maskPrev = Mat::zeros(numPoints, 2, CV_8UC1);
	Mat im1Pts = im1Data.correspondencesNext;

	for (int i = 0; i < numPoints; i++) {
		currCol = (double) round(im1Pts.at<float>(i,0));
		currRow = (double) round(im1Pts.at<float>(i,1));
		currDesc = im1(Range(currRow-descHalfSize,currRow+descHalfSize),Range(currCol-descHalfSize,currCol+descHalfSize));
		resize(currDesc, currDescShrink, Size(0,0), 1.0/shrinkScale, 1.0/shrinkScale, INTER_CUBIC);
		currDescShrink.convertTo(currDescShrink, CV_32FC1);
		meanStdDev(currDescShrink, mean, stdDev, Mat());
		currDescShrink = (currDescShrink - mean.at<double>(0,0))/stdDev.at<double>(0,0);
		// cout << currDescShrink << endl;
		GaussianBlur(currDescShrink, currDescShrink, Size(3,3), .5, .5, BORDER_DEFAULT);
		currWindow = im2(Range(currRow-windowHalfSize,currRow+windowHalfSize),Range(currCol-windowHalfSize,currCol+windowHalfSize));
		resize(currWindow, currWindowShrink, Size(0,0), 1.0/shrinkScale, 1.0/shrinkScale, INTER_CUBIC);
		currWindowShrink.convertTo(currWindowShrink, CV_32FC1);
		meanStdDev(currWindowShrink, mean, stdDev, Mat());
		currWindowShrink = (currWindowShrink - mean.at<double>(0,0))/stdDev.at<double>(0,0);
		GaussianBlur(currWindowShrink, currWindowShrink, Size(3,3), .5, .5, BORDER_DEFAULT);

		//compute LL NCC
		matchTemplate(currWindowShrink, currDescShrink, xcc, CV_TM_CCORR_NORMED);
		// ncc(currDesc, currWindow, xcc);
		// minMaxLoc(xcc, 0, &peakCorrVal, 0, &peakCorrLoc, Mat());
		peakCorrVal = findMaxGen(xcc, peakCorrLoc);
		// xcc.at<float>((float) peakCorrLoc.y,(float) peakCorrLoc.x) = -2147483648;
		//find second max for russian granny, disabled for now
		// minMaxLoc(xcc, 0, &secondPeakVal, 0, 0, Mat());
		// secondPeakVal = 0;
		rowOffset = ((double) peakCorrLoc.y)*((double) shrinkScale) - (double) (windowHalfSize - descHalfSize);
		colOffset = ((double) peakCorrLoc.x)*((double) shrinkScale) - (double) (windowHalfSize - descHalfSize);
		newRow = currRow + rowOffset;
		newCol = currCol + colOffset;

		//threshold and russian granny (disabled) the ncc result
		if ((peakCorrVal < threshCorr) || outOfBounds(newRow, newCol, imWidth, imHeight)) {
			invalidCount = invalidCount + 1;
			im2Data.maskPrev.at<unsigned char>(i,0) = 0xFF;
			im2Data.maskPrev.at<unsigned char>(i,1) = 0xFF;
			// im2Data.maskPrev.row(i) = Scalar::all(0);
			// im2Data.maskPrev.row(i) = Mat::zeros(1,2,CV_32FC1);
			continue;
		}
		//subpixelize LL correspondence
		newDesc = im1(Range(currRow-descHalfSize2,currRow+descHalfSize2),Range(currCol-descHalfSize2,currCol+descHalfSize));
		resize(newDesc, descResize, Size(imScale*descHalfSize2*2,imScale*descHalfSize2*2), 0, 0, INTER_CUBIC);
		newWindow = im2(Range(newRow-windowHalfSize2,newRow+windowHalfSize2),Range(newCol-windowHalfSize2,newCol+windowHalfSize2));
		resize(newWindow, windowResize, Size(imScale*windowHalfSize2*2,imScale*windowHalfSize2*2), 0, 0, INTER_CUBIC);
		// cout << windowResize << endl;
		// cout << descResize << endl;
		matchTemplate(windowResize, descResize, xcc2, CV_TM_CCORR_NORMED);
		// minMaxLoc(xcc2, 0, 0, 0, &peakCorrLoc, Mat());
		findMaxGen(xcc2, peakCorrLoc);
		//similar to old offset calculation method
		// rowOffset = ((double) peakCorrLoc.y)/((double) imScale) - (double) ((newRow - windowHalfSize2) - (currRow - descHalfSize2));
		// colOffset = ((double) peakCorrLoc.x)/((double) imScale) - (double) ((newCol - windowHalfSize2) - (currCol - descHalfSize2));
		//new subpixel offset calculation method
		rowOffset = ((double) peakCorrLoc.y)/((double) imScale) - (double) (windowHalfSize2 - descHalfSize2);
		colOffset = ((double) peakCorrLoc.x)/((double) imScale) - (double) (windowHalfSize2 - descHalfSize2);

		currIm2Row = (float) (newRow + rowOffset);
		currIm2Col = (float) (newCol + colOffset);
		im2Data.correspondencesPrev.at<float>(i,0) = currIm2Col;
		im2Data.correspondencesPrev.at<float>(i,1) = currIm2Row;

		//check if new point is outside of the tolerance frame
		if (outOfBounds(currIm2Row, currIm2Col, imWidth, imHeight)) {
			invalidCount = invalidCount + 1;
			im2Data.maskPrev.at<unsigned char>(i,0) = 0xFF;
			im2Data.maskPrev.at<unsigned char>(i,1) = 0xFF;
			// im2Data.maskPrev.row(i) = Scalar::all(0);
			// im2Data.maskPrev.row(i) = Mat::zeros(1,2,CV_32FC1);
			continue;
		}
	}
	#ifdef DISPLAY_MATCH_COUNT
	cout << numPoints - invalidCount << " valid LL matches found" << endl;
	#endif
}

void detectNewPoints(const Mat& im, imageData& imData, int& exitStatus) {
	#ifdef VERBOSE
	cout << "acquiring new points" << endl;
	#endif
	vector<double> imStrengths;
	vector<Point2f> imCorners;
	// Mat imSuppressed(numPoints,2,CV_32FC1);
	if (harris(im, imStrengths, imCorners)) {
		exitStatus = 1;
		return;
	}
	#ifdef DISPLAY_CORNER_COUNT
	cout << imCorners.size() << " corners found" << endl;
	#endif
	//otherwise look for points not in original image
	suppress(imCorners, imStrengths, imData.correspondencesNext);
}

void nccPyramidMatchLR(const Mat& im1, const Mat& imR, imageData& im1Data) {
	const double threshCorr = .7;
	// const double russianGranny = -2147483648;
	// const double russianGranny = 1.05;
	const int imHeight = im1.rows, imWidth = im1.cols, descHalfSize2 = 4, windowHalfSize2 = 5;
	const int imScale = 4;
	// const int xccSize = windowHalfSize*2 - descHalfSize*2 + 1;
	// const int xcc2Size = imScale*(windowHalfSize2*2 - descHalfSize2*2) + 1;
	// const int xDim, yDim;
	// const bool top, left;
	float invalidCount = 0;
	// float maxRowOffset = 0, maxColOffset = 0;
	float currImRRow, currImRCol;
	double currRow, currCol;
	double rowOffsetR, colOffsetR, newRowR, newColR;
	double peakCorrValR;
	Mat mean, stdDev;
	// double secondPeakVal, secoundPeakValR;
	Point peakCorrLocR;
	Mat currDesc(descHalfSize+descHalfSize,descHalfSize+descHalfSize,CV_8UC1);
	Mat newDesc(descHalfSize2+descHalfSize2,descHalfSize2+descHalfSize2,CV_8UC1);
	// Mat descResize((descHalfSize2+descHalfSize2)*imScale,(descHalfSize2+descHalfSize2)*imScale,CV_8UC1);
	Mat descResize;
	Mat currWindowRShrink, currDescShrink;
	Mat currWindowR(windowHalfSize+windowHalfSize,windowHalfSize+windowHalfSize,CV_8UC1);
	Mat newWindow(windowHalfSize2+windowHalfSize2,windowHalfSize2+windowHalfSize2,CV_8UC1);
	// Mat windowResize((windowHalfSize2+windowHalfSize2)*imScale,(windowHalfSize2+windowHalfSize2)*imScale,CV_8UC1);
	Mat windowResize;
	Mat xccR, xccR2;
	// Mat xcc(xccSize, xccSize, CV_32FC1);
	// Mat xccR(xccSize, xccSize, CV_32FC1);
	// Mat xcc2(xcc2Size, xcc2Size, CV_32FC1);
	// Mat xccR2(xcc2Size, xcc2Size, CV_32FC1);
	im1Data.correspondencesLR.create(numPoints,2,CV_32FC1);
	im1Data.maskLR = Mat::zeros(numPoints, 2, CV_8UC1);
	Mat im1Pts = im1Data.correspondencesNext;

	for (int i = 0; i < numPoints; i++) {
		currCol = (double) round(im1Pts.at<float>(i,0));
		currRow = (double) round(im1Pts.at<float>(i,1));
		currDesc = im1(Range(currRow-descHalfSize,currRow+descHalfSize),Range(currCol-descHalfSize,currCol+descHalfSize));
		resize(currDesc, currDescShrink, Size(0,0), 1.0/shrinkScale, 1.0/shrinkScale, INTER_CUBIC);
		currDescShrink.convertTo(currDescShrink, CV_32FC1);
		meanStdDev(currDescShrink, mean, stdDev, Mat());
		currDescShrink = (currDescShrink - mean.at<double>(0,0))/stdDev.at<double>(0,0);
		GaussianBlur(currDescShrink, currDescShrink, Size(3,3), .5, .5, BORDER_DEFAULT);

		currWindowR = imR(Range(currRow-epiHalfSize,currRow+epiHalfSize),Range(currCol-windowHalfSize-descHalfSize,currCol+descHalfSize));
		resize(currWindowR, currWindowRShrink, Size(0,0), 1.0/shrinkScale, 1.0/shrinkScale, INTER_CUBIC);
		currWindowRShrink.convertTo(currWindowRShrink, CV_32FC1);
		meanStdDev(currWindowRShrink, mean, stdDev, Mat());
		currWindowRShrink = (currWindowRShrink - mean.at<double>(0,0))/stdDev.at<double>(0,0);
		GaussianBlur(currWindowRShrink, currWindowRShrink, Size(3,3), .5, .5, BORDER_DEFAULT);

		//compute LR NCC
		matchTemplate(currWindowRShrink, currDescShrink, xccR, CV_TM_CCORR_NORMED);
		// ncc(currDesc, currWindowR, xccR);
		// minMaxLoc(xccR, 0, &peakCorrValR, 0, &peakCorrLocR, Mat());
		peakCorrValR = findMaxGen(xccR, peakCorrLocR);
		// xccR.at<float>((float) peakCorrLocR.y,(float) peakCorrLocR.x) = -2147483648;
		//find second max for russian granny, disabled for now
		// minMaxLoc(xccR, 0, &secondPeakValR, 0, 0, Mat());
		// secondPeakValR = 0;
		rowOffsetR = ((double) peakCorrLocR.y)*((double) shrinkScale) - (double) (epiHalfSize - descHalfSize);
		colOffsetR = ((double) peakCorrLocR.x)*((double) shrinkScale) - (double) (windowHalfSize);
		newRowR = currRow + rowOffsetR;
		newColR = currCol + colOffsetR;

		//threshold and russian granny (disabled) the ncc result
		if ((peakCorrValR < threshCorr) || outOfBounds(newRowR, newColR, imWidth, imHeight)) {
			invalidCount = invalidCount + 1;
			im1Data.maskLR.at<unsigned char>(i,0) = 0xFF;
			im1Data.maskLR.at<unsigned char>(i,1) = 0xFF;
			// im1Data.maskLR.row(i) = Scalar::all(0);
			// im1Data.maskLR.row(i) = Mat::zeros(1,2,CV_32FC1);
			continue;
		}

		//subpixelize LR correspondence
		newDesc = im1(Range(currRow-descHalfSize2,currRow+descHalfSize2),Range(currCol-descHalfSize2,currCol+descHalfSize));
		resize(newDesc, descResize, Size(imScale*descHalfSize2*2,imScale*descHalfSize2*2), 0, 0, INTER_CUBIC);
		newWindow = imR(Range(newRowR-windowHalfSize2,newRowR+windowHalfSize2),Range(newColR-windowHalfSize2,newColR+windowHalfSize2));
		resize(newWindow, windowResize, Size(imScale*windowHalfSize2*2,imScale*windowHalfSize2*2), 0, 0, INTER_CUBIC);
		matchTemplate(windowResize, descResize, xccR2, CV_TM_CCORR_NORMED);
		// minMaxLoc(xccR2, 0, 0, 0, &peakCorrLocR, Mat());
		findMaxGen(xccR2, peakCorrLocR);
		//similar to old offset calculation method
		// rowOffset = ((double) peakCorrLoc.y)/((double) imScale) - (double) ((newRow - windowHalfSize2) - (currRow - descHalfSize2));
		// colOffset = ((double) peakCorrLoc.x)/((double) imScale) - (double) ((newCol - windowHalfSize2) - (currCol - descHalfSize2));
		//new subpixel offset calculation method
		rowOffsetR = ((double) peakCorrLocR.y)/((double) imScale) - (double) (windowHalfSize2 - descHalfSize2);
		colOffsetR = ((double) peakCorrLocR.x)/((double) imScale) - (double) (windowHalfSize2 - descHalfSize2);
		// rowOffset = 0; colOffset = 0;

		currImRRow = (float) (newRowR + rowOffsetR);
		currImRCol = (float) (newColR + colOffsetR);
		im1Data.correspondencesLR.at<float>(i,0) = currImRCol;
		im1Data.correspondencesLR.at<float>(i,1) = currImRRow;

		if (outOfBounds(currImRRow, currImRCol, imWidth, imHeight)) {
			invalidCount = invalidCount + 1;
			im1Data.maskLR.at<unsigned char>(i,0) = 0xFF;
			im1Data.maskLR.at<unsigned char>(i,1) = 0xFF;
			// im1Data.maskLR.row(i) = Scalar::all(0);
			// im1Data.maskLR.row(i) = Mat::zeros(1,2,CV_32FC1);
			continue;
		}
	}

	#ifdef DISPLAY_MATCH_COUNT
	cout << numPoints - invalidCount << " valid LR matches found" << endl;
	#endif
}

//returns N-by-2 matrix of (x,y) harris corner coordinates
int harris(const Mat& im, vector<double>& strengths, vector<Point2f>& corners) {
	Mat harrisImage = Mat::zeros(im.size(), CV_32FC1);
	// Mat harrisNorm, harrisScaled;
	cornerHarris(im, harrisImage, 3, 3, 0.04, BORDER_DEFAULT); //not sure about the k parameter

	#ifdef BINS
	#ifndef NMS
	const int rowBins = 10;
	const int colBins = 10;
	//create bins for corner storage
	const int harrisWidth = harrisImage.cols;
	const int harrisHeight = harrisImage.rows;
	const int binLimit = 15;
	const int rowDivide = (harrisHeight-halfSize*2)/rowBins;
	const int colDivide = (harrisWidth-halfSize*2)/colBins;
	int binCount = 0;
	for (int rowSection = 0; rowSection < rowBins; rowSection++) {
		for (int colSection = 0; colSection < colBins; colSection++) {
			for (int row = rowSection*rowDivide+halfSize; row < harrisHeight-rowDivide*(rowBins-rowSection-1)-halfSize; row++) {
				for (int col = colSection*colDivide+halfSize; col < harrisWidth-colDivide*(colBins-colSection-1)-halfSize; col++) {
					if (binCount > binLimit) break;
					double currVal = harrisImage.at<float>(row,col);
					if (currVal > cornerThreshold) {
						corners.push_back(Point2f((float) col,(float) row));
						strengths.push_back(currVal);
						binCount++;
					}
				}
				if (binCount > binLimit) break;
			}
			binCount = 0;
		}
	}
	#endif
	#endif

	#ifndef NMS
	#ifndef BINS
	int harrisWidth = harrisImage.cols;
	int harrisHeight = harrisImage.rows;
	for (int row = halfSize; row < harrisHeight-halfSize; row++) {
		for (int col = halfSize; col < harrisWidth-halfSize; col++) {
			double currVal = harrisImage.at<float>(row,col);
			// cout << currVal << endl;
			if (currVal > cornerThreshold) {
				corners.push_back(Point2f((float) col,(float) row));
				strengths.push_back(currVal);
			}
		}
	}
	#endif
	#endif
	
	//remove points too close to image border
	// harrisImage.rowRange(Range(0,halfSize)) = Mat::zeros(halfSize,harrisWidth,CV_32FC1);
	// harrisImage.rowRange(Range(harrisHeight-halfSize,harrisHeight)) = Mat::zeros(halfSize,harrisWidth,CV_32FC1);
	// harrisImage.colRange(Range(0,halfSize)) = Mat::zeros(harrisHeight,halfSize,CV_32FC1);
	// harrisImage.colRange(Range(harrisWidth-halfSize,harrisWidth)) = Mat::zeros(harrisHeight,halfSize,CV_32FC1);

	//non-max suppress
	#ifdef NMS
	#ifndef BINS
	nms(corners, strengths, harrisImage);
	#endif
	#endif
	
	//extract coordinates of nonzero points (the max pts)
	// corners = M(countNonZero(maxPts),2,CV_32FC1);
	// corners.create(countNonZero(maxPts),2,CV_32FC1);
	// strengths.reserve(corners.rows);
	// // findNonZero(maxPts,corners); /* finds all nonzero elements, but only in opencv>=2.4.4 */
	// int rowIndex = 0;
	// for (int row = 0; row < maxPts.rows; row++) {
	// 	for (int col = 0; col < maxPts.cols; col++) {
	// 		maxVal = maxPts.at<double>(row,col);
	// 		if (maxVal != 0) {
	// 			corners.at<float>(rowIndex,0) = (float) col;
	// 			corners.at<float>(rowIndex,1) = (float) row;
	// 			strengths.push_back(maxVal);
	// 			rowIndex++;
	// 		}
	// 	}
	// }
	if ((int) corners.size() < numPoints) return 1;
	return 0;
}

void nms(vector<Point2f>& corners, vector<double>& strengths, Mat& harrisImage) {
	int harrisWidth = harrisImage.cols;
	int harrisHeight = harrisImage.rows;
	Mat window = Mat::zeros(3,3,CV_32FC1);
	Point currMax;
	float maxVal;
	vector<bool> currRowMask(harrisWidth, true);
	for (int row = halfSize; row < harrisHeight-halfSize; row++) {
		vector<bool> nextRowMask(harrisWidth, true);
		for (int col = halfSize; col < harrisWidth-halfSize; col++) {
			// window = harrisImage(Range(row,row+suppressSize),Range(col,col+suppressSize));
			if (currRowMask[col]) {
				//using centered window
				window = harrisImage(Range(row-1,row+2),Range(col-1,col+2));
				maxVal = findMax(window, currMax);
				// minMaxLoc(window, 0, &maxVal, 0, &currMax, Mat());
				if (currMax+Point(col,row) == Point(col+1,row+1)) {
					nextRowMask[col] = false;
					if (col > 0) nextRowMask[col-1] = false;
					if (col < harrisWidth-1) nextRowMask[col+1] = false;
					if (maxVal > cornerThreshold) {
						corners.push_back(Point2f((float) col,(float) row));
						strengths.push_back(maxVal);
					}
					col = col + 1;
				}
			}
		}
		currRowMask = nextRowMask;
	}
}

void suppressSection(const int startIndex, const int numSectionPoints, const vector<Point2f>& corners, const vector<double>& strengths, vector< pair<float,float> >& distances) {
	float currDist, minDist, xi, xj, yi, yj;
	distances.reserve(numSectionPoints);
	for (int i = startIndex; i < startIndex+numSectionPoints; i++) {
		minDist = INFINITY;
		for (int j = 0; j < (int) corners.size(); j++) {
			if (i != j) {
				if (strengths[i] < (strengths[j]*.9)) {
					xi = corners[i].x;
					yi = corners[i].y;
					xj = corners[j].x;
					yj = corners[j].y;
					currDist = sqrt(((xj-xi)*(xj-xi)) + ((yj-yi)*(yj-yi)));
					if (currDist < minDist) minDist = currDist;
				}
			}
		}
		distances.push_back(pair<float,float>(minDist,i));
	}
}

void suppress(const vector<Point2f>& corners, const vector<double>& strengths, Mat& suppressedPoints) {
	// float currDist, minDist, xj, yj;
	float xi, yi;
	vector< pair<float,float> > distances, distances1, distances2, distances3, distances4;
	distances.reserve(corners.size());
	boost::thread_group threadGroup;

	int numSectionPoints = (int) corners.size()/4;

	threadGroup.create_thread(boost::bind(&suppressSection, 0, numSectionPoints, boost::cref(corners), boost::cref(strengths), boost::ref(distances1)));
	threadGroup.create_thread(boost::bind(&suppressSection, numSectionPoints, numSectionPoints, boost::cref(corners), boost::cref(strengths), boost::ref(distances2)));
	threadGroup.create_thread(boost::bind(&suppressSection, numSectionPoints*2, numSectionPoints, boost::cref(corners), boost::cref(strengths), boost::ref(distances3)));
	threadGroup.create_thread(boost::bind(&suppressSection, numSectionPoints*3, (int) corners.size() - numSectionPoints*3, boost::cref(corners), boost::cref(strengths), boost::ref(distances4)));
	threadGroup.join_all();
	distances.insert(distances.end(), distances1.begin(), distances1.end());
	distances.insert(distances.end(), distances2.begin(), distances2.end());
	distances.insert(distances.end(), distances3.begin(), distances3.end());
	distances.insert(distances.end(), distances4.begin(), distances4.end());

	//unthreaded version for testing
	// suppressSection(0, numSectionPoints, corners, strengths, distances1);
	// suppressSection(numSectionPoints, numSectionPoints, corners, strengths, distances2);
	// suppressSection(numSectionPoints*2, numSectionPoints, corners, strengths, distances3);
	// suppressSection(numSectionPoints*3, (int) corners.size()-numSectionPoints*3, corners, strengths, distances4);

	// for (int i = 0; i < (int) corners.size(); i++) {
	// 	minDist = INFINITY;
	// 	for (int j = 0; j < (int) corners.size(); j++) {
	// 		if (i != j) {
	// 			if (strengths[i] < (strengths[j]*.9)) {
	// 				xi = corners[i].x;
	// 				yi = corners[i].y;
	// 				xj = corners[j].x;
	// 				yj = corners[j].y;
	// 				currDist = sqrt(((xj-xi)*(xj-xi)) + ((yj-yi)*(yj-yi)));
	// 				if (currDist < minDist) minDist = currDist;
	// 			}
	// 		}
	// 	}
	// 	distances.push_back(pair<float,float>(minDist,i));
	// }
	sort(distances.begin(), distances.end(), comparePair);
	for (int i = 0; i < numPoints; i++) {
		xi = corners[distances[i].second].x;
		yi = corners[distances[i].second].y;
		suppressedPoints.at<float>(i,0) = xi;
		suppressedPoints.at<float>(i,1) = yi;
	}
}

//generalized
double findMaxGen(const Mat& window, Point& maxPoint) {
	float currVal;
	double maxVal = 0;
	for (int row = 0; row < (int) window.rows; row++) {
		for (int col = 0; col < (int) window.cols; col++) {
			currVal = window.at<float>(row,col);
			if (currVal > maxVal) {
				maxVal = currVal;
				maxPoint = Point(col,row);
			}
		}
	}
	return maxVal;
}

//for granny, returns the russian granny ratio (RGR)
double findMaxGran(const Mat& window, Point& maxPoint) {
	float currVal;
	double maxVal = 0;
	double secondVal = 0;
	for (int row = 0; row < (int) window.rows; row++) {
		for (int col = 0; col < (int) window.cols; col++) {
			currVal = window.at<float>(row,col);
			if (currVal > maxVal) {
				secondVal = maxVal;
				maxVal = currVal;
				maxPoint = Point(col,row);
			}
			else if (currVal > secondVal) {
				secondVal = currVal;
			}
		}
	}
	return (maxVal/secondVal);
}
//hardcoded for 3x3 windows
double findMax(const Mat& window, Point& maxPoint) {
	float currVal;
	double maxVal = 0;
	for (int row = 0; row < 3; row++) {
		for (int col = 0; col < 3; col++) {
			currVal = window.at<float>(row,col);
			if (currVal > maxVal) {
				maxVal = currVal;
				maxPoint = Point(col,row);
			}
		}
	}
	return maxVal;
}

// void ncc(const Mat& desc, const Mat& window, Mat& result) {
// 	float descVal, windowVal;
// 	float numerator;
// 	float descDenom = 0;
// 	float windowDenom;
// 	bool firstRun = true;
// 	for (int row = 0; row < result.rows; row++) {
// 		for (int col = 0; col < result.cols; col++) {
// 			numerator = 0;
// 			windowDenom = 0;
// 			for (int rowDesc = 0; rowDesc < desc.rows; rowDesc++) {
// 				for (int colDesc = 0; colDesc < desc.cols; colDesc++) {
// 					descVal = desc.at<unsigned char>(rowDesc,colDesc);
// 					windowVal = window.at<unsigned char>(row+rowDesc,col+colDesc);
// 					numerator += descVal*windowVal;
// 					if (firstRun) {
// 						descDenom += descVal*descVal;
// 					}
// 					windowDenom += windowVal*windowVal;
// 				}
// 			}
// 			firstRun = false;
// 			result.at<float>(row,col) = numerator/sqrt(descDenom*windowDenom);
// 		}
// 	}
// }

bool comparePair(const pair<float, float>& pair1, const pair<float, float>& pair2) {
	return pair1.first > pair2.first;
}

bool outOfBounds(double row, double col, int imWidth, int imHeight) {
	return ((row < (outOfBoundsBorder - 1)) || (col < (outOfBoundsBorder- 1)) || (row > (imHeight - outOfBoundsBorder)) || (col > (imWidth - outOfBoundsBorder)));
}

// void invalidatePoint(int point, Mat& corrNext, Mat& corrPrev, Mat& corrLR) {
// 	corrNext.at<float>(point,0) = NAN;
// 	corrNext.at<float>(point,1) = NAN;
// 	corrPrev.at<float>(point,0) = NAN;
// 	corrPrev.at<float>(point,1) = NAN;
// 	corrLR.at<float>(point,0) = NAN;
// 	corrLR.at<float>(point,1) = NAN;
// }

void writeMat(const Mat& matrix, const char *filename) {
	ofstream fout(filename);

	if (!fout) {
		cout << "error, file not opened" << endl;
	}
	else {
		for (int i = 0; i < matrix.rows; i++) {
			for (int j = 0; j < matrix.cols; j++) {
				fout << (float) matrix.at<float>(i,j) << "\t";
			}
			fout << endl;
		}
		fout.close();
	}
}
