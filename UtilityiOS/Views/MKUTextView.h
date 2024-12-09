//
//  MKUTextView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UITextView+IndexPath.h"
#import "TextViewController.h"
#import "MKULabel.h"
#import "MKUText.h"

@interface MKUTextView : UITextView

@property (nonatomic, assign, readonly) BOOL hasCharCount;
@property (nonatomic, strong, readonly) TextViewController *controller;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (instancetype)initWithPlaceholder:(NSString *)placeholder hasCharCount:(BOOL)hasCharCount;

- (void)showHidePlaceholder;
- (void)setCharText:(NSString *)text;
- (void)setPlaceholderText:(NSString *)text;
- (void)setControllerDelegate:(id<TextViewDelegate>)object;

@end
