#pragma once

#if defined(_WIN32)
//TODO: 라이브러리 분리때 수정.
#ifdef LSAPI_EXPORTS 

#define LSFINDER_DLL __declspec(dllexport) 
#else
#define LSFINDER_DLL __declspec(dllimport) 
#endif
#define _CALLBACK __stdcall
#else // not _WIN32

#define LSFINDER_DLL 

#define _CALLBACK  

#endif // _WIN32

#include <string>
#include <memory>

class LinkSquareDevice
{
public:
	std::string FullName = "";
	std::string IP = "";
	uint16_t Port = 0;
	std::string Alias = "";
};


typedef void(_CALLBACK *FoundNewDeviceFunc)(std::shared_ptr<LinkSquareDevice> newDevice);

#if defined(STRATIO_TOOL) || !defined(PUBLIC_SDK)
namespace LSAPI {


	LSFINDER_DLL int SmartConfig_Start(const std::string& ssid, const std::string& key, const std::string& gatewayIp);
	LSFINDER_DLL int SmartConfig_Stop();

	LSFINDER_DLL void LinkSquareFinder_RegisterCallback(FoundNewDeviceFunc func);
	LSFINDER_DLL int LinkSquareFinder_Start();
	LSFINDER_DLL int LinkSquareFinder_Stop();
}
#endif // Not PUBLIC_SDK
