//
//  MKUInputTableViewCell.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUBaseTableViewCell.h"
#import "MKUTextField.h"
#import "MKULabel.h"

@interface MKUInputTableViewCell : MKUBaseTableViewCell

@property (nonatomic, strong, readonly) MKUTextField *textField;
@property (nonatomic, strong, readonly) MKULabel *label;

- (instancetype)initWithTextType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth;
- (instancetype)initWithTextType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth horizontalMargin:(CGFloat)horizontalMargin;
- (instancetype)initWithStyle:(UITableViewCellStyle)style textType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth;
- (instancetype)initWithStyle:(UITableViewCellStyle)style textType:(MKU_TEXT_TYPE)type buttonImage:(UIImage *)buttonImage fieldWidth:(CGFloat)fieldWidth horizontalMargin:(CGFloat)horizontalMargin;

- (void)setTarget:(id)target action:(SEL)action;
- (void)setIndexPath:(NSIndexPath *)indexPath;
- (void)setTitle:(NSString *)title;

@end
