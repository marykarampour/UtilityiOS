//
//  MKULabel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKULabel.h"
#import "UIView+Utility.h"
#import "NSString+Utility.h"

@implementation MKULabel

- (instancetype)init {
    return [self initWithText:@""];
}

- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        self.text = text;
        self.font = [AppTheme mediumLabelFont];
        self.textColor = [AppTheme labelDarkColor];
        [self sizeToFit];
    }
    return self;
}

- (CGFloat)textHeight {
    return [self textHeightForWidth:[Constants screenWidth]];
}

- (CGFloat)textHeightForWidth:(CGFloat)width {
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGRect rect = CGRectZero;
    
    if (0 < self.attributedText.string.length) {
        rect = [self.attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:context];
    }
    else if (self.text.length) {
        id fontAttr = self.font;
        rect = [self.text rectForWidth:width font:fontAttr];
    }
    return rect.size.height + self.insets.right + self.insets.left;
}

- (void)setText:(NSString *)text style:(MKULabelStyleObject *)style {
    self.text = text;
    self.font = style.font;
    self.textColor = style.textColor;
    self.backgroundColor = style.backgroundColor;
}

+ (MKULabel *)titleLabel {
    
    MKULabel *label = [[MKULabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [AppTheme mediumBoldLabelFont];
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.4;
    [label sizeToFit];
    return label;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width  += (self.insets.left + self.insets.right);
    size.height += (self.insets.top + self.insets.bottom);
    return size;
}

@end

@implementation MKULabelStyleObject

+ (MKULabelStyleObject *)styleWithInsets:(UIEdgeInsets)insets font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {

    MKULabelStyleObject *data = [[MKULabelStyleObject alloc] init];
    data.insets = insets;
    data.font = font;
    data.textColor = textColor;
    data.backgroundColor = backgroundColor;
    return data;
}

@end
