//
//  Constant.swift
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 8..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//


// 어플 내에서 사용하는 constant(상수)들을 정의해놓은 일종의 헤더입니다.

import Foundation

let GATEWAY_IP : NSString = "192.168.1.1"

let ip : NSString =
"192.168.1.1"

// ip와 gateway ip를 기기의 아이피로 설정합니다. 상수는 let 변수는 var

var ip2 = (ip as NSString).utf8String

// ip의 형태 변환. utf8형태로

var port : Int = 18630

// 포트 지정

class LinkSquareDevice_s {
    var FullName = "";
    var IP = "";
    var Port  = 0;
    var Alias = "";
}

// 사용할 디바이스의 클래스를 만들어줍니다. -> 후에 인스턴스를 받아서 사용

let ls = LinkSquareAPI.sharedInstance()

// API인스턴스를 동적으로 할당받습니다. ls라는 변수를 통해서 후에 우리가 원하는 api를 사용할 수 있습니다.
// ls 인스턴스를 통해 원하는 인스턴스를 사용 가능합니다
// ex >> ls?.analyzeCallback 등등..

let filemgr = FileManager.default

// 파일을 저장하고 불러오기 위한 파일매니저 선언

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

// 도큐멘트 경로 선언

let filepath = documentsPath + "/example.bin"

// 바이너리 파일 저장을 위한 경로 선언
