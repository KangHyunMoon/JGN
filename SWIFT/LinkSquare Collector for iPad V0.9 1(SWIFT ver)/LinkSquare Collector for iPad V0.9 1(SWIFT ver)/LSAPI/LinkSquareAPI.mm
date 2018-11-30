//
//  LinkSquareAPI.m
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//


// 이 파일은  LinkSquareAPI.h에서 선언된 매서드들이
// 실제로 구현된 파일입니다. (object-c에서 사용이 가능하도록 작성)
// C++에서 사용되는 '벡터'개념이 없으므로 많은 부분에서 NSArray로 변환 작업을 거친 후의 모습입니다.
// 해보면 알겠지만 엄청 노가다입니다.. 한 3주 걸림..


#import "LinkSquareAPI.h"
#import <LinkSquareAPI/LSAPI.h>
#import <LinkSquareAPI/LSAPI_internal.h>
#import <LinkSquareAPI/LSFinder.h>

LinkSquare api = nullptr;

//std::vector<std::shared_ptr<LinkSquareDevice>> devices;
// 디바이스가 벡터로 선언되어있는데, 다른 부분에서 NSArray로 구현되어 있습니다.

@interface LinkSquareAPI () {
    const char *lsIp;
    int lsPort;
}
// 클래스(인터페이스) 선언

@end

@implementation LinkSquareAPI

+(LinkSquareAPI *)sharedInstance {
    static LinkSquareAPI *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}
// 인스턴스 동적생성 부분

-(void)findDeviceFunc{
    
    
}
//사용하지 않습니다

-(void)setIpAddress:(const char *)ipAddress andPort:(int)portNumber{
    lsIp = ipAddress;
    lsPort = portNumber;
}
//아이피 설정매서드


-(void)setupScanCallback:(ScanBlock)blk {
    self.scanCallback = [blk copy];
}
// 스캔 콜백


-(void)setupErrorCallback:(ErrorBlock)blk {
    self.errorCallback = [blk copy];
}
// 에러 콜백


-(void)setupConnectionWithCallback:(ConnectionBlock)blk {
    if (!api) {
        api = LSAPI::Initialize();
    }
    
    if (blk) {
        self.connectCallback = [blk copy];
    }
    
    LSAPI::RegisterEventCallback(api, DeviceCallback, (__bridge void*)self);
    NSLog(@"Connect %s\n %d", lsIp, lsPort);
    int connected = LSAPI::Connect(api, lsIp, lsPort);
    
    if (connected) {
        NSLog(@"connected");
        //self.connectCallback(YES, @"Connected");
    } else {
        NSLog(@"fail");
        //self.connectCallback(NO, @"Failed to Connect");
    }
}
// 커넥션 콜백

-(void)closeConnection {
    LSAPI::Close(api);
}
// 연결 종료 매서드

-(void)scanLED:(int)ledFrames andBULB:(int)bulbFrames doSNV:(BOOL)doSNV withCallback:(AnalyzeBlock)blk {
    if (blk) {
        self.analyzeCallback = [blk copy];
    }
    
    // 스캔 매서드입니다.
    
    std::vector<LSFRAME *> frames;

    //    int scanResult = 0;
    
    int scanResult = LSAPI::Scan(api, ledFrames, bulbFrames, frames);
    
    unsigned short *ledData[ledFrames];
    unsigned short *bulbData[bulbFrames];
    
    //float *averagedData = [self averageFrames:frames withLED:ledFrames andBULB:bulbFrames];


    
    if (!scanResult) {
        NSLog(@"Scan Failed");
    } else {
        NSLog(@"Scan Success");
        
        NSMutableArray *raw_data= [[NSMutableArray alloc]init];
        NSMutableArray *data= [[NSMutableArray alloc]init];
        NSMutableArray *raw= [[NSMutableArray alloc]init];
        for (int i=0;i<frames.size();i++) {
            //NSValue *value = [NSValue valueWithBytes:&frames[i]->raw_data objCType:@encode(unsigned short) ];
            NSData *value = [[NSData alloc]init];
            
            for (int j=0; j<600; j++){
                value = [NSData dataWithBytes:&(frames[i]->raw_data[0])+j length:sizeof(unsigned short)*1];
                
                NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
                NSString *result = [[value description] stringByTrimmingCharactersInSet:charsToRemove];
                
                NSString *temp_result_front = [result substringWithRange:NSMakeRange(0, 2)];
                
                
                NSString *temp_result_back = [result substringWithRange:NSMakeRange(2, 2)];
                
                NSString *comb_result = @"";
                
                comb_result = [comb_result stringByAppendingString: temp_result_back];
                comb_result = [comb_result stringByAppendingString: temp_result_front];
                
                //hax -> decimal
                NSScanner *scanner = [NSScanner scannerWithString:comb_result];
                unsigned int decimal;
                [scanner scanHexInt:&decimal];
                
                NSNumber *aNumber = [NSNumber numberWithInt:decimal];
                
                
                [raw_data addObject:aNumber];
            }
            
            value = [NSData dataWithBytes:&frames[i]->data[0] length:sizeof(float)*600];
            [data addObject:value];
            value = [NSData dataWithBytes:&frames[i]->raw[0] length:sizeof(unsigned char)*600];
            [raw addObject:value];
        }
        
        self.analyzeCallback(YES, raw_data, data, raw);
    }
}




-(float *)averageFrames:(std::vector<LSFRAME *>)frames withLED:(int)ledFrames andBULB:(int)bulbFrames{
    std::vector<LSFRAME *>led = std::vector<LSFRAME *>(frames.begin(), frames.begin() + ledFrames);
    std::vector<LSFRAME *>bulb = std::vector<LSFRAME *>(frames.begin() + ledFrames, frames.end());
    
    float *ledData = [self extractFrameData:led doAverage:NO];
    float *bulbData = [self extractFrameData:bulb doAverage:NO];
    
    for(int i=0;i<300;i++)
        NSLog(@"ledData = %f", ledData[i]);
    
    NSDictionary *metaData;
    int algoWidth = [[metaData objectForKey:@"algWidth"] intValue];
    int algoHeight = [[metaData objectForKey:@"algHeight"] intValue];
    int dataSize = algoWidth * algoHeight;
    
    //create new float array to store frame data
    float *frameData = new float[dataSize * 2];
    
    //copy led data to result
    std::copy(ledData, ledData + dataSize, frameData);
    //copy bulb data to result
    std::copy(bulbData, bulbData + dataSize, frameData + dataSize);
    
    delete[] ledData;
    delete[] bulbData;
    
    return frameData;
}
// 사용 안함

-(float *)extractFrameData:(std::vector<LSFRAME *>)frames doAverage:(BOOL)doAvg {
    int numberOfFrames = static_cast<int>(frames.size());
    
    NSDictionary *metaData = metaData;
    //    int algoHeight = [[metaData objectForKey:@"algHeight"] intValue];
    //    int algoWidth = [[metaData objectForKey:@"algWidth"] intValue];
    //
    //    int algColStart = [[metaData objectForKey:@"algColStart"] intValue];
    //    int algColStride = [[metaData objectForKey:@"algColStride"] intValue];
    
    int algoHeight = 600;
    int algoWidth = 1;
    
    int algColStart = 0;
    int algColStride = 1;
    
    int algSize = algoWidth * algoHeight;
    
    float *returnData = new float[algSize];
    
    if (doAvg) {
        for (int i = 0; i < numberOfFrames; i++) {
            float *frameData = frames[i]->data;
            
            
            for (int j = 0; j < algSize; j++) {
                int sourceIndex = algColStart + (j * algColStride);
                
                returnData[j] = (i == 0) ? frameData[sourceIndex] : (returnData[j] + frameData[sourceIndex]);
                
                //if last frame, average data
                if (i == numberOfFrames - 1) {
                    returnData[j] = returnData[j] / numberOfFrames;
                }
            }
        }
    } else {
        //get the middle index for the frames
        int targetFrameIndex = static_cast<int>(floor(numberOfFrames / 2.0));
        
        float *normalizedData = frames[targetFrameIndex]->data;
        for (int i = 0; i < algSize; i++) {
            int sourceIndex = algColStart + (i * algColStride);
            returnData[i] = normalizedData[sourceIndex];
            
        }
    }
    return returnData;
}

-(bool)checkConnected {
    return LSAPI::IsConnected(api);
}
// 현재 연결상황 체크 매서드

void DeviceCallback(void* userData, LSDeviceEventType type, int value)
{
    if (type == LSDeviceEventType::ButtonEvent)
    {
        NSLog(@"Button Push");
        dispatch_async(dispatch_get_main_queue(), ^{
            ((__bridge LinkSquareAPI *)userData).scanCallback();
        });
        
        //ScanVC *array = [[ScanVC alloc]init];
        
    }
    else if (type == LSDeviceEventType::TimeoutEvent)
    {
        NSLog(@"Device Network Timeout");
        LSAPI::Close(api);
    }
    else if (type == LSDeviceEventType::NetworkCloseEvent)
    {
        NSLog(@"Device Network Closed");
        LSAPI::Close(api);
    }
}

@end


