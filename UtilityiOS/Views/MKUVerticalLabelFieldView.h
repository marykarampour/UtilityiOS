//
//  MKUVerticalLabelFieldView.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUTextField.h"
#import "MKULabel.h"

@interface MKUVerticalLabelFieldView : UIView

@property (nonatomic, strong, readonly) MKULabel *titleLabel;
@property (nonatomic, strong, readonly) MKUTextField *textField;

- (instancetype)initWithFieldHeight:(CGFloat)fieldHeight;
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder fieldHeight:(CGFloat)fieldHeight;
- (instancetype)initWithTitle:(NSString *)title horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin fieldHeight:(CGFloat)fieldHeight;
- (instancetype)initWithTitle:(NSString *)title horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin fieldWidth:(CGFloat)fieldWidth;
/** [UIButton defaultHeight] is used as fieldHeight. */
- (instancetype)initWithTitle:(NSString *)title horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin;
- (instancetype)initWithTitle:(NSString *)title padding:(CGFloat)padding fieldHeight:(CGFloat)fieldHeight;

@end


