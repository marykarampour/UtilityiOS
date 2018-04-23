//
//  MKOptionsView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCollectionView.h"
#import "MKGenericCell.h"
#import "ActionObject.h"
#import "MKLabel.h"

@interface MKOptionViewAttributes : NSObject
//TODO: subclass of MKCollectionViewAttributes
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSUInteger itemsPerPage;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat interItemSpacing;
@property (nonatomic, assign) CGFloat iconSize;

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, assign) Class cellClass;

@end

@interface MKIconAttributes : NSObject

@property (nonatomic, assign) CGFloat iconSize;
@property (nonatomic, assign) CGFloat borderidth;
@property (nonatomic, strong) UIColor *borderColor;

+ (MKIconAttributes *)iconWithSize:(CGFloat)size borderidth:(CGFloat)borderidth borderColor:(UIColor *)borderColor;

@end


@interface MKOptionsCollectionViewCell : MKCollectionViewCell

@property (nonatomic, strong, readonly) MKLabel *titleLabel;

- (void)setIconName:(NSString *)iconName iconColor:(UIColor *)iconColor title:(NSString *)title;

/** @brief subclass must implement to customize the icon */
- (MKIconAttributes *)iconAttributes;

@end

@interface MKHorizontalOptionsViewController : MKHorizontalCollectionViewController

@property (nonatomic, strong) NSArray<OptionObject *> *options;

/** @breif subclass must implement to use a custom cell */
- (__kindof MKOptionsCollectionViewCell *)optionCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKHorizontalOptionsView : MKHorizontalContentView

@property (nonatomic, strong, readonly) __kindof MKHorizontalOptionsViewController *controller;

/** @brief this property returns height when vertical margins set via attributes are added */
@property (nonatomic, assign, readonly) CGFloat estimatedHeight;

- (instancetype)initWithAttributes:(MKOptionViewAttributes *)attr;

@end
