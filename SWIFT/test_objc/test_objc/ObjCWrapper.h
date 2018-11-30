//
//  ObjCWrapper.h
//  test_objc
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCppWrapper : NSObject
- (instancetype)initWithName:(NSString *)name;
- (NSString *)getName;
- (void)setName:(NSString *)name;
@end
