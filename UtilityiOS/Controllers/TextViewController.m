//
//  TextViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "TextViewController.h"
#import "UITextView+Editing.h"
#import "MKUTextView.h"

@interface TextViewController () <UITextViewDelegate>

@property (nonatomic, weak) MKUTextView *view;

@end

@implementation TextViewController

- (instancetype)initWithTextView:(MKUTextView *)view {
    if (self = [super init]) {
        self.view = view;
        self.view.delegate = self;
    }
    return self;
}

#pragma mark - delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![textView isKindOfClass:[MKUTextView class]]) return YES;
    if (self.maxLenght == 0 || self.maxLenght == NSNotFound) return YES;
    return [textView textViewShouldChangeTextInRange:range replacementText:text maxLength:self.maxLenght];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self handleTextViewChanges:textView];
    if ([self.delegate respondsToSelector:@selector(handleTextViewChanges:)]) {
        [self.delegate handleTextViewChanges:(MKUTextView *)textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self handleTextViewChanges:textView];
    if ([self.delegate respondsToSelector:@selector(handleTextViewEndEditing:)]) {
        [self.delegate handleTextViewEndEditing:(MKUTextView *)textView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self handleTextViewBeginEditing:textView];
}

- (void)handleTextViewChanges:(UITextView *)textView {
    if ([textView isKindOfClass:[MKUTextView class]]) {
        [(MKUTextView *)textView showHidePlaceholder];
    }
}

- (void)handleTextViewBeginEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[MKUTextView class]]) {
        MKUTextView *view = (MKUTextView *)textView;
        if ([self.delegate respondsToSelector:@selector(handleTextViewBeginEditing:)]) {
            [self.delegate handleTextViewBeginEditing:view];
        }
    }
}

@end
