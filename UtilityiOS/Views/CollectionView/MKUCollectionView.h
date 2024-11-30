//
//  MKUCollectionView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUCellContentController.h"
#import "MKUDateRange.h"

@class MKUHorizontalCollectionViewCell;

@interface MKUCollectionViewAttributes : UICollectionViewFlowLayout <NSCopying>

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) CGRect frame;

@end


@interface MKUCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MKUCellContentController *cellController;

+ (NSString *)identifier;
+ (CGSize)estimatedSize;

@end


@interface MKUCollectionView : UICollectionView

+ (NSString *)identifier;
- (instancetype)initWithCollectionViewAttributes:(MKUCollectionViewAttributes *)attributes;
- (void)reload;
- (void)reloadWithCompletion:(void (^)(void))completion;

- (NSIndexPath *)indexPathForFirstItem;
- (MKURange *)indexRangeForVisibleItems;

@end


@protocol MKUCollectionViewProtocol <NSObject>

@required
- (__kindof MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKUVerticalCollectionViewCell : MKUCollectionViewCell

@end


@interface MKUCollectionViewController : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKUCollectionViewProtocol>

@property (nonatomic, strong, readonly) NSMutableArray <__kindof MKUCollectionView *> *views;

- (void)addView:(__kindof MKUCollectionView *)view;
- (void)insertView:(__kindof MKUCollectionView *)view atIndex:(NSUInteger)index;
- (void)replaceViewAtIndex:(NSUInteger)index withView:(__kindof MKUCollectionView *)view;
- (void)removeView:(__kindof MKUCollectionView *)view;
- (void)removeViewAtIndex:(NSUInteger)index;
/** @brief subclassmust implement to load data source for collection views */
- (void)loadData;

@end

/** @brief subclass allows for only one view, the view can be replaced by another view, it can't be removed */
@interface MKUSingleCollectionViewController : MKUCollectionViewController
//TODO: temporary property
@property (nonatomic, assign) NSUInteger index;
/** @breif this property is used in loadData method, e.g object can be a date, used to retrieve items */
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSIndexPath *currentFirstItem;
@property (nonatomic, strong) MKUCollectionViewAttributes *attributes;

- (MKUCollectionView *)view;

@end


@interface MKUVerticalCollectionHeaderAttributes : NSObject

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIFont *font;

@end

@protocol MKUVerticalCollectionViewProtocol <NSObject>

@required
- (__kindof MKUCollectionViewCell *)verticalCellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSection:(NSUInteger)section;

@end

@protocol MKUHorizontalCollectionViewProtocol <NSObject>

@required
- (__kindof MKUCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKUVerticalCollectionViewController : MKUSingleCollectionViewController <MKUVerticalCollectionViewProtocol>

@property (nonatomic, assign) NSUInteger sectionCount;
@property (nonatomic, strong) MKUVerticalCollectionHeaderAttributes *headerAttributes;

@end
//TODO: this should be MKUSingleSectionCollectionViewController either vertical or horizontal
@interface MKUHorizontalCollectionViewController : MKUSingleCollectionViewController <MKUHorizontalCollectionViewProtocol>

@property (nonatomic, assign) NSUInteger itemCount;

- (instancetype)initWithAttributes:(MKUCollectionViewAttributes *)attributes;
- (void)addIdentifier:(NSString *)identifier;

@end

