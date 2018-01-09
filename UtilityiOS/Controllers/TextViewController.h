//
//  TextViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKTextView;

@protocol TextViewDelegate <NSObject>

@optional
- (void)handleTextViewChanges:(MKTextView *)textView;

@end

@interface TextViewController : NSObject

@property (nonatomic, weak) id<TextViewDelegate> delegate;

- (void)addTextView:(MKTextView *)view;

@end
