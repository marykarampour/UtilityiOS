//
//  MKUArrowView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-13.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKUArrowView : UIView

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, strong) UIColor *color;
/**@breif padding for drawing the arrow in view's frame */
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat depth;

@end
