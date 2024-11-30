//
//  NSObject+CPPNSObject.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-30.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+CPPNSObject.h"

@implementation NSObject (CPPNSObject)

- (std::string)NSStringToCPPString:(NSString *)string {
    return std::string([string UTF8String]);
}

- (NSString *)CPPStringToNSString:(std::string)string {
    return [NSString stringWithUTF8String:string.c_str()];
}

@end
