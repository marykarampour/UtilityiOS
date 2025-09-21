//
//  NSString+CPP.m
//  P2P
//
//  Created by Maryam Karampour on 2025-09-15.
//  Copyright © 2025 Maryam Karampour. All rights reserved.

#import "NSString+CPP.h"

@implementation NSString (CPP)

- (std::string)CPPString {
    return std::string([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (NSString *)stringWithCPPString:(std::string)CPPString {
    return [NSString stringWithCString:CPPString.c_str() encoding:NSUTF8StringEncoding];
}

@end
