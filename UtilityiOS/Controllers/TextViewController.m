//
//  TextViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "TextViewController.h"
#import "MKTextView.h"

@interface TextViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray<MKTextView *> *views;

@end

@implementation TextViewController

- (instancetype)init {
    if (self = [super init]) {
        self.views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTextView:(MKTextView *)view {
    if (![self.views containsObject:view]) {
        view.delegate = self;
        [self.views addObject:view];
    }
}

#pragma mark - delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView isKindOfClass:[MKTextView class]]) return YES;
    MKTextView *view = (MKTextView *)textView;
    return (view.textObject.maxChars > 0 ? (view.text.length - range.length + text.length < view.textObject.maxChars) : YES);
}

- (void)textViewDidChange:(UITextView *)textView {
    [self handleTextViewChanges:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self handleTextViewChanges:textView];
}

- (void)handleTextViewChanges:(UITextView *)textView {
    if ([textView isKindOfClass:[MKTextView class]]) {
        MKTextView *view = (MKTextView *)textView;
        [view showHidePlaceholder];
        [view setCharText:[NSString stringWithFormat:@"%lu", (unsigned long)textView.text.length]];
        if ([self.delegate respondsToSelector:@selector(handleTextViewChanges:)]) {
            [self.delegate handleTextViewChanges:view];
        }
    }
}

@end
