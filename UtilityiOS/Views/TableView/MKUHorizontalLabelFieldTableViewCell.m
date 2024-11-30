//
//  MKUHorizontalLabelFieldTableViewCell.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUHorizontalLabelFieldTableViewCell.h"
#import "MKUVerticalLabelFieldView.h"
#import "UIView+Utility.h"

@implementation MKUHorizontalLabelFieldTableViewCell

- (instancetype)initWithTitlesAndPlaceholders:(NSDictionary<NSString *,NSString *> *)dict delegate:(id<TextFieldDelegate>)delegate width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin {
    return [self initWithTitlesAndPlaceholders:dict delegate:delegate section:-1 width:width verticalMargin:verticalMargin];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles delegate:(id<TextFieldDelegate>)delegate interItemSpacing:(CGFloat)interItemSpacing width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin {
    return [self initWithTitles:titles delegate:delegate section:-1 interItemSpacing:interItemSpacing width:width verticalMargin:verticalMargin];
}

- (instancetype)initWithTitlesAndPlaceholders:(NSDictionary<NSString *,NSString *> *)dict delegate:(id<TextFieldDelegate>)delegate section:(NSUInteger)section width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin {
    return [super initWithInsets:UIEdgeInsetsMake(verticalMargin, 0.0, verticalMargin, 0.0) viewCreationHandler:^UIView *{
        return [[MKUHorizontalViews alloc] initWithCount:dict.count viewCreationHandler:^UIView *(NSUInteger index) {
            
            NSString *title = dict.allKeys[index];
            NSString *placeholder = dict[title];
            MKUVerticalLabelFieldView *view = [[MKUVerticalLabelFieldView alloc] initWithTitle:title placeholder:placeholder fieldHeight:[Constants TextFieldHeight]];
            view.textField.controller.delegate = delegate;
            if (0 <= section)
                view.textField.indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            return view;
        }];
    }];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles delegate:(id<TextFieldDelegate>)delegate section:(NSUInteger)section interItemSpacing:(CGFloat)interItemSpacing width:(CGFloat)width verticalMargin:(CGFloat)verticalMargin {
    return [super initWithInsets:UIEdgeInsetsMake(verticalMargin, 0.0, verticalMargin, 0.0) viewCreationHandler:^UIView *{
        return [[MKUHorizontalViews alloc] initWithCount:titles.count viewCreationHandler:^UIView *(NSUInteger index) {
            
            NSString *title = titles[index];
            MKUVerticalLabelFieldView *view = [[MKUVerticalLabelFieldView alloc] initWithTitle:title padding:interItemSpacing fieldHeight:[Constants TextFieldHeight]];
            view.textField.controller.delegate = delegate;
            if (0 <= section)
                view.textField.indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            return view;
        }];
    }];
}

- (void)setText:(NSString *)text forFieldAtIndex:(NSUInteger)index {
    [self viewAtIndex:index].textField.text = text;
}

- (void)setIndexPath:(NSIndexPath *)indexPath forFieldAtIndex:(NSUInteger)index {
    [self viewAtIndex:index].textField.indexPath = indexPath;
}

- (void)constraintViews:(NSArray *)views width:(CGFloat)totalWidth verticalMargin:(CGFloat)verticalMargin {
    
    CGFloat width = (totalWidth - (views.count-1) * [Constants HorizontalSpacing] - 2*[Constants HorizontalSpacing]) / views.count;
    [self.contentView removeConstraintsMask];
    [self.contentView constraintWidth:width forView:views.firstObject];
    [self.contentView constraintHorizontally:views interItemMargin:[Constants HorizontalSpacing] horizontalMargin:[Constants HorizontalSpacing] verticalMargin:verticalMargin equalWidths:YES];
}

- (MKUVerticalLabelFieldView *)viewAtIndex:(NSUInteger)index {
    return [self.view viewAtIndex:index];
}

@end

