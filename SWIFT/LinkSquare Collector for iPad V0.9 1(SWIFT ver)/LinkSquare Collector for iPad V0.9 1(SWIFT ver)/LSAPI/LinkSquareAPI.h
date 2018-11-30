//
//  LinkSquareAPI.h
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//
#import <Foundation/Foundation.h>

// 사용할 매서드들의 선언부분.
// 브리지 헤더에서는 이부분을 임포트해야한다.

NSArray *devices;

typedef enum _eventType{
    ButtonEvent = 0,
    TimeoutEvent = 1,
    NetworkCloseEvent = 2,
} LSDeviceEventType;


//#import "ScanVC.h"

typedef void(^ConnectionBlock)(BOOL connected, NSString *msg);
//typedef void(^AnalyzeBlock)(BOOL success, float *scanData);

typedef void(^ScanBlock)();
typedef void(^AnalyzeBlock)(BOOL success, NSArray* raw_data,NSArray* data, NSArray* raw);

typedef void(^ErrorBlock)(LSDeviceEventType errorType, NSString *msg);


@interface LinkSquareAPI : NSObject

@property (copy, nonatomic) ConnectionBlock connectCallback;
@property (copy, nonatomic) AnalyzeBlock analyzeCallback;
@property (copy, nonatomic) ScanBlock scanCallback;
@property (copy, nonatomic) ErrorBlock errorCallback;
@property (assign, nonatomic) BOOL isScanning;


@property (nonatomic, strong) NSDictionary *metaData;


+(LinkSquareAPI *)sharedInstance;
-(void)setIpAddress:(const char *)ipAddress andPort:(int)portNumber;
-(void)setupConnectionWithCallback:(ConnectionBlock)blk;
-(void)closeConnection;
-(bool)checkConnected;

-(void)setupScanCallback:(ScanBlock)blk;
-(void)setupErrorCallback:(ErrorBlock)blk;


-(void)scanLED:(int)ledFrames andBULB:(int)bulbFrames doSNV:(BOOL)doSNV withCallback:(AnalyzeBlock)blk;

@end
