//
//  NSObject+ProcessModel.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-11-29.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "NSObject+ProcessModel.h"
#import "NSData+Compression.h"
#import "MKModel.h"

@implementation NSObject (ProcessModel)

+ (id)processResult:(id)result class:(Class)modelClass {
    if (!result || !modelClass) {
        return nil;
    }
    else if (result) {
        if (modelClass == [NSString class] || modelClass == [NSDictionary class] || modelClass == [NSNumber class]) {
            return result;
        }
        else {
            id modelObject;
            NSError *modelError;
            
            if ([result isKindOfClass:[NSArray class]]) {
                if (modelClass == [NSString class] || modelClass == [NSNumber class]) {
                    modelObject = result;
                }
                else {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in result) {
                        id obj = [[modelClass alloc] initWithDictionary:dict error:&modelError];
                        if (obj && [obj isKindOfClass:modelClass]) {
                            [arr addObject:obj];
                        }
                    }
                    modelObject = arr;
                }
            }
            else {
                modelObject = [[modelClass alloc] initWithDictionary:result error:&modelError];
            }
            return modelObject;
        }
    }
    return nil;
}

+ (void)processResult:(id)result error:(NSError *)error class:(Class)modelClass completion:(ServerResultErrorBlock)completion {
    if (!result || !modelClass) {
        completion(nil, error);
    }
    else if (result) {
        if (modelClass == [NSString class] || modelClass == [NSDictionary class] || modelClass == [NSNumber class]) {
            completion(result, nil);
        }
        else {
            id modelObject;
            NSError *modelError = error;
            
            if ([result isKindOfClass:[NSArray class]]) {
                if (modelClass == [NSString class] || modelClass == [NSNumber class]) {
                    modelObject = result;
                }
                else {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in result) {
                        id obj = [[modelClass alloc] initWithDictionary:dict error:&modelError];
                        if (obj && [obj isKindOfClass:modelClass]) {
                            [arr addObject:obj];
                        }
                    }
                    modelObject = arr;
                }
            }
            else {
                modelObject = [[modelClass alloc] initWithDictionary:result error:&modelError];
            }
            completion(modelObject, modelError);
        }
    }
    else {
        completion(nil, error);
    }
}

+ (void)processValuesInResult:(id)result error:(NSError *)error completion:(ServerResultErrorBlock)completion {
    if (error || !result) {
        completion(nil, error);
    }
    else if (result) {
        if ([result isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in result) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [arr addObjectsFromArray:dict.allValues];
                }
            }
            completion(arr, error);
        }
        else if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            if (dict.count == 1) {
                completion(dict.allValues.firstObject, nil);
            }
            else {
                completion(dict, error);
            }
        }
        else {
            completion(result, error);
        }
    }
    else {
        completion(nil, nil);
    }
}

+ (void)processDataURLResult:(id)result error:(NSError *)error completion:(ServerResultErrorBlock)completion {
    if (!error && result) {
        if ([result isKindOfClass:[NSURL class]]) {
            NSError *err = nil;
            NSString *path = [((NSURL *)result).absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&err];
            
            if (data && !err) {
                NSData *decompressed = [data streamCompress:COMPRESSION_STREAM_DECODE];
                DEBUGLOG(@"%lu", (unsigned long)decompressed.length);
                [[NSFileManager defaultManager] removeItemAtURL:result error:nil];
                completion(decompressed, error);
            }
            else {
                completion(nil, error);
            }
        }
        else {
            completion(nil, error);
        }
    }
    else {
        completion(nil, error);
    }
}

@end
