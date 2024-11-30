//
//  TextViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKUTextView;

@protocol TextViewDelegate <NSObject>

@optional
- (void)handleTextViewChanges:(__kindof MKUTextView *)textView;
- (void)handleTextViewEndEditing:(__kindof MKUTextView *)textView;
- (void)handleTextViewBeginEditing:(__kindof MKUTextView *)textView;

@end

@interface TextViewController : NSObject

@property (nonatomic, weak) id<TextViewDelegate> delegate;
/** @brief pass NSNotFound for no check for length */
@property (nonatomic, assign) NSUInteger maxLenght;
@property (nonatomic, assign) MKU_TEXT_TYPE type;

- (instancetype)initWithTextView:(MKUTextView *)view;

@end
