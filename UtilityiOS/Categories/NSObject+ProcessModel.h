//
//  NSObject+ProcessModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-11-29.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUServerDefinitions.h"

@interface NSObject (ProcessModel)

/** @brief Use when deserialized values from JSON to model objects are needed */
+ (id)processResult:(id)result class:(Class)modelClass;
/** @brief Use when deserialized values from JSON to model objects are needed */
+ (void)processResult:(id)result error:(NSError *)error class:(Class)modelClass completion:(MKUServerResultErrorBlock)completion;
/** @brief Use when raw values from JSON are needed */
+ (void)processValuesInResult:(id)result error:(NSError *)error completion:(MKUServerResultErrorBlock)completion;
/** @brief Use to process data/file downloaded from url, it returns NSData object in completion */
+ (void)processDataURLResult:(id)result error:(NSError *)error completion:(MKUServerResultErrorBlock)completion;

@end

