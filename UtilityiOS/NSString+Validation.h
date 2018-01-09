//
//  NSString+Validation.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isValidStringOfType:(TextType)type maxLength:(NSUInteger)length;

@end
