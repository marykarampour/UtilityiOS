//
//  NSNumber+Utility.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSNumber+Utility.h"

@implementation NSNumber (Utility)

- (BOOL)isInRange:(MKRange *)range {
    return ([self compare:range.start] == NSOrderedSame &&
            [self compare:range.end] == NSOrderedSame);
}

@end
