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
        case 0xFF: return @"image/jpg";
        case 0x89: return @"image/png";
        case 0x49: return @"image/tiff";
        case 0x4D: return @"image/tiff";
        case 0x47: return @"image/gif";
        case 0x25: return @"application/pdf";
        case 0x7B: return @"application/rtf";
        case 0x46: return @"text/plain";
        case 0x50: return @"application/vnd";
        default:   return @"application/octet-stream";
    }
}

- (NSString *)extension {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF: return @"jpg";
        case 0x89: return @"png";
        case 0x49: return @"tiff";
        case 0x4D: return @"tiff";
        case 0x47: return @"gif";
        case 0x25: return @"pdf";
        case 0x7B: return @"rtf";
        case 0x46: return @"txt";
        case 0x50: return @"docx";
        default:   return @"";
    }
}

- (MKU_DOCUMENT_TYPE)documentType {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF: return MKU_DOCUMENT_TYPE_JPEG;
        case 0x89: return MKU_DOCUMENT_TYPE_PNG;
        case 0x49: return MKU_DOCUMENT_TYPE_TIFF;
        case 0x4D: return MKU_DOCUMENT_TYPE_TIFF;
        case 0x47: return MKU_DOCUMENT_TYPE_GIF;
        case 0x25: return MKU_DOCUMENT_TYPE_PDF;
        case 0x7B: return MKU_DOCUMENT_TYPE_RTF;
        case 0x46: return MKU_DOCUMENT_TYPE_TEXT;
        case 0x50: return MKU_DOCUMENT_TYPE_DOC;
        default:   return MKU_DOCUMENT_TYPE_DATA;
    }
}

- (BOOL)isImage {
    MKU_DOCUMENT_TYPE type = [self documentType];
    return type == MKU_DOCUMENT_TYPE_JPEG ||
    type == MKU_DOCUMENT_TYPE_PNG ||
    type == MKU_DOCUMENT_TYPE_TIFF ||
    type == MKU_DOCUMENT_TYPE_GIF;
}

@end

