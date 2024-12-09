//
//  NSNumber+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSNumber+Utility.h"

@implementation NSNumber (Utility)

- (BOOL)isInRange:(MKURange *)range {
    return ([self compare:range.start] == NSOrderedSame &&
            [self compare:range.end] == NSOrderedSame);
}

- (BOOL)isBOOL {
    CFTypeID numID = CFGetTypeID((__bridge CFTypeRef)(self));
    return numID == CFBooleanGetTypeID();
}

+ (BOOL)isBOOL:(NSObject *)obj {
    if (![obj isKindOfClass:[NSNumber class]]) return NO;
    return [(NSNumber *)obj isBOOL];
}

+ (NSNumber *)numberWith:(NSNumber *)num min:(NSNumber *)min max:(NSNumber *)max {
    if (num.integerValue < min.integerValue)
        return min;
    else if (max.integerValue < num.integerValue)
        return max;
    else
        return num;
}

+ (BOOL)nullableNumber:(NSNumber *)number1 isEqualToNumber:(NSNumber *)number2 {
    if (!number1 && !number2) return YES;
    if (!number1 && number2) return NO;
    if (number1 && !number2) return NO;
    if (![number2 isKindOfClass:[NSNumber class]] || ![number1 isKindOfClass:[NSNumber class]]) return NO;
    return [number1 isEqualToNumber:number2];
}

@end
