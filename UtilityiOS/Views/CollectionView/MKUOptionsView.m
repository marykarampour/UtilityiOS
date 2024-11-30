//
//  MKUOptionsView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUOptionsView.h"
#import "UIImageView+Utility.h"
#import "UIImage+Editing.h"
#import "UIView+Utility.h"
#import "MKULabel.h"

@implementation MKUOptionViewAttributes

@end

@implementation MKUIconAttributes

+ (MKUIconAttributes *)iconWithSize:(CGFloat)size borderidth:(CGFloat)borderidth borderColor:(UIColor *)borderColor {
    MKUIconAttributes *attrs = [[MKUIconAttributes alloc] init];
    attrs.iconSize = size;
    attrs.borderidth = borderidth;
    attrs.borderColor = borderColor;
    return attrs;
}

@end


@interface MKUOptionsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong, readwrite) MKULabel *titleLabel;

@end

@implementation MKUOptionsCollectionViewCell

+ (CGSize)estimatedSize {
    return CGSizeMake(100.0, 86.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        MKUIconAttributes *attrs = [self iconAttributes];
        self.icon = [UIImageView roundedImageViewWithSize:attrs.iconSize borderWidth:attrs.borderidth borderColor:attrs.borderColor];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLabel = [[MKULabel alloc] init];
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView removeConstraintsMask];
        [self.contentView constraintSizeForView:self.icon];
        [self.contentView constraint:NSLayoutAttributeTop view:self.icon];
        [self.contentView constraint:NSLayoutAttributeCenterX view:self.icon];
        
        [self.contentView constraint:NSLayoutAttributeBottom view:self.titleLabel];
        [self.contentView constraint:NSLayoutAttributeCenterX view:self.titleLabel];
    }
    return self;
}

- (void)setIconName:(NSString *)iconName iconColor:(UIColor *)iconColor title:(NSString *)title {
    [self.icon setImageWithTemplateImageName:iconName color:iconColor];
    self.titleLabel.text = title;
}

- (MKUIconAttributes *)iconAttributes {
    return [MKUIconAttributes iconWithSize:52.0 borderidth:[Constants BorderWidth] borderColor:[UIColor whiteColor]];
}

@end


@implementation MKUHorizontalOptionsViewController

- (MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKUOptionsCollectionViewCell *cell = [self optionCellForItemAtIndexPath:indexPath];
    
    OptionObject *option = self.options[indexPath.item];
    [cell setIconName:option.iconName iconColor:option.iconColor title:option.title];
    return cell;
}

- (MKUOptionsCollectionViewCell *)optionCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.views.firstObject dequeueReusableCellWithReuseIdentifier:[MKUOptionsCollectionViewCell identifier] forIndexPath:indexPath];
}

- (void)setOptions:(NSArray<OptionObject *> *)options {
    _options = options;
}

- (void)loadData {
    self.itemCount = self.options.count;
}

@end


@interface MKUHorizontalOptionsView ()

@property (nonatomic, assign, readwrite) CGFloat estimatedHeight;

@end

@implementation MKUHorizontalOptionsView

@dynamic controller;

- (instancetype)initWithAttributes:(MKUOptionViewAttributes *)attr {
    if (self = [super init]) {
        self.estimatedHeight = [MKUOptionsCollectionViewCell estimatedSize].height + 2*attr.verticalPadding;
        
        MKUCollectionViewAttributes *attributes = [[MKUCollectionViewAttributes alloc] init];
        attributes.itemSize = CGSizeMake((attr.width-2*attr.verticalPadding)/attr.itemsPerPage, [MKUOptionsCollectionViewCell estimatedSize].height-2*attr.verticalPadding);
        attributes.minimumLineSpacing = attr.verticalPadding;
        attributes.minimumInteritemSpacing = attr.interItemSpacing;
        attributes.cellClass = attr.cellClass;
        attributes.controllerClass = attr.controllerClass;
        attributes.frame = CGRectMake(0.0, 0.0, attr.width, self.estimatedHeight);
        
        [self setAttributes:attributes];
        [self addSubview:self.controller.views.firstObject];
        [self removeConstraintsMask];
        [self constraintSidesForView:self.controller.views.firstObject];
    }
    return self;
}

@end




