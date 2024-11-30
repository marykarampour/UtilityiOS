//
//  MKUHorizontalLabelFieldTableViewCell.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSingleViewTableViewCell.h"
#import "MKUVerticalLabelFieldView.h"
#import "MKUStackedViews.h"

@interface MKUHorizontalLabelFieldTableViewCell : MKUSingleViewTableViewCell <MKUHorizontalViews <MKUVerticalLabelFieldView *> *>

- (instancetype)initWithTitlesAndPlaceholders:(NSDictionary <NSString *, NSString *> *)dict delegate:(id<TextFieldDelegate>)delegate width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin;
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles delegate:(id<TextFieldDelegate>)delegate interItemSpacing:(CGFloat)interItemSpacing width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin;
- (instancetype)initWithTitlesAndPlaceholders:(NSDictionary <NSString *, NSString *> *)dict delegate:(id<TextFieldDelegate>)delegate section:(NSUInteger)section width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin;
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles delegate:(id<TextFieldDelegate>)delegate section:(NSUInteger)section interItemSpacing:(CGFloat)interItemSpacing width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin;

- (void)setText:(NSString *)text forFieldAtIndex:(NSUInteger)index;
- (void)setIndexPath:(NSIndexPath *)indexPath forFieldAtIndex:(NSUInteger)index;
- (MKUVerticalLabelFieldView *)viewAtIndex:(NSUInteger)index;

@end


