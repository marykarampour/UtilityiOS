//
//  NSNumber+Utility.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKDateRange.h"

@interface NSNumber (Utility)

- (BOOL)isInRange:(MKRange *)range;

@end
