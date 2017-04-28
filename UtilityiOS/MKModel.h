//
//  MKModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "JSONModel.h"

@interface MKModel : JSONModel

- (NSString *)convertToJson:(NSString *)property;
- (NSString *)convertToProperty:(NSString *)json;

@end
