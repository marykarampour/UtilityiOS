//
//  MKUGenericCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-02-11.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUCellContentController.h"
#import "MKUBaseTableViewCell.h"
#import "MKUCollectionView.h"

@protocol MKUHorizontalCellProtocol <NSObject>

@required
- (void)setAttributes:(MKUCollectionViewLayoutAttributes *)attributes;
@property (nonatomic, strong, readonly) __kindof MKUHorizontalCollectionViewController *controller;

@end

@interface MKUGenericCell : NSObject

@end

/** @brief this cell contains a one row collection view */

@interface MKUHorizontalTableViewCell : MKUBaseTableViewCell <MKUHorizontalCellProtocol>

@property (nonatomic, strong, readonly) __kindof MKUHorizontalCollectionViewController *controller;

@end

@interface MKUHorizontalCollectionViewCell : MKUCollectionViewCell <MKUHorizontalCellProtocol>

@property (nonatomic, strong, readonly) __kindof MKUHorizontalCollectionViewController *controller;

@end

@interface MKUHorizontalContentView : UIView <MKUHorizontalCellProtocol>

@property (nonatomic, strong, readonly) __kindof MKUHorizontalCollectionViewController *controller;

+ (CGFloat)estimatedHeight;

@end


