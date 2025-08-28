//
//  NSDate+Server.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Server)

- (NSDate *)UTCDateWithAnyFormat;
- (NSDate *)dateWithAnyFormat;
- (NSDate *)dateWithAnyFormatIsUTC:(BOOL)isUTC;

@end
