//
//  MultiLabelTableViewCell.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MultiLabelTableViewCell.h"
#import "UIView+Utility.h"

static UIEdgeInsets EDGE_INSETS;

@interface MultiLabelTableViewCell ()

@property (nonatomic, assign) MultiLabelViewType type;

@property (nonatomic, strong, readwrite) __kindof UIView *leftView;
@property (nonatomic, strong, readwrite) __kindof UIView *rightView;
@property (nonatomic, strong, readwrite) NSMutableArray<__kindof MKLabel *> *labels;

- (void)createLabels:(NSUInteger)labelsCount;
- (void)addLeftView:(__kindof UIView *)leftView;
- (void)addRightView:(__kindof UIView *)rightView;
- (void)constraintLabels;

@end


@implementation MultiLabelTableViewCell

- (instancetype)initWithType:(MultiLabelViewType)type leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets {
    EDGE_INSETS = insets;
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MultiLabelTableViewCell identifier]]) {
        if ((type == MultiLabelViewType_NONE) && (leftView || rightView)) {
            [self constructWithSingleView:(leftView ? leftView : rightView)];
        }
        if ((type == MultiLabelViewType_Labels) && labelsCount > 0) {
            [self constructWithLabelsCount:labelsCount];
        }
        else if ((type & MultiLabelViewType_Labels) &&
                 (type & MultiLabelViewType_LeftView) &&
                 !(type & MultiLabelViewType_rightView) &&
                 labelsCount > 0 && leftView) {
            [self constructWithLabelsCount:labelsCount leftView:leftView];
        }
        else if ((type & MultiLabelViewType_Labels) &&
                 !(type & MultiLabelViewType_LeftView) &&
                 (type & MultiLabelViewType_rightView) &&
                 labelsCount > 0 && rightView) {
            [self constructWithLabelsCount:labelsCount rightView:rightView];
        }
        else if (!(type & MultiLabelViewType_Labels) &&
                 (type & MultiLabelViewType_LeftView) &&
                 (type & MultiLabelViewType_rightView) &&
                 leftView && rightView) {
            [self constructWithLeftView:leftView rightView:rightView];
        }
        else if ((type & MultiLabelViewType_Labels) &&
                 (type & MultiLabelViewType_LeftView) &&
                 (type & MultiLabelViewType_rightView) &&
                 leftView && rightView) {
            [self constructWithLabelsCount:labelsCount leftView:leftView rightView:rightView];
        }
    }
    return self;
}

#pragma mark - constructors

- (void)constructWithSingleView:(__kindof UIView *)view {
    [self addLeftView:view];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:view margin:EDGE_INSETS.left];
    [self.contentView constraint:NSLayoutAttributeRight view:view margin:-EDGE_INSETS.right];
    [self.contentView constraint:NSLayoutAttributeTop view:view margin:EDGE_INSETS.top];
    [self.contentView constraint:NSLayoutAttributeBottom view:view margin:-EDGE_INSETS.bottom];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount {
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:self.labels.firstObject margin:EDGE_INSETS.left];
    [self.contentView constraint:NSLayoutAttributeRight view:self.labels.firstObject margin:-EDGE_INSETS.right];
    
    [self constraintLabels];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount leftView:(__kindof UIView *)leftView {
    [self addLeftView:leftView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self constraintSizeForView:leftView];
    
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:leftView.frame.size.height];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:self.leftView margin:EDGE_INSETS.left];
    [self.contentView constraint:NSLayoutAttributeRight view:self.labels.firstObject margin:-EDGE_INSETS.right];
    
    [self constraintLabels];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self constraintSizeForView:rightView];
    
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:rightView.frame.size.height];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[Constants HorizontalSpacing]];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeRight view:self.rightView margin:-EDGE_INSETS.right];
    [self.contentView constraint:NSLayoutAttributeLeft view:self.labels.firstObject margin:EDGE_INSETS.left];
    
    [self constraintLabels];
}

- (void)constructWithLeftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self addLeftView:leftView];
    [self.contentView removeConstraintsMask];
    
    if (leftView.frame.size.width > 0.0 && leftView.frame.size.height > 0.0) {
        [self constraintSizeForView:leftView];
    }
    else if (leftView.frame.size.width > 0.0) {
        [self.contentView constraintWidthForView:leftView];
    }
    else if (leftView.frame.size.height > 0.0) {
        [self.contentView constraintHeightForView:leftView];
    }
    else {
        [self constraintSizeForView:rightView];
    }
    
    UIView *bottom = (leftView.frame.size.height > rightView.frame.size.height ? leftView : rightView);
    
    [self.contentView constraint:NSLayoutAttributeBottom view:bottom];
    
    [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeRight view:self.rightView];
    
    [self.contentView addConstraintWithItem:self.rightView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:self.leftView];
    
    [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeTop view:self.leftView];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self addLeftView:leftView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    if (leftView.frame.size.width > 0.0 && leftView.frame.size.height > 0.0) {
        [self constraintSizeForView:leftView];
    }
    else if (leftView.frame.size.width > 0.0) {
        [self.contentView constraintWidthForView:leftView];
    }
    else if (leftView.frame.size.height > 0.0) {
        [self.contentView constraintHeightForView:leftView];
    }
    [self constraintSizeForView:rightView];
    
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:leftView.frame.size.height];
    
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:rightView.frame.size.height];
    
    [self.contentView constraint:NSLayoutAttributeRight view:self.rightView];
    
    [self.contentView addConstraintWithItem:self.rightView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:self.leftView];
    
    [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeTop view:self.leftView];
    
    [self constraintLabels];
}

#pragma mark - helpers

- (void)createLabels:(NSUInteger)labelsCount {
    self.labels = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<labelsCount; i++) {
        MKLabel *label = [self createLabelAtIndex:i];
        [self.labels addObject:label];
        [self.contentView addSubview:label];
    }
}

- (MKLabel *)createLabelAtIndex:(NSUInteger)index {
    MKLabel *label = [[MKLabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (void)constraintLabels {
    [self.contentView constraint:NSLayoutAttributeTop view:self.labels.firstObject margin:EDGE_INSETS.top];
    [self.contentView constraint:NSLayoutAttributeBottom view:self.labels.lastObject margin:-EDGE_INSETS.bottom];
    
    if (self.labels.count > 1) {
        for (NSUInteger i=1; i<self.labels.count; i++) {
            MKLabel *label = self.labels[i];
            [self.contentView addConstraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            [self.contentView addConstraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        }
        MKLabel *topLabel = self.labels.firstObject;
        MKLabel *nextLabel;
        
        for (NSUInteger i=1; i<self.labels.count; i++) {
            nextLabel = self.labels[i];
            [self.contentView addConstraintWithItem:nextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            topLabel = nextLabel;
        }
    }
}

- (void)addLeftView:(__kindof UIView *)leftView {
    self.leftView = leftView;
    [self.contentView addSubview:leftView];
}

- (void)addRightView:(__kindof UIView *)rightView {
    self.rightView = rightView;
    [self.contentView addSubview:rightView];
}

- (void)setText:(NSString *)text forLabelAtIndex:(NSUInteger)index {
    if (index < self.labels.count) {
        self.labels[index].text = text;
    }
}

- (void)setAttributedText:(NSAttributedString *)text forLabelAtIndex:(NSUInteger)index {
    if (index < self.labels.count) {
        self.labels[index].attributedText = text;
    }
}

@end
