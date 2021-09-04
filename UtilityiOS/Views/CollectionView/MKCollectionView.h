//
//  MKCollectionView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCellContentController.h"
#import "MKDateRange.h"

@class MKHorizontalCollectionViewCell;

@interface MKCollectionViewAttributes : UICollectionViewFlowLayout <NSCopying>

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) CGRect frame;

@end


@interface MKCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MKCellContentController *cellController;

+ (NSString *)identifier;
+ (CGSize)estimatedSize;

@end


@interface MKCollectionView : UICollectionView

+ (NSString *)identifier;
- (instancetype)initWithCollectionViewAttributes:(MKCollectionViewAttributes *)attributes;
- (void)reload;
- (void)reloadWithCompletion:(void (^)(void))completion;

- (NSIndexPath *)indexPathForFirstItem;
- (MKRange *)indexRangeForVisibleItems;

@end


@protocol MKCollectionViewProtocol <NSObject>

@required
- (__kindof MKCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKVerticalCollectionViewCell : MKCollectionViewCell

@end


@interface MKCollectionViewController : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKCollectionViewProtocol>

@property (nonatomic, strong, readonly) NSMutableArray <__kindof MKCollectionView *> *views;

- (void)addView:(__kindof MKCollectionView *)view;
- (void)insertView:(__kindof MKCollectionView *)view atIndex:(NSUInteger)index;
- (void)replaceViewAtIndex:(NSUInteger)index withView:(__kindof MKCollectionView *)view;
- (void)removeView:(__kindof MKCollectionView *)view;
- (void)removeViewAtIndex:(NSUInteger)index;
/** @brief subclassmust implement to load data source for collection views */
- (void)loadData;

@end

/** @brief subclass allows for only one view, the view can be replaced by another view, it can't be removed */
@interface MKSingleCollectionViewController : MKCollectionViewController
//TODO: temporary property
@property (nonatomic, assign) NSUInteger index;
/** @breif this property is used in loadData method, e.g object can be a date, used to retrieve items */
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSIndexPath *currentFirstItem;
@property (nonatomic, strong) MKCollectionViewAttributes *attributes;

- (MKCollectionView *)view;

@end


@interface MKVerticalCollectionHeaderAttributes : NSObject

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIFont *font;

@end

@protocol MKVerticalCollectionViewProtocol <NSObject>

@required
- (__kindof MKCollectionViewCell *)verticalCellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSection:(NSUInteger)section;

@end

@protocol MKHorizontalCollectionViewProtocol <NSObject>

@required
- (__kindof MKCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKVerticalCollectionViewController : MKSingleCollectionViewController <MKVerticalCollectionViewProtocol>

@property (nonatomic, assign) NSUInteger sectionCount;
@property (nonatomic, strong) MKVerticalCollectionHeaderAttributes *headerAttributes;

@end

@interface MKHorizontalCollectionViewController : MKSingleCollectionViewController <MKHorizontalCollectionViewProtocol>

@property (nonatomic, assign) NSUInteger itemCount;

- (instancetype)initWithAttributes:(MKCollectionViewAttributes *)attributes;

@end

