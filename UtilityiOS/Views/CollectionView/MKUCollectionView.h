//
//  MKUCollectionView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - cell

@interface MKUCollectionViewLayoutAttributes : UICollectionViewFlowLayout <NSCopying>

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) CGRect frame;

@end

@interface MKUCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *activeColor;
@property (nonatomic, strong) UIColor *inactiveColor;

+ (NSString *)identifier;
+ (CGSize)estimatedSize;
- (void)setActive:(BOOL)active;

@end

@interface MKUCollectionViewHeaderAttributes : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) UIEdgeInsets insets;

@end

@protocol MKUCollectionHeaderViewProtocol <NSObject>

@required
/** @brief Subclass must implement to constraint title label and other views.
 Default wil constraint sides with insets from MKUCollectionViewHeaderAttributes */
- (void)constraintViews;

@end

@interface MKUCollectionHeaderView : UICollectionReusableView <MKUCollectionHeaderViewProtocol>

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong) UIColor *borderColor;

+ (NSString *)identifier;

@end

@interface MKUVerticalCollectionHeaderView : MKUCollectionHeaderView

@end

#pragma mark - view controller

@interface MKUCollectionView : UICollectionView

+ (NSString *)identifier;
- (instancetype)initWithCollectionViewAttributes:(MKUCollectionViewLayoutAttributes *)attributes;
- (void)reload;
- (void)reloadWithCompletion:(void (^)(void))completion;

- (NSIndexPath *)indexPathForFirstItem;
- (NSRange)indexRangeForVisibleItems;

@end

@protocol MKUCollectionViewProtocol <NSObject>

@required
- (__kindof MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

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

@class MKUSingleCollectionViewController;

@protocol MKUSingleCollectionViewDelegate <NSObject>

@optional
- (void)singleCollectionViewController:(__kindof MKUSingleCollectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MKUSingleCollectionViewProtocol <NSObject>

@optional
- (NSString *)titleForHeader:(MKUCollectionHeaderView *)header inSection:(NSUInteger)section;

/** @brief Default is width = [self view].frame.size.width-self.headerAttributes.insets.left-self.headerAttributes.insets.right and height = 44.0 for MKUVerticalCollectionViewController */
- (CGSize)sizeForHeaderInSection:(NSInteger)section;

/** It is called when collectionView:didSelectItemAtIndexPath is called. singleCollectionViewController:didSelectItemAtIndexPath is called afterwards **/
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/** @brief subclass allows for only one view, the view can be replaced by another view, it can't be removed */
@interface MKUSingleCollectionViewController <__covariant ObjectType : NSObject<NSCopying> *> : MKUCollectionViewController <MKUSingleCollectionViewProtocol>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSUInteger maxItemCount;
@property (nonatomic, strong) NSString *title;

/** @brief Used in loadData method, e.g object can be a date, used to retrieve items */
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSMutableArray<ObjectType> *items;
@property (nonatomic, strong) NSIndexPath *currentFirstItem;
@property (nonatomic, strong) MKUCollectionViewLayoutAttributes *attributes;
@property (nonatomic, strong) MKUCollectionViewHeaderAttributes *headerAttributes;

@property (nonatomic, weak) id<MKUSingleCollectionViewDelegate> delegate;

- (instancetype)initWithAttributes:(MKUCollectionViewLayoutAttributes *)attributes;

- (void)setItemsWithArray:(NSArray<ObjectType> *)items;
/** @brief Thread-safe. */
- (void)addItem:(ObjectType)item;
/** @brief Thread-safe. */
- (void)deleteItem:(ObjectType)item;
- (MKUCollectionView *)view;
- (void)reload;

@end

@protocol MKUVerticalCollectionViewProtocol <MKUSingleCollectionViewProtocol>

@required
- (__kindof MKUCollectionViewCell *)verticalCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MKUHorizontalCollectionViewProtocol <MKUSingleCollectionViewProtocol>

@required
- (__kindof MKUCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKUVerticalCollectionViewController <__covariant ObjectType : NSObject<NSCopying> *> : MKUSingleCollectionViewController <ObjectType> <MKUVerticalCollectionViewProtocol>

@end

@interface MKUHorizontalCollectionViewController <__covariant ObjectType : NSObject<NSCopying> *> : MKUSingleCollectionViewController <ObjectType> <MKUHorizontalCollectionViewProtocol>

@end


