//
//  MKUCellContentController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-02-10.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MKUCellType) {
    MKUCellTypeTableView,
    MKUCellTypeCollectionView
};

@protocol MKUCellContentControllerProtocol <NSObject>

@required
/** @brief required for MKUCellTypeTableView */
- (void)setTableViewCell:(UITableViewCell *)cell;
/** @brief required for MKUCellTypeCollectionView */
- (void)setCollectionViewCell:(UICollectionViewCell *)cell;

@end

@interface MKUCellContentController : NSObject <MKUCellContentControllerProtocol>

@property (nonatomic, assign, readonly) MKUCellType cellType;
/** @brief this is the content view of cell */
@property (nonatomic, strong) __kindof UIView *content;
@property (nonatomic, weak, readonly) __kindof UIView *cell;
/** @brief this view when set is added to content view */
@property (nonatomic, strong) __kindof UIView *view;
/** @brief if view is set insets is used to set margins in constriants when added to content view */
@property (nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithCellType:(MKUCellType)type;


@end
