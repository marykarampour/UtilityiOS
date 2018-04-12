//
//  MultiLabelView.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-27.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MultiLabelView.h"
#import "UIView+Utility.h"

static UIEdgeInsets EDGE_INSETS;
static CGFloat CONSTANT_WIDTH_SUM;

@interface MultiLabelView ()

@property (nonatomic, assign) MultiLabelViewType type;

@property (nonatomic, strong, readwrite) __kindof UIView *contentView;
@property (nonatomic, strong, readwrite) __kindof UIView *leftView;
@property (nonatomic, strong, readwrite) __kindof UIView *rightView;
@property (nonatomic, strong, readwrite) NSMutableArray<__kindof MKLabel *> *labels;

- (void)createLabels:(NSUInteger)labelsCount;
- (void)addLeftView:(__kindof UIView *)leftView;
- (void)addRightView:(__kindof UIView *)rightView;
- (void)constraintLabels;

@end


@implementation MultiLabelView

- (instancetype)initWithContentView:(__kindof UIView *)contentView {
    if (self = [super init]) {
        self.contentView = contentView ? contentView : [[UIView alloc] init];
    }
    return self;
}

- (void)constructWithType:(MultiLabelViewType)type leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets {
    EDGE_INSETS = insets;
    self.leftView = [[UIView alloc] initWithFrame:leftView.frame];
    self.rightView = [[UIView alloc] initWithFrame:rightView.frame];
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.rightView];
    
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

#pragma mark - constructors

- (void)constructWithSingleView:(__kindof UIView *)view {
    [self addLeftView:view];
    [self.contentView removeConstraintsMask];
    [self.contentView constraintSidesForView:self.leftView insets:EDGE_INSETS];
    
    CONSTANT_WIDTH_SUM = EDGE_INSETS.left+EDGE_INSETS.right;
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount {
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:self.labels.firstObject margin:EDGE_INSETS.left];
    [self.contentView constraint:NSLayoutAttributeRight view:self.labels.firstObject margin:-EDGE_INSETS.right];
    
    [self constraintLabels];
    
    CONSTANT_WIDTH_SUM = EDGE_INSETS.left+EDGE_INSETS.right;
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount leftView:(__kindof UIView *)leftView {
    [self addLeftView:leftView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraintSizeForView:self.leftView];
    
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:leftView.frame.size.height];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeLeft view:self.leftView margin:EDGE_INSETS.left];
    [self.contentView constraint:NSLayoutAttributeRight view:self.labels.firstObject margin:-EDGE_INSETS.right];
    
    [self constraintLabels];
    
    CONSTANT_WIDTH_SUM = EDGE_INSETS.left+EDGE_INSETS.right+self.leftView.frame.size.width+[Constants HorizontalSpacing];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraintSizeForView:self.rightView];
    
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:rightView.frame.size.height];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-[Constants HorizontalSpacing]];
    
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self.contentView constraint:NSLayoutAttributeRight view:self.rightView margin:-EDGE_INSETS.right];
    [self.contentView constraint:NSLayoutAttributeLeft view:self.labels.firstObject margin:EDGE_INSETS.left];
    
    [self constraintLabels];
    
    CONSTANT_WIDTH_SUM = EDGE_INSETS.left+EDGE_INSETS.right+self.rightView.frame.size.width+[Constants HorizontalSpacing];
}

- (void)constructWithLeftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self addLeftView:leftView];
    [self.contentView removeConstraintsMask];
    
    CGFloat width = self.leftView.frame.size.width;
    
    if (leftView.frame.size.width > 0.0 && leftView.frame.size.height > 0.0) {
        [self.contentView constraintSizeForView:self.leftView];
    }
    else if (leftView.frame.size.width > 0.0) {
        [self.contentView constraintWidthForView:leftView];
    }
    else if (leftView.frame.size.height > 0.0) {
        [self.contentView constraintHeightForView:leftView];
        width = self.rightView.frame.size.width;
    }
    else {
        [self.contentView constraintSizeForView:self.rightView];
        width = self.rightView.frame.size.width;
    }
    
    UIView *bottom = (leftView.frame.size.height > rightView.frame.size.height ? leftView : rightView);
    
    [self.contentView constraint:NSLayoutAttributeBottom view:bottom];
    [self.contentView constraint:NSLayoutAttributeRight view:self.rightView];
    [self.contentView constraint:NSLayoutAttributeLeft view:self.leftView];
    [self.contentView constraint:NSLayoutAttributeTop view:self.leftView];
    
    [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.contentView addConstraintWithItem:self.rightView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    CONSTANT_WIDTH_SUM = EDGE_INSETS.left+EDGE_INSETS.right+width+[Constants HorizontalSpacing];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self addLeftView:leftView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    if (leftView.frame.size.width > 0.0 && leftView.frame.size.height > 0.0) {
        [self.contentView constraintSizeForView:self.leftView];
    }
    else if (leftView.frame.size.width > 0.0) {
        [self.contentView constraintWidthForView:leftView];
    }
    else if (leftView.frame.size.height > 0.0) {
        [self.contentView constraintHeightForView:leftView];
    }
    
    [self.contentView constraintSizeForView:self.rightView];
    [self.contentView constraint:NSLayoutAttributeRight view:self.rightView];
    [self.contentView constraint:NSLayoutAttributeLeft view:self.leftView];
    [self.contentView constraint:NSLayoutAttributeTop view:self.leftView];

    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:leftView.frame.size.height];
    [self.contentView addConstraintWithItem:self.labels.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeTop multiplier:1.0 constant:rightView.frame.size.height];
    [self.contentView addConstraintWithItem:self.rightView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.labels.firstObject attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
    [self.contentView addConstraintWithItem:self.labels.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
    [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    [self constraintLabels];
    
    CONSTANT_WIDTH_SUM = EDGE_INSETS.left+EDGE_INSETS.right+self.leftView.frame.size.width+self.rightView.frame.size.width+2*[Constants HorizontalSpacing];
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
    [label sizeToFit];
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
    [self.leftView removeAllSubviews];
    [self.leftView addSubview:leftView];
    [self.leftView removeConstraintsMask];
    [self.leftView constraintSidesForView:leftView];
}

- (void)addRightView:(__kindof UIView *)rightView {
    [self.rightView removeAllSubviews];
    [self.rightView addSubview:rightView];
    [self.rightView removeConstraintsMask];
    [self.rightView constraintSidesForView:rightView];
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

- (CGFloat)constantWidthSum {
    return CONSTANT_WIDTH_SUM;
}

- (CGFloat)heightForWidth:(CGFloat)width {
    CGSize size = CGSizeMake(width-CONSTANT_WIDTH_SUM-2*[Constants TextPadding], CGFLOAT_MAX);
    CGFloat height = 0.0;
    for (MKLabel *label in self.labels) {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        NSRange range;
        //TODO: should loop through all fonts
        id fontAttr = [label.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:&range];
        if (fontAttr) {
            CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontAttr} context:context];
            height += rect.size.height + 2*[Constants TextPadding] + 1.0;
        }
    }
    return fmaxf(fmaxf(height, self.leftView.frame.size.height), fmaxf(height, self.rightView.frame.size.height)) + EDGE_INSETS.top + EDGE_INSETS.bottom;
}

@end
