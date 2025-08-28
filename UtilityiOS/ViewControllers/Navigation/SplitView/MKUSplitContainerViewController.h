//
//  MKUSplitContainerViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKUSplitContainerViewController <__covariant MainVCType : __kindof UIViewController *> : UIViewController

@property (nonatomic, strong) MainVCType mainVC;

/** @brief Default is 16.0. */
@property (nonatomic, assign) CGFloat padding;

/** @brief If nonzero, it will be width in MKU_VIEW_ALIGNMENT_TYPE_HORIZONTAL and height in MKU_VIEW_ALIGNMENT_TYPE_VERTICAL.
 Otherwise equal size constraints will be used. */
@property (nonatomic, assign) CGFloat mainVCSize;

/** @brief If nonzero, it will be width in MKU_VIEW_ALIGNMENT_TYPE_HORIZONTAL and height in MKU_VIEW_ALIGNMENT_TYPE_VERTICAL.
 Otherwise equal size constraints will be used. It is ignored if mainVCSize is given. */
@property (nonatomic, assign) CGFloat detailVCSize;

/** @brief Default is MKU_VIEW_ALIGNMENT_TYPE_HORIZONTAL. */
@property (nonatomic, assign) MKU_VIEW_ALIGNMENT_TYPE alignment;

- (void)setMainVC:(__kindof UIViewController *)mainVC;
- (void)setViewWithDetailVC:(__kindof UIViewController *)VC;

@end
