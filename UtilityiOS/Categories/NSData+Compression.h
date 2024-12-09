//
//  NSData+Compression.h
//  UtilityiOS!
//
//  Created by Maryam Karampour on 2017-12-24.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <compression.h>

@interface NSData (Compression)

- (NSData *)compressEncode;
//Better not use this one, assumes decompressed is at most 15 times larger and has a limit of < 256M allocation
- (NSData *)compressDecode;
//This one is best
- (NSData *)streamCompress:(compression_stream_operation)operation;

@end
