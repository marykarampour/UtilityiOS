//
//  MKUButtonView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-09-01.
//

#import "MKUButtonView.h"
#import "UIView+Utility.h"
#import "NSString+AttributedText.h"

static CGFloat const PADDING = 4.0;

@interface MKUButtonView ()

@property (nonatomic, strong, readwrite) UILabel *titleView;
@property (nonatomic, strong, readwrite) UIButton *backButton;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation MKUButtonView

- (instancetype)init {
    return [self initWithBadgeSize:20.0];
}

- (void)initBase {
    
    self.titleView = [[UILabel alloc] init];
    self.titleView.textAlignment = NSTextAlignmentLeft;
    self.titleView.numberOfLines = 0;
    self.titleView.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.backButton = [[UIButton alloc] init];
    
    [self addSubview:self.titleView];
    [self addSubview:self.backButton];
}

- (void)constraintSeparator {
    self.separatorView = [[UIView alloc] init];
    [self addSubview:self.separatorView];
    [self bringSubviewToFront:self.separatorView];
    [self constraintHeight:1.0 forView:self.separatorView];
    [self constraintSidesExcluding:NSLayoutAttributeTop view:self.separatorView];
}

- (instancetype)initWithStyle:(MKU_VIEW_STYLE)style {
    if (self = [super init]) {
        [self initBase];
        
        [self constraintSidesForView:self.titleView insets:UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING)];
        [self constraintSidesForView:self.backButton];
        
        switch (style) {
            case MKU_VIEW_STYLE_ROUND_CORNERS:
                self.layer.cornerRadius = [Constants ButtonCornerRadious];
            case MKU_VIEW_STYLE_BORDER:
                self.layer.borderColor = [AppTheme mediumBlueColorWithAlpha:1.0].CGColor;
                self.layer.borderWidth = 1.0;
                break;
            default:
                [self constraintSeparator];
                break;
        }
        [self removeConstraintsMask];
    }
    return self;
}

- (instancetype)initWithBadgeSize:(CGFloat)size {
    return [self initWithBadgeSize:size viewCreationHandler:^UIView *{
        return [[UIView alloc] init];
    }];
}

- (instancetype)initWithBadgeSize:(CGFloat)size viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        [self initBase];
        
        if (0 < size && handler) {
            self.badgeView = handler();
            self.badgeView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self addSubview:self.badgeView];
            [self bringSubviewToFront:self.badgeView];
            
            [self constraintWidth:size forView:self.badgeView];
            [self constraintSameWidthHeightForView:self.badgeView];
            [self constraint:NSLayoutAttributeCenterY view:self.badgeView];
            [self constraint:NSLayoutAttributeRight view:self.badgeView margin:-[Constants HorizontalSpacing]];
            [self addConstraintWithItem:self.badgeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]/2.0];
            [self constraint:NSLayoutAttributeLeft view:self.titleView margin:[Constants HorizontalSpacing]];
            [self constraint:NSLayoutAttributeTop view:self.titleView];
            [self constraint:NSLayoutAttributeBottom view:self.titleView];
        }
        else {
            [self constraintSidesForView:self.titleView insets:UIEdgeInsetsMake([Constants HorizontalSpacing], [Constants HorizontalSpacing], [Constants HorizontalSpacing], [Constants HorizontalSpacing])];
        }
        
        [self constraintSidesForView:self.backButton];
        [self constraintSeparator];
        [self removeConstraintsMask];
    }
    return self;
}

- (void)setSeparatorColor:(UIColor *)color {
    self.separatorView.backgroundColor = color;
    self.separatorView.hidden = !color;
}

- (void)addTarget:(id)target action:(SEL)action {
    if ([target respondsToSelector:action]) {
        [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setLabelTitle:(NSString *)title {
    self.titleView.text = title;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.backButton.indexPath = indexPath;
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [MKUStringAttributes setTitle:title subtitle:subtitle forLabel:self.titleView];
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    [MKUStringAttributes setTitle:title value:value forLabel:self.titleView delimiter:kColonEmptyString];
}

+ (MKUButtonView *)BlueButtonWithTitle:(NSString *)title hidden:(BOOL)hidden {
    
    MKUButtonView *view = [[MKUButtonView alloc] initWithStyle:MKU_VIEW_STYLE_ROUND_CORNERS];
    view.titleView.font = [AppTheme smallBoldLabelFont];
    view.titleView.textColor = [AppTheme mediumBlueColorWithAlpha:1.0];
    view.titleView.text = title;
    view.titleView.textAlignment = NSTextAlignmentCenter;
    view.hidden = hidden;
    return view;
}

+ (MKUButtonView *)BlueButtonWithTitle:(NSString *)title {
    return [self BlueButtonWithTitle:title hidden:NO];
}

+ (MKUButtonView *)detailButtonWithStyle:(MKU_VIEW_STYLE)style {
    MKUButtonView *button = [[MKUButtonView alloc] initWithStyle:style];
    button.titleView.font = [AppTheme smallBoldLabelFont];
    button.titleView.textColor = [AppTheme darkBlueColorWithAlpha:1.0];
    button.titleView.numberOfLines = 0;
    button.titleView.lineBreakMode = NSLineBreakByWordWrapping;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0;
    return button;
}

+ (MKUButtonView *)cornerDetailButtonWithStyle:(MKU_VIEW_STYLE)style {
    MKUButtonView *button = [self detailButtonWithStyle:style];
    button.layer.cornerRadius = [Constants ButtonCornerRadious];
    return button;
}

@end

@implementation MKUButtonImageView

- (instancetype)initWithBadgeSize:(CGFloat)size {
    return [super initWithBadgeSize:size viewCreationHandler:^UIView *{
        return [[UIImageView alloc] init];
    }];
}

- (void)setImageName:(NSString *)image {
    self.badgeView.image = [UIImage imageNamed:image];
}

- (void)setImage:(UIImage *)image {
    self.badgeView.image = image;
}

+ (MKUButtonImageView *)detailButton {
    MKUButtonImageView *button = [[MKUButtonImageView alloc] initWithBadgeSize:[Constants ButtonChevronSize]];
    button.badgeView.tintColor = [AppTheme buttonDisclosureChevronColor];
    button.titleView.font = [AppTheme smallBoldLabelFont];
    button.titleView.textColor = [AppTheme darkBlueColorWithAlpha:1.0];
    button.titleView.numberOfLines = 0;
    button.titleView.lineBreakMode = NSLineBreakByWordWrapping;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = [Constants ButtonCornerRadious];
    button.layer.borderColor = [AppTheme buttonDisclosureBorderColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setImage:[MKUAssets systemIconWithName:@"chevron.right" color:[AppTheme buttonDisclosureChevronColor]]];
    return button;
}

+ (MKUButtonView *)detailButtonWithTitle:(NSString *)title {
    MKUButtonView *button = [self detailButton];
    button.titleView.text = title;
    return button;
}

+ (MKUButtonView *)cornerDetailButton {
    MKUButtonView *button = [self detailButton];
    button.layer.cornerRadius = [Constants ButtonCornerRadious];
    return button;
}

@end

@implementation MKUButtonBadgeView

- (instancetype)initWithBadgeSize:(CGFloat)size {
    return [super initWithBadgeSize:size viewCreationHandler:^UIView *{
        return [[MKUBadgeView alloc] init];
    }];
}

@end
