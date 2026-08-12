//
//  MKUMultiLabelViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-03-27.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUMultiLabelViewController.h"
#import "NSArray+Utility.h"
#import "UIView+Utility.h"

@interface MKUMultiLabelViewController ()

@property (nonatomic, assign) MKU_MULTI_LABEL_VIEW_TYPE type;

@property (nonatomic, strong, readwrite) __kindof UIView *contentView;
@property (nonatomic, strong, readwrite) MKUContainerView *leftView;
@property (nonatomic, strong, readwrite) MKUContainerView *rightView;
@property (nonatomic, strong, readwrite) MKUVerticalViews<__kindof MKULabel *> *labels;
@property (nonatomic, strong, readwrite) __kindof UIView *backView;
@property (nonatomic, assign) CGFloat constantWidthSum;
@property (nonatomic, assign) UIEdgeInsets edgeIndests;

- (void)createLabels:(NSUInteger)labelsCount;
- (void)addLeftView:(__kindof UIView *)leftView;
- (void)addRightView:(__kindof UIView *)rightView;
- (void)constraintLabels;

@end


@implementation MKUMultiLabelViewController

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (instancetype)initWithContentView:(__kindof UIView *)contentView {
    if (self = [super init]) {
        self.contentView = contentView ? contentView : [[UIView alloc] init];
        [self addSubview:self.contentView];
        [self removeConstraintsMask];
        [self constraintSidesForView:self.contentView];
    }
    return self;
}

- (void)constructWithType:(MKU_MULTI_LABEL_VIEW_TYPE)type leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets {
    
    self.edgeIndests = insets;
    self.leftView = [[MKUContainerView alloc] initWithFrame:leftView.frame];
    self.rightView = [[MKUContainerView alloc] initWithFrame:rightView.frame];
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.rightView];
    
    if ((type == MKU_MULTI_LABEL_VIEW_TYPE_NONE) && (leftView || rightView)) {
        [self constructWithSingleView:(leftView ? leftView : rightView)];
    }
    if ((type == MKU_MULTI_LABEL_VIEW_TYPE_LABEL) && labelsCount > 0) {
        [self constructWithLabelsCount:labelsCount];
    }
    else if ((type & MKU_MULTI_LABEL_VIEW_TYPE_LABEL) &&
             (type & MKU_MULTI_LABEL_VIEW_TYPE_LEFT) &&
             !(type & MKU_MULTI_LABEL_VIEW_TYPE_RIGHT) &&
             labelsCount > 0 && leftView) {
        [self constructWithLabelsCount:labelsCount leftView:leftView];
    }
    else if ((type & MKU_MULTI_LABEL_VIEW_TYPE_LABEL) &&
             !(type & MKU_MULTI_LABEL_VIEW_TYPE_LEFT) &&
             (type & MKU_MULTI_LABEL_VIEW_TYPE_RIGHT) &&
             labelsCount > 0 && rightView) {
        [self constructWithLabelsCount:labelsCount rightView:rightView];
    }
    else if (!(type & MKU_MULTI_LABEL_VIEW_TYPE_LABEL) &&
             (type & MKU_MULTI_LABEL_VIEW_TYPE_LEFT) &&
             (type & MKU_MULTI_LABEL_VIEW_TYPE_RIGHT) &&
             leftView && rightView) {
        [self constructWithLeftView:leftView rightView:rightView];
    }
    else if ((type & MKU_MULTI_LABEL_VIEW_TYPE_LABEL) &&
             (type & MKU_MULTI_LABEL_VIEW_TYPE_LEFT) &&
             (type & MKU_MULTI_LABEL_VIEW_TYPE_RIGHT) &&
             leftView && rightView) {
        [self constructWithLabelsCount:labelsCount leftView:leftView rightView:rightView];
    }
}

#pragma mark - constructors

- (void)constructWithSingleView:(__kindof UIView *)view {
    [self addLeftView:view];
    [self.contentView removeConstraintsMask];
    [self.contentView constraintSidesForView:self.leftView insets:self.edgeIndests];
    
    self.constantWidthSum = self.edgeIndests.left+self.edgeIndests.right;
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount {
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    [self.contentView constraintSidesForView:self.labels insets:self.edgeIndests];
    
    self.constantWidthSum = self.edgeIndests.left+self.edgeIndests.right;
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount leftView:(__kindof UIView *)leftView {
    [self addLeftView:leftView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraintHorizontally:@[self.leftView, self.labels] interItemMargin:[Constants HorizontalSpacing] horizontalMargin:self.edgeIndests.left verticalMargin:CONSTRAINT_NO_PADDING equalWidths:NO parentConstraints:NSLayoutAttributeLeft | NSLayoutAttributeRight verticalConstraints:NSLayoutAttributeNotAnAttribute];
    
    if (self.leftView.frame.size.height > 0.0) {
        [self.contentView constraintSizeForView:self.leftView];
    }
    else {
        [self.contentView constraint:NSLayoutAttributeBottom view:self.leftView margin:-self.edgeIndests.bottom];
        [self.contentView constraintWidthForView:self.leftView];
    }
    
    if (self.leftView.frame.origin.y == MULTILABEL_VERTICAL_ALIGNMENT_CENTER_Y) {
        [self.contentView constraint:NSLayoutAttributeCenterY view:self.leftView];
    }
    else {
        [self.contentView addConstraintWithItem:self.labels attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    }
    
    [self.contentView constraint:NSLayoutAttributeTop view:self.labels margin:self.edgeIndests.top];
    [self.contentView constraint:NSLayoutAttributeBottom view:self.labels margin:-self.edgeIndests.bottom];
    
    self.constantWidthSum = self.edgeIndests.left+self.edgeIndests.right+self.leftView.frame.size.width+[Constants HorizontalSpacing];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraintHorizontally:@[self.labels, self.rightView] interItemMargin:[Constants HorizontalSpacing] horizontalMargin:self.edgeIndests.right verticalMargin:CONSTRAINT_NO_PADDING equalWidths:NO parentConstraints:NSLayoutAttributeLeft | NSLayoutAttributeRight verticalConstraints:NSLayoutAttributeNotAnAttribute];

    if (self.rightView.frame.size.height > 0.0) {
        [self.contentView constraintSizeForView:self.rightView];
    }
    else {
        [self.contentView constraint:NSLayoutAttributeBottom view:self.rightView margin:-self.edgeIndests.bottom];
        [self.contentView constraintWidthForView:self.rightView];
    }
    
    if (self.rightView.frame.origin.y == MULTILABEL_VERTICAL_ALIGNMENT_CENTER_Y) {
        [self.contentView constraint:NSLayoutAttributeCenterY view:self.rightView];
    }
    else {
        [self.contentView addConstraintWithItem:self.labels attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    }
    
    [self.contentView constraint:NSLayoutAttributeTop view:self.labels margin:self.edgeIndests.top];
    [self.contentView constraint:NSLayoutAttributeBottom view:self.labels margin:-self.edgeIndests.bottom];
    
    self.constantWidthSum = self.edgeIndests.left+self.edgeIndests.right+self.rightView.frame.size.width+[Constants HorizontalSpacing];
}

- (void)constructWithLeftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self addLeftView:leftView];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraintHorizontally:@[self.leftView, self.rightView] interItemMargin:[Constants HorizontalSpacing] horizontalMargin:self.edgeIndests.left verticalMargin:CONSTRAINT_NO_PADDING equalWidths:NO parentConstraints:NSLayoutAttributeLeft | NSLayoutAttributeRight verticalConstraints:NSLayoutAttributeNotAnAttribute];

    CGFloat width = self.leftView.frame.size.width;
    BOOL hasSize = NO;
    
    if (leftView.frame.size.width > 0.0 && leftView.frame.size.height > 0.0) {
        hasSize = YES;
        [self.contentView constraintSizeForView:self.leftView];
    }
    else if (leftView.frame.size.width > 0.0) {
        [self.contentView constraintWidthForView:self.leftView];
    }
    else if (leftView.frame.size.height > 0.0) {
        [self.contentView constraintHeightForView:self.leftView];
        width = self.rightView.frame.size.width;
    }
    else {
        hasSize = YES;
        [self.contentView constraintSizeForView:self.rightView];
        width = self.rightView.frame.size.width;
    }
    
    UIView *bottom = (leftView.frame.size.height > rightView.frame.size.height ? leftView : rightView);
    
    if (!hasSize)
    [self.contentView constraint:NSLayoutAttributeBottom view:bottom margin:-self.edgeIndests.bottom];
    [self.contentView constraint:NSLayoutAttributeTop view:self.leftView margin:self.edgeIndests.top];
    
    self.constantWidthSum = self.edgeIndests.left+self.edgeIndests.right+width+[Constants HorizontalSpacing];
}

- (void)constructWithLabelsCount:(NSUInteger)labelsCount leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView {
    [self addRightView:rightView];
    [self addLeftView:leftView];
    [self createLabels:labelsCount];
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraintHorizontally:@[self.leftView, self.labels, self.rightView] interItemMargin:[Constants HorizontalSpacing] horizontalMargin:self.edgeIndests.left verticalMargin:CONSTRAINT_NO_PADDING equalWidths:NO parentConstraints:NSLayoutAttributeLeft | NSLayoutAttributeRight verticalConstraints:NSLayoutAttributeNotAnAttribute];
    
    if (leftView.frame.size.width > 0.0 && leftView.frame.size.height > 0.0) {
        [self.contentView constraintSizeForView:self.leftView];
    }
    else if (leftView.frame.size.width > 0.0) {
        [self.contentView constraintWidthForView:self.leftView];
    }
    else if (leftView.frame.size.height > 0.0) {
        [self.contentView constraintHeightForView:self.leftView];
    }
    
    [self.contentView constraintSizeForView:self.rightView];
    [self.contentView constraint:NSLayoutAttributeTop view:self.leftView margin:self.edgeIndests.top + [Constants TextPadding]];
    
    if (self.rightView.frame.origin.y == MULTILABEL_VERTICAL_ALIGNMENT_CENTER_Y) {
        [self.contentView constraint:NSLayoutAttributeCenterY view:self.rightView];
    }
    else if (self.rightView.frame.origin.y == MULTILABEL_VERTICAL_ALIGNMENT_TOP_FIRST_LABEL) {
        [self.contentView addConstraintWithItem:self.labels attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    }
    else {
        [self.contentView addConstraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    }

    [self.contentView constraint:NSLayoutAttributeTop view:self.labels margin:self.edgeIndests.top];
    [self.contentView constraint:NSLayoutAttributeBottom view:self.labels margin:-self.edgeIndests.bottom];
    
    self.constantWidthSum = 2*self.edgeIndests.left+2*self.edgeIndests.right+self.leftView.frame.size.width+self.rightView.frame.size.width+2*[Constants HorizontalSpacing];
}

#pragma mark - helpers

- (void)createLabels:(NSUInteger)labelsCount {
    self.labels = [[MKUVerticalViews alloc] initWithCount:labelsCount padding:4.0 viewCreationHandler:^UIView *(NSUInteger index) {
        return [self createLabelAtIndex:index];
    }];
    
    [self.contentView addSubview:self.labels];
}

- (MKULabel *)createLabelAtIndex:(NSUInteger)index {
    MKULabel *label = [[MKULabel alloc] init];
    label.numberOfLines = 0;
    label.minimumScaleFactor = 0.5;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    return label;
}

- (void)addLeftView:(__kindof UIView *)leftView {
    self.leftView.view = leftView;
}

- (void)addRightView:(__kindof UIView *)rightView {
    self.rightView.view = rightView;
}

- (void)addBackView:(__kindof UIView<MKUControlProtocol> *)backView {
    self.backView = backView;
    backView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:backView];
    [self.contentView bringSubviewToFront:backView];
    [self.contentView removeConstraintsMask];
    [self.contentView constraintSidesForView:backView];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.backView addTarget:target action:action];
}

- (void)setText:(NSString *)text forLabelAtIndex:(NSUInteger)index {
    if (index < self.labels.count) {
        [self.labels viewAtIndex:index].text = text;
    }
}

- (void)setAttributedText:(NSAttributedString *)text forLabelAtIndex:(NSUInteger)index {
    if (index < self.labels.count) {
        [self.labels viewAtIndex:index].attributedText = text;
    }
}

- (MKULabel *)labelAtIndex:(NSUInteger)index {
    return [self.labels viewAtIndex:index];
}

- (CGFloat)constantWidthSum {
    return _constantWidthSum;
}

- (CGFloat)heightForWidth:(CGFloat)width {
    CGSize size = CGSizeMake(width-self.constantWidthSum-2*[Constants TextPadding], CGFLOAT_MAX);
    CGFloat height = 0.0;
    for (MKULabel *label in [self.labels views]) {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGRect rect = CGRectZero;
        if (label.attributedText) {
            rect = [label.attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:context];
        }
        else if (label.text) {
            NSRange range;
            id fontAttr = [label.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:&range];
            if (fontAttr) {
                rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontAttr} context:context];
            }
        }
        height += rect.size.height + 2*[Constants TextPadding] + 1.0;
    }
    return fmaxf(fmaxf(height, self.leftView.frame.size.height), fmaxf(height, self.rightView.frame.size.height)) + self.edgeIndests.top + self.edgeIndests.bottom;
}

@end
