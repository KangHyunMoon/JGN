//
//  ObjCWrapper.m
//  test_objc
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

#import "ObjCWrapper.h"
#include "cppWrapped.h"

@interface ObjCppWrapper()
@property ItsCpp *itsCpp;
@end

@implementation ObjCppWrapper
- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.itsCpp = new ItsCpp(std::string([name cStringUsingEncoding:NSUTF8StringEncoding]));
    }
    return self;
}

- (NSString *)getName {
    return [NSString stringWithUTF8String:self.itsCpp->name().c_str()];
}

- (void)setName:(NSString *)name {
    self.itsCpp->name(std::string([name cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (void)dealloc {
    delete _itsCpp;
    _itsCpp = nil;
}
@end
