//
//  NSData+Utility.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-03.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MKU_DOCUMENT_TYPE) {
    MKU_DOCUMENT_TYPE_PDF   = 1U << 0,
    MKU_DOCUMENT_TYPE_JPEG  = 1U << 1,
    MKU_DOCUMENT_TYPE_PNG   = 1U << 2,
    MKU_DOCUMENT_TYPE_TIFF  = 1U << 3,
    MKU_DOCUMENT_TYPE_GIF   = 1U << 4,
    MKU_DOCUMENT_TYPE_TEXT  = 1U << 5,
    MKU_DOCUMENT_TYPE_RTF   = 1U << 6,
    MKU_DOCUMENT_TYPE_DOC   = 1U << 7,
    MKU_DOCUMENT_TYPE_DATA  = 1U << 8,
    MKU_DOCUMENT_TYPE_COUNT = 1U << 9
};

@interface NSData (Utility)

- (NSString *)contentType;
- (NSString *)extension;
- (MKU_DOCUMENT_TYPE)documentType;
- (BOOL)isImage;

@end
