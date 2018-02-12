//
//  MKCellContentController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-10.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MKCellType) {
    MKCellTypeTableView,
    MKCellTypeCollectionView
};

@protocol MKCellContentControllerProtocol <NSObject>

@required
/** @brief required for MKCellTypeTableView */
- (void)setTableViewCell:(UITableViewCell *)cell;
/** @brief required for MKCellTypeCollectionView */
- (void)setCollectionViewCell:(UICollectionViewCell *)cell;

@end

@interface MKCellContentController : NSObject <MKCellContentControllerProtocol>

@property (nonatomic, assign, readonly) MKCellType cellType;
/** @brief this is the content view of cell */
@property (nonatomic, strong) __kindof UIView *content;
@property (nonatomic, weak, readonly) __kindof UIView *cell;
/** @brief this view when set is added to content view */
@property (nonatomic, strong) __kindof UIView *view;
/** @brief if view is set insets is used to set margins in constriants when added to content view */
@property (nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithCellType:(MKCellType)type;


@end
