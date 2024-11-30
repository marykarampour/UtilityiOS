//
//  NSData+Compression.m
//  KaChing!
//
//  Created by Maryam Karampour on 2017-12-24.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "NSData+Compression.h"

unsigned int MAX_BUFFER = 25600000;

@implementation NSData (Compression)

- (NSData *)compressEncode {
    NSMutableData *compressed = [[NSMutableData alloc] init];
    
    size_t size = self.length;
    const uint8_t *dataBuffer = (const uint8_t *)self.bytes;
    
    uint8_t *buffer = calloc(size, sizeof(uint8_t));
    size_t compressedSize = compression_encode_buffer(buffer, size, dataBuffer, size, NULL, COMPRESSION_LZMA);
    
    DEBUGLOG(@"Data size original = %zu AND compressesd = %zu", size, compressedSize);
    [compressed appendBytes:buffer length:compressedSize];
    
    free(buffer);
    
    return compressed;
}

- (NSData *)compressDecode {
    NSMutableData *decompressed = [[NSMutableData alloc] init];
    
    size_t dataSize = self.length;
    const uint8_t *dataBuffer = (const uint8_t *)self.bytes;
    
    size_t size = (dataSize < MAX_BUFFER*15 ? dataSize*15 : MAX_BUFFER*15);
    uint8_t *buffer = calloc(size, sizeof(uint8_t));
    size_t decompressedSize = compression_decode_buffer(buffer, size, dataBuffer, dataSize, NULL, COMPRESSION_LZMA);
    
    DEBUGLOG(@"Data size original = %zu AND deompressesd = %zu", size, decompressedSize);
    [decompressed appendBytes:buffer length:decompressedSize];
    
    free(buffer);
    
    return decompressed;
}

- (NSData *)streamCompress:(compression_stream_operation)operation {
    NSMutableData *compressed = [[NSMutableData alloc] init];
    
    compression_stream stream;
    compression_status status;
    
    stream.src_ptr = self.bytes;
    stream.src_size = self.length;
    
    size_t size = 4096;
    uint8_t *buffer = calloc(size, sizeof(uint8_t));
    
    stream.dst_ptr = buffer;
    stream.dst_size = size;
    
    if (@available(iOS 9.0, *)) {
        status = compression_stream_init(&stream, operation, COMPRESSION_LZMA);
    } else {
        // Fallback on earlier versions
    }
    
    while (status == COMPRESSION_STATUS_OK) {
        if (@available(iOS 9.0, *)) {
            status = compression_stream_process(&stream, COMPRESSION_STREAM_FINALIZE);
        } else {
            // Fallback on earlier versions
        }
        
        switch (status) {
            case COMPRESSION_STATUS_OK: {
                if (stream.dst_size == 0) {
                    [compressed appendBytes:buffer length:size];
                    stream.dst_ptr = buffer;
                    stream.dst_size = size;
                }
            }
                break;
            case COMPRESSION_STATUS_END: {
                if (stream.dst_ptr > buffer) {
                    [compressed appendBytes:buffer length:stream.dst_ptr - buffer];
                }
            }
                break;
            case COMPRESSION_STATUS_ERROR: {
                
            }
                break;
            default:
                break;
        }
    }
    
    if (@available(iOS 9.0, *)) {
        compression_stream_destroy(&stream);
    } else {
        // Fallback on earlier versions
    }
    
    return compressed;
}

@end
