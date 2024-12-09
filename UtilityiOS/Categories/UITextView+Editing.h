//
//  UITextView+Editing.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextView (Editing)

- (BOOL)textViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSUInteger)maxLength;

@end
