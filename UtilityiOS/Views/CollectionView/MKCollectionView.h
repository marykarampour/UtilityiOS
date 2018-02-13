//
//  MKCollectionView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCellContentController.h"

@class MKHorizontalCollectionViewCell;

typedef NS_OPTIONS(NSUInteger, CollectionViewOrientation) {
    CollectionViewOrientation_Horizontal = 1 << 0,
    CollectionViewOrientation_Vertical = 1 << 1
};


@interface MKCollectionViewAttributes : NSObject

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat itemSpacing;

@end


@interface MKCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MKCellContentController *cellController;

+ (NSString *)identifier;
+ (CGSize)estimatedSize;

@end


@interface MKCollectionView : UICollectionView

+ (NSString *)identifier;
- (instancetype)initWithCollectionViewAttributes:(MKCollectionViewAttributes *)attributes orientation:(CollectionViewOrientation)orientation;

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

@end

/** @brief subclass allows for only one view, the view can be replaced by another view, it can't be removed */
@interface MKSingleCollectionViewController : MKCollectionViewController
//TODO: temporary property
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSIndexPath *currentFirstItem;
@property (nonatomic, strong) MKCollectionViewAttributes *attributes;

@end

@protocol MKVerticalCollectionViewProtocol <NSObject>

@required
- (__kindof MKCollectionViewCell *)verticalCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MKHorizontalCollectionViewProtocol <NSObject>

@required
- (__kindof MKCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKVerticalCollectionViewController : MKSingleCollectionViewController <MKVerticalCollectionViewProtocol>

@property (nonatomic, assign) NSUInteger sectionCount;

@end

@interface MKHorizontalCollectionViewController : MKSingleCollectionViewController <MKHorizontalCollectionViewProtocol>

@property (nonatomic, assign) NSUInteger itemCount;

- (instancetype)initWithAttributes:(MKCollectionViewAttributes *)attributes;

@end

