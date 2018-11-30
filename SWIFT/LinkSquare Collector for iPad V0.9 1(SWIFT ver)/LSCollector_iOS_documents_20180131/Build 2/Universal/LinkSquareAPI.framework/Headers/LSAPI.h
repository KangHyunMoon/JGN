#pragma once
/*
 LSAPI.h

 This file defines the interface between LinkSquare device and user application for data collection.

 Last updated by Yongho Jang (yongho.jang@stratiotechnology.com), 9/25/2017
*/

#if defined(_WIN32)
#ifdef LSAPI_EXPORTS
#define LSAPI_DLL __declspec(dllexport) 
#else
#define LSAPI_DLL __declspec(dllimport) 
#endif
#define LSAPI_CALLBACK __stdcall

#else // not _WIN32

#define LSAPI_DLL 
#define LSAPI_CALLBACK 

#endif // _WIN32

#include <string>
#include <vector>

typedef void *LinkSquare;

using namespace std;

/**
 struct LSFRAME

 Fields
   length: length of the current frame. Default value is 600.
   light_source: Light source of the current frame.
   frame_no: A unique identifier assigned to each frame in a scan.
             The first frame has the frame number of 1, and it increases by one for each frame.
   raw_data: The pointer to an array that has frame data. Each pixel is represented with unsigned short type (16-bit).
   data: The pointer to an array that has normalized frame data. Each float value is corresponding to a pixel value of 'recon'.

  Remarks
    At the end of 'Scan' function, several frames of spectrum data is ready as a vector of LSFRAME struct pointers.
	Calling 'GetData' function returns this vector, so that the application can retrieve frame data.
	Each struct represents a frame with some additional information from a frame header, such as size of the frame,
	and the sequence/frame numbers.
**/
typedef struct {
	int length;
	unsigned char light_source;
	int frame_no;
	unsigned short *raw_data;
	float *data;
} LSFRAME;

/**
struct LSDeviceInfo

Fields
SWVersion: Software version of currently connected LinkSquare device.
HWVersion: Hardware version of currently connected LinkSquare device.
DeviceID: Unique Device ID(UDID) of currently connected LinkSquare device.
Alias: The name of currently connected LinkSquare device.
OPMode: The operation mode of currently connected LinkSquare device.

**/
typedef struct {
	const char* SWVersion;
	const char* HWVersion;
	const char* DeviceID;
	const char* Alias;
	const char* OPMode;
} LSDeviceInfo;

/*
LSDeviceEventType
*/
typedef enum _eventType{
	ButtonEvent = 0,
	TimeoutEvent = 1,
	NetworkCloseEvent = 2,
} LSDeviceEventType;

/*
Params
	type [in]: Type of callback event. (0: The button on LinkSquare device was pressed)
*/
typedef void(LSAPI_CALLBACK *DeviceEventCallbackFn)(void* userData, LSDeviceEventType type, int value);

/*
namespace LSAPI

This namespace represents an interface between a LinkSquare device and the user application for data collection.
Currently, only one LinkSquare can be supported at a time.
*/
namespace LSAPI {

	/**
	LinkSquare Initialize()

	Return
		Upon successful initialization, the Initialization function returns a valid (non-zero) handle for LinkSquare device.
		Otherwise, NULL is returned.

	Remarks
		Initialization function goes over all the necessary initialization steps such as socket creation, socket connection, and buffer allocation.
		In order to be successful, the LinkSquare device (or the provided LinkSquareSim_distribution program) should be already running.
		Unless successfully initialized, the subsequent calls of other member functions will fail.
	**/
	LSAPI_DLL LinkSquare Initialize();


	/**
	void Close(LinkSquare& h)

	Params
		h [inout]: LinkSquare handle returned by successful Initialize() function.

	Return
		N/A

	Remarks
		Delete / release all resources under the given LinkSquare handle.
		At the end, the handle 'h' is reset to zero to prevent further use.
	**/
	LSAPI_DLL void Close(LinkSquare& h);

	/**
	void RegisterCallback(fnDeviceScanCallbackFunc func)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.
		func [in]: Function pointer to be called depending on the event of LinkSquare device.
		userData [in]: User defined data that need to be transmitted during Callback function call.
	Return
	N/A

	**/
	LSAPI_DLL void RegisterEventCallback(LinkSquare h, DeviceEventCallbackFn func, void* userData);

	/**
	bool IsConnected(LinkSquare h)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.

	Return
		When a LinkSquare device is connected (i.e. socket is open), this function returns 'true'.
		Otherwise, it returns 'false'.

	Remarks
		N/A
	**/
	LSAPI_DLL bool IsConnected(LinkSquare h);

	/**
	int Connect(LinkSquare h, const char* IPAddr, int port)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.
		IPAddr [in]: IP address of the LinkSquare device in the form of const char *.
		port [in]: Port number at which the LinkSquare is listening.

	Return
		After successful Connect process, this function returns 1.
		Otherwise, Detail error message can be retrieved by GetLSError() function.

	Remarks
		Connect to LinkSquare device and Send Login command.
		The LinkSquare device does not accept any command before successful login process, except for AP password change.
	**/
	LSAPI_DLL int Connect(LinkSquare h, const char* IPAddr, int port);

	/**
	int ChangePassword(LinkSquare h, string oldpw, string newpw)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.
		oldpw [in]: The current AP password for verification.
		newpw [in]: 
	Return
		After successful login process, this function returns 1.
		Otherwise, Detail error message can be retrieved by GetLSError() function.

	Remarks
	Send Login command to the connected LinkSquare device.
	The LinkSquare device does not accept any command before successful login process, except for AP password change.
	**/
	LSAPI_DLL int ChangePassword(LinkSquare h, string oldpw, string newpw);

	/**
	int FactoryReset(LinkSquare h)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.
	Return
		After successful login process, this function returns 1.
		Otherwise, Detail error message can be retrieved by GetLSError() function.

	Remarks
		This function is used in LinkSquare device factory reset. The firmware of this LinkSquare device is
		reverted to the default factory setting.
	**/
	LSAPI_DLL int FactoryReset(LinkSquare h);

	/**
	int SetWLanInfo(LinkSquare h, string ssid, string password, uint8_t securityOption)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.
		ssid [in]: SSID of AP that is is used in connecting LinkSquare device during IoT Mode. Maximum 31 characters.
		password [in]:Password of AP that is used in connecting LinkSquare device during IoT Mode. Maximum 62
	Return
		After successful login process, this function returns 1.
		Otherwise, Detail error message can be retrieved by GetLSError() function.

	Remarks
		This function configures information of AP that is used in connecting LinkSquare device during IoT Mode.
	**/
	LSAPI_DLL int SetWLanInfo(LinkSquare h, string ssid, string password, uint8_t securityOption);

	/**
	int SetAlias(LinkSquare h, string alias)

	Params
		h [in]: LinkSquare handle returned by successful Initialize() function.
		alias [in]: The name of LinkSquare device. 4 to 16 characters
	Return
		After successful login process, this function returns 1.
		Otherwise, Detail error message can be retrieved by GetLSError() function.

	Remarks
		This function configures the name of LinkSquare device.
	**/
	LSAPI_DLL int SetAlias(LinkSquare h, string alias);

	/**
	int Scan(int numLEDFrames, int numBulbFrames)

	Params
        numLEDFrames [in]: The number of spectrum data frames to be taken under LED lighting. Valid input value should be between 1 and 8.
        numBulbFrames [in]: The number of spectrum data frames to be taken under bulb lighting. Valid input value should be between 1 and 8.
		frames [out]: std::vector of LSFRAME structure pointers for the most recent scan.

	Return
		Upon successful completion, the Scan function returns 1.
		Otherwise, the description about the error can be retrieved by calling GetLastError.

	Remarks
		Scan function sends the command to the LinkSquare device and receives the spectrum data frames.
		When there is an error, Scan function clears the received data and flush the remaining incoming data.
		Thus, in case of error, it is no use of calling GetData function to retrieve the received data.
	**/
	LSAPI_DLL int Scan(LinkSquare h, int numLEDFrames, int numBulbFrames, std::vector<LSFRAME*>& frames);

	/**
	const char * GetLSError()

	Params
		None

	Return
		const char * that describes the most recent error.

	Remarks
		GetLSError function returns the description of the most recent error occurred inside LSAPI scope.
		It is for debugging purpose, but also needs to be displayed at the data collection application if there is a text box for log.
		Since it only returns the description of the most recent error, any previous error will be lost.
		Calling GetLSError without an error will return an empty string.
	**/
	LSAPI_DLL const char * GetLSError();

	LSAPI_DLL int GetDeviceInfo(LinkSquare h, LSDeviceInfo* deviceInfo);
};
