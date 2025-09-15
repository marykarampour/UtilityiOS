//
//  MKUInputTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUInputTableViewCell.h"
#import "UIControl+IndexPath.h"
#import "TextFieldController.h"
#import "UIView+Utility.h"

static CGFloat const PADDING = 8.0;

@interface MKUInputTableViewCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong, readwrite) MKULabel *label;
@property (nonatomic, strong, readwrite) MKUTextField *textField;

@end

@implementation MKUInputTableViewCell

- (instancetype)initWithTextType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth {
    return [self initWithStyle:UITableViewCellStyleDefault textType:type buttonImage:buttonImage fieldWidth:fieldWidth horizontalMargin:[Constants HorizontalSpacing]];
}

- (instancetype)initWithTextType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth horizontalMargin:(CGFloat)horizontalMargin {
    return [self initWithStyle:UITableViewCellStyleDefault textType:type buttonImage:buttonImage fieldWidth:fieldWidth horizontalMargin:horizontalMargin];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style textType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth {
    return [self initWithStyle:style textType:type buttonImage:buttonImage fieldWidth:fieldWidth horizontalMargin:[Constants HorizontalSpacing]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style textType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth horizontalMargin:(CGFloat)horizontalMargin {
    if (self = [super initWithStyle:style reuseIdentifier:[[self class] identifier]]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.button = [[UIButton alloc] init];
        [self.button setImage:buttonImage forState:UIControlStateNormal];
        [self.button setHidden:!buttonImage];
        
        self.textField = [[MKUTextField alloc] initWithTextType:type];
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        self.textField.textAlignment = NSTextAlignmentRight;
        
        self.label = [[MKULabel alloc] init];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumScaleFactor = 0.5;
        self.label.numberOfLines = 1;
        [self.label sizeToFit];
        
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.label];
        
        [self.contentView removeConstraintsMask];
        
        NSArray *views = @[self.label, self.button, self.textField];
        
        if (buttonImage) {
            [self.contentView constraintWidth:[Constants TextFieldHeight] forView:self.button];
            [self.contentView constraintSameWidthHeightForView:self.button];
            [self.contentView constraint:NSLayoutAttributeCenterY view:self.button];
        }
        
        [self.contentView constraintWidth:fieldWidth forView:self.textField];
        [self.contentView constraintHorizontally:views interItemMargin:[Constants HorizontalSpacing] horizontalMargin:horizontalMargin verticalMargin:PADDING equalWidths:NO];
    }
    return self;
}

- (void)setTarget:(id)target action:(SEL)action {
    if (action) {
        [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.textField.indexPath = indexPath;
    self.button.indexPath = indexPath;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

@end
