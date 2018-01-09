//
//  MKTextView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKLabel.h"
#import "MKText.h"

@interface MKTextView : UITextView

@property (nonatomic, assign, readonly) BOOL hasCharCount;
@property (nonatomic, strong, readonly) MKText *textObject;

- (instancetype)initWithPlaceholder:(NSString *)placeholder hasCharCount:(BOOL)hasCharCount;

- (void)showHidePlaceholder;
- (void)setCharText:(NSString *)text;

@end
