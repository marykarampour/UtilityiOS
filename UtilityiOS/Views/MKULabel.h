//
//  MKULabel.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKULabelStyleObject : NSObject

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;

+ (MKULabelStyleObject *)styleWithInsets:(UIEdgeInsets)insets font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor;

@end


@interface MKULabel : UILabel

@property (nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithText:(NSString *)text;
- (CGFloat)textHeight;
- (CGFloat)textHeightForWidth:(CGFloat)width;
- (void)setText:(NSString *)text style:(MKULabelStyleObject *)style;

+ (MKULabel *)titleLabel;

@end
