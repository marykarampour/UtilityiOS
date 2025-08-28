//
//  UITextView+Editing.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UITextView+Editing.h"

@implementation UITextView (Editing)

- (BOOL)textViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSUInteger)maxLength {
    if (self.text.length < range.length + range.location)
        return NO;
    return self.text.length + text.length - range.length <= maxLength;
}

- (BOOL)textViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.text.length < range.length + range.location)
        return NO;
    
    NSUInteger newLength = self.text.length + text.length - range.length;
    if (newLength <= [Constants MaxTextViewCharacters])
        return YES;
    return NO;
}

@end
