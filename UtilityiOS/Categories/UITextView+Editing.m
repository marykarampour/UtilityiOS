//
//  UITextView+Editing.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UITextView+Editing.h"

@implementation UITextView (Editing)

- (BOOL)textViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSUInteger)maxLength {
    if (range.length + range.location > self.text.length)
        return NO;
    return self.text.length + text.length - range.length <= maxLength;
}

@end
