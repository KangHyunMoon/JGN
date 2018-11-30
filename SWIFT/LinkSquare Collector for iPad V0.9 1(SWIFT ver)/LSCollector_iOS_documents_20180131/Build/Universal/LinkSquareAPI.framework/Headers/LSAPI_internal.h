#pragma once

#define INTERNAL

#if !defined(STRATIO_TOOL) && defined(PUBLIC_SDK)
#error "This header is Stratio INTERNAL use only."
#endif // PUBLIC_SDK

#include "LSAPI.h"

typedef enum _eventType_internal {
	//ButtonEvent = 0,
	//TimeoutEvent = 1,
	//NetworkCloseEvent = 2,
	UpdateProgress = 3, // Value 0 ~ 100
	ScanFrameProgress = 4, // Scan Frame
	ScanAsyncFinished = 5,
} LSDeviceEventType_Stratio;



/**
 struct LSFRAME

 Fields
   length: Length of the current frame. Default value is 600.
   frame_no: A unique identifier assigned to each frame in a scan.
             The first frame has the frame number of 1, and it increases by one for each frame.
   raw_data: The pointer to an array that has frame data. Each pixel is represented with unsigned short type (16-bit).
		  Please note that 'raw_data' is flipped in the dimension of 'width' from the 'raw' array.
		  (Internal use only)
   data: The pointer to an array that has normalized frame data. Each float value is corresponding to a pixel value of 'recon'.
   raw: The pointer to an array that has raw frame data. Each pixel is represented with unsigned char type (8-bit).
        This spectrum data requires MSB reconstruction and defect removal to be meaningful.
		(Internal use only)

  Remarks
    At the end of 'Scan' function, several frames of spectrum data is ready as a vector of LSFRAME struct pointers.
	Calling 'GetData' function returns this vector, so that the application can retrieve frame data.
	Each struct represents a frame with some additional information from a frame header, such as size of the frame,
	and the sequence/frame numbers. Currently, the width and height do not change in the middle of a sequence.
**/
typedef struct {
	int length;
	unsigned char light_source;
	int frame_no;
	unsigned short *raw_data;
	float *data;
	unsigned char *raw;
} LSFRAME_Internal;

typedef struct {
    
    int length;
    unsigned char light_source;
    int frame_no;
    unsigned short raw_data[600];
    float data[600];
    unsigned char raw[600];
} LSFRAME_Internal1;


// to avoid redefinition of typedef struct LSFRAME
#define LSFRAME LSFRAME_Internal
#define LSFRAME1 LSFRAME_Internal1


/**
struct LSCONFIG

Fields
hstart: start of the row
cstart: start of the column
height: height of a frame
width: width of a frame
hskip: row skip
cskip: column skip
lframe: number of frames under LED (VIS) light
bframe: number of frames under bulb (IR) light
intg_ltime: integration time under LED (VIS) light
intg_btime: integration time under bulb (IR) light
intg_dtime: integration time without light (for HSI)

Remarks
This structure represents the configuration file that LinkSquare device uses.
**/
typedef struct {
	int intg_wtime;
	int intg_btime;
	int intg_dtime;
	int cstart_dark;
	int cstart_bulb;
	int cstart_white;
	int row_num;

} LSCONFIG;


namespace LSAPI {

	/**
	int DarkScan(LinkSquare h, int numFrames)

	Params
	h [in]: Handle for LinkSquare device
	numFrames [in]: The number of spectrum data frames to be taken

	Return
	Upon successful completion, the HSI function returns the number of frames taken,
	which should be the same as the sum of numLEDFrames and numBulbFrames.
	Otherwise, the description about the error can be retrieved by calling GetLastError.

	Remarks
	Scan function sends the command to the LinkSquare device and receives the spectrum data frames.
	When there is an error, Scan function clears the received data and flush the remaining incoming data.
	Thus, in case of error, it is no use of calling GetData function to retrieve the received data.
	**/
	LSAPI_DLL int DarkScan(LinkSquare h, int numFrames, std::vector<LSFRAME_Internal*>& frames);

	LSAPI_DLL int ControlLight(LinkSquare h, bool vis, bool infrared);
	LSAPI_DLL int GetSensorRegister(LinkSquare h, unsigned char addr, unsigned short& value);
	LSAPI_DLL int SetSensorRegister(LinkSquare h, unsigned char addr, unsigned short value);

	LSAPI_DLL int SetStartCol(LinkSquare h, int lightSource, int startCol);
	LSAPI_DLL int SetExposure(LinkSquare h, int lightSource, int exposure);

	LSAPI_DLL int GetConfigFile(LinkSquare h, LSCONFIG* conf);
	LSAPI_DLL int SetConfigFile(LinkSquare h, LSCONFIG* conf);
	LSAPI_DLL int UpdateSoftware(LinkSquare h, const char* bin, int len);

	LSAPI_DLL int ScanAsync(LinkSquare h, int index, int numLEDFrames, int numBulbFrames);

	// overloading Scan function signature from LSFAME to LSFRAME_Internal
	LSAPI_DLL int Scan(LinkSquare h, int numLEDFrames, int numBulbFrames, std::vector<LSFRAME_Internal*>& frames);
	
	//LSAPI_DLL int GetFrame(LinkSquare h, int index, LSFRAME** pFrame);
	LSAPI_DLL int GetFrame(LinkSquare h, int index, LSFRAME_Internal** pFrame);
	LSAPI_DLL int GetFrameSize(LinkSquare h);
	

	// For Device ID Test Only
	LSAPI_DLL int _SetDeviceID(LinkSquare h, std::string deviceID, std::string alias);
};
