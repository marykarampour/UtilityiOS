//
//  NSDate+Server.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSString+Server.h"
#import "NSDate+Utility.h"

@implementation NSString (Server)

- (NSDate *)UTCDateWithAnyFormat {
    return [self dateWithAnyFormatIsUTC:YES];
}

- (NSDate *)dateWithAnyFormat {
    return [self dateWithAnyFormatIsUTC:NO];
}

- (NSDate *)dateWithAnyFormatIsUTC:(BOOL)isUTC {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    
    [formatter setTimeZone:isUTC ? [NSDate UTCTimeZone] : [NSDate systemTimeZone]];
    
    for (NSString *format in [Constants ServerDateFormats]) {
        [formatter setDateFormat:format];
        date = [formatter dateFromString:self];
        if (date) break;
    }
    return date;
}

@end
