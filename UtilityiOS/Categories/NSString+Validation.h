//
//  NSString+Validation.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isValidHTML;
- (BOOL)isValidStringOfType:(MKU_TEXT_TYPE)type maxLength:(NSUInteger)length;
- (NSString *)alphanumericSpace;
- (BOOL)isValidStringOfType:(MKU_TEXT_TYPE)type maxLength:(NSUInteger)length isEditing:(BOOL)isEditing;

@end
