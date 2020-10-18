//
//  MKGenericCell.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-11.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCellContentController.h"
#import "MKBaseTableViewCell.h"
#import "MKCollectionView.h"

@protocol MKHorizontalCellProtocol <NSObject>

@required
- (void)setAttributes:(MKCollectionViewAttributes *)attributes;
@property (nonatomic, strong, readonly) __kindof MKHorizontalCollectionViewController *controller;

@end

@interface MKGenericCell : NSObject

@end

/** @brief this cell contains a one row collection view */

@interface MKHorizontalTableViewCell : MKBaseTableViewCell <MKHorizontalCellProtocol>

@property (nonatomic, strong, readonly) __kindof MKHorizontalCollectionViewController *controller;

@end

@interface MKHorizontalCollectionViewCell : MKCollectionViewCell <MKHorizontalCellProtocol>

@property (nonatomic, strong, readonly) __kindof MKHorizontalCollectionViewController *controller;

@end

@interface MKHorizontalContentView : UIView <MKHorizontalCellProtocol>

@property (nonatomic, strong, readonly) __kindof MKHorizontalCollectionViewController *controller;

+ (CGFloat)estimatedHeight;

@end


