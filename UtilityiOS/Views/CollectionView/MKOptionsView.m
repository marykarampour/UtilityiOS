//
//  MKOptionsView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKOptionsView.h"
#import "UIImageView+Utility.h"
#import "UIImage+Editing.h"
#import "UIView+Utility.h"
#import "MKLabel.h"

@implementation MKOptionViewAttributes

@end

@implementation MKIconAttributes

+ (MKIconAttributes *)iconWithSize:(CGFloat)size borderidth:(CGFloat)borderidth borderColor:(UIColor *)borderColor {
    MKIconAttributes *attrs = [[MKIconAttributes alloc] init];
    attrs.iconSize = size;
    attrs.borderidth = borderidth;
    attrs.borderColor = borderColor;
    return attrs;
}

@end


@interface MKOptionsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong, readwrite) MKLabel *titleLabel;

@end

@implementation MKOptionsCollectionViewCell

+ (CGSize)estimatedSize {
    return CGSizeMake(100.0, 86.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        MKIconAttributes *attrs = [self iconAttributes];
        self.icon = [UIImageView roundedImageViewWithSize:attrs.iconSize borderWidth:attrs.borderidth borderColor:attrs.borderColor];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLabel = [[MKLabel alloc] init];
        
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

- (MKIconAttributes *)iconAttributes {
    return [MKIconAttributes iconWithSize:52.0 borderidth:[Constants BorderWidth] borderColor:[UIColor whiteColor]];
}

@end


@implementation MKHorizontalOptionsViewController

- (MKCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKOptionsCollectionViewCell *cell = [self optionCellForItemAtIndexPath:indexPath];
    
    OptionObject *option = self.options[indexPath.item];
    [cell setIconName:option.iconName iconColor:option.iconColor title:option.title];
    return cell;
}

- (MKOptionsCollectionViewCell *)optionCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.views.firstObject dequeueReusableCellWithReuseIdentifier:[MKOptionsCollectionViewCell identifier] forIndexPath:indexPath];
}

- (void)setOptions:(NSArray<OptionObject *> *)options {
    _options = options;
}

- (void)loadData {
    self.itemCount = self.options.count;
}

@end


@interface MKHorizontalOptionsView ()

@property (nonatomic, assign, readwrite) CGFloat estimatedHeight;

@end

@implementation MKHorizontalOptionsView

@dynamic controller;

- (instancetype)initWithAttributes:(MKOptionViewAttributes *)attr {
    if (self = [super init]) {
        self.estimatedHeight = [MKOptionsCollectionViewCell estimatedSize].height + 2*attr.verticalPadding;
        
        MKCollectionViewAttributes *attributes = [[MKCollectionViewAttributes alloc] init];
        attributes.itemSize = CGSizeMake((attr.width-2*attr.verticalPadding)/attr.itemsPerPage, [MKOptionsCollectionViewCell estimatedSize].height-2*attr.verticalPadding);
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




