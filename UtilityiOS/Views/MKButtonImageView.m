//
//  MKButtonImageView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKButtonImageView.h"
#import "UIView+Utility.h"

@interface MKButtonImageView ()

@property (nonatomic, strong, readwrite) UILabel *titleView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MKButtonImageView

- (instancetype)init {
    return [self initWithImageHeight:20.0];
}

- (instancetype)initWithImageHeight:(CGFloat)imageHeight {
    if (self = [super init]) {
        self.titleView = [[UILabel alloc] init];
        self.titleView.font = [AppTheme mediumLabelFont];
        self.titleView.textColor = [AppTheme labelMediumColor];
        self.titleView.textAlignment = NSTextAlignmentLeft;
        
        self.backButton = [[UIButton alloc] init];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.titleView];
        [self addSubview:self.backButton];
        [self addSubview:self.imageView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_backButton, _titleView, _imageView);
        [self removeConstraintsMask];
        
        [self constraintSidesForView:self.backButton];
        [self constraint:NSLayoutAttributeBottom view:self.titleView];
        [self constraint:NSLayoutAttributeTop view:self.titleView];
        [self constraintSameWidthHeightForView:self.imageView];
        [self addConstraintsWithFormat:[NSString stringWithFormat:@"H:|-(%f)-[_titleView]-[_imageView(%f)]-(%f)-|", [Constants HorizontalSpacing], imageHeight, [Constants HorizontalSpacing]] options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    }
    return self;
}

- (void)setTarget:(id)target action:(SEL)action {
    [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLabelTitle:(NSString *)title {
    self.titleView.text = title;
}

- (void)setImageName:(NSString *)image {
    self.imageView.image = [UIImage imageNamed:image];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.backButton.indexPath = indexPath;
}

@end
