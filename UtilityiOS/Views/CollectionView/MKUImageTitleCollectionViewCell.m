//
//  MKUImageTitleCollectionViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-08.
//

#import "MKUImageTitleCollectionViewCell.h"
#import "UIView+Utility.h"

static CGFloat const LABEL_PADDING = 4.0;
static CGFloat const IMAGE_PADDING = 8.0;

@interface MKUImageTitleCollectionViewCell ()

@property (nonatomic, strong, readwrite) MKUBadgeView *badgeView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) NSLayoutConstraint *badgeWidth;
@property (nonatomic, strong) NSLayoutConstraint *badgeHeight;

@end

@implementation MKUImageTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initBase];
        [self constraintViews];
    }
    return self;
}

- (void)initBase {
    
    self.activeColor = [AppTheme mistBlueColorWithAlpha:1.0];
    self.inactiveColor = [AppTheme lightSilverColorWithAlpha:1.0];
    
    self.badgeView = [[MKUBadgeView alloc] init];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [AppTheme smallBoldLabelFont];
    self.textLabel.numberOfLines = 2;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.badgeView];
    
    self.contentView.backgroundColor = [AppTheme lightSilverColorWithAlpha:1.0];
}

- (void)constraintViews {
    [self.contentView removeConstraintsMask];
    
    [self.contentView constraint:NSLayoutAttributeTop view:self.imageView margin:IMAGE_PADDING];
    [self.contentView constraint:NSLayoutAttributeLeft view:self.imageView margin:IMAGE_PADDING];
    [self.contentView constraint:NSLayoutAttributeRight view:self.imageView margin:-IMAGE_PADDING];
    [self.contentView constraint:NSLayoutAttributeBottom view:self.textLabel margin:-LABEL_PADDING];
    [self.contentView constraint:NSLayoutAttributeLeft view:self.textLabel margin:LABEL_PADDING];
    [self.contentView constraint:NSLayoutAttributeRight view:self.textLabel margin:-LABEL_PADDING];
    [self.contentView constraint:NSLayoutAttributeTop view:self.badgeView margin:LABEL_PADDING];
    [self.contentView constraint:NSLayoutAttributeRight view:self.badgeView margin:-LABEL_PADDING];
    
    [self.contentView constraintHeight:32 forView:self.textLabel];
    [self.contentView addConstraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-IMAGE_PADDING];
    
    self.badgeWidth = [self.contentView constraintWidth:0.0 forView:self.badgeView];
    self.badgeHeight = [self.contentView constraintHeight:0.0 forView:self.badgeView];
}


+ (CGSize)estimatedSize {
    CGFloat size = [Constants screenWidth] / 3.0 - 4*[Constants HorizontalSpacing];
    return CGSizeMake(size, size);
}

//TODO: for style it needs a square shapped back view around image
- (void)setBorderStyle:(MKU_IMAGE_TITLE_BORDER_STYLE)borderStyle {
    _borderStyle = borderStyle;
    
    UIView *border;
    
    switch (borderStyle) {
        case MKU_IMAGE_TITLE_BORDER_STYLE_IMAGE:
            border = self.imageView;
            break;
            
        case MKU_IMAGE_TITLE_BORDER_STYLE_ALL:
            border = self.contentView;
            break;
            
        default:
            break;
    }
    
    border.layer.cornerRadius = [Constants ButtonCornerRadious];
    border.layer.borderColor = [AppTheme darkBlueColorWithAlpha:1.0].CGColor;
    border.layer.borderWidth = 1.0;
}

- (void)setBadgeTitle:(NSString *)title {
    CGSize size = [self.badgeView setText:title];
    self.badgeWidth.constant = size.width;
    self.badgeHeight.constant = size.height;
}

@end
