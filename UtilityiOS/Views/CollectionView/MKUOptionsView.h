//
//  MKUOptionsView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollectionView.h"
#import "MKUGenericCell.h"
#import "ActionObject.h"
#import "MKULabel.h"

@interface MKUOptionViewAttributes : NSObject
//TODO: subclass of MKUCollectionViewAttributes
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSUInteger itemsPerPage;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat interItemSpacing;
@property (nonatomic, assign) CGFloat iconSize;

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, assign) Class cellClass;

@end

@interface MKUIconAttributes : NSObject

@property (nonatomic, assign) CGFloat iconSize;
@property (nonatomic, assign) CGFloat borderidth;
@property (nonatomic, strong) UIColor *borderColor;

+ (MKUIconAttributes *)iconWithSize:(CGFloat)size borderidth:(CGFloat)borderidth borderColor:(UIColor *)borderColor;

@end


@interface MKUOptionsCollectionViewCell : MKUCollectionViewCell

@property (nonatomic, strong, readonly) MKULabel *titleLabel;

- (void)setIconName:(NSString *)iconName iconColor:(UIColor *)iconColor title:(NSString *)title;

/** @brief subclass must implement to customize the icon */
- (MKUIconAttributes *)iconAttributes;

@end

@interface MKUHorizontalOptionsViewController : MKUHorizontalCollectionViewController

@property (nonatomic, strong) NSArray<OptionObject *> *options;

/** @breif subclass must implement to use a custom cell */
- (__kindof MKUOptionsCollectionViewCell *)optionCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKUHorizontalOptionsView : MKUHorizontalContentView

@property (nonatomic, strong, readonly) __kindof MKUHorizontalOptionsViewController *controller;

/** @brief this property returns height when vertical margins set via attributes are added */
@property (nonatomic, assign, readonly) CGFloat estimatedHeight;

- (instancetype)initWithAttributes:(MKUOptionViewAttributes *)attr;

@end
