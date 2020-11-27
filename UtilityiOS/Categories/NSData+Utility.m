//
//  NSData+Utility.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-03.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSData+Utility.h"

@implementation NSData (Utility)

- (NSString *)contentType {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF: return @"image/jpeg";
        case 0x89: return @"image/png";
        case 0x49: return @"image/tiff";
        case 0x4D: return @"image/tiff";
        case 0x25: return @"application/pdf";
        case 0x7B: return @"application/rtf";
        case 0x46: return @"text/plain";
        case 0x50: return @"application/vnd";
        default: return @"application/octet-stream";
    }
}

- (NSString *)extension {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF: return @"jpeg";
        case 0x89: return @"png";
        case 0x49: return @"tiff";
        case 0x4D: return @"tiff";
        case 0x25: return @"pdf";
        case 0x7B: return @"rtf";
        case 0x46: return @"txt";
        case 0x50: return @"docx";
        default: return @"";
    }
}

@end
