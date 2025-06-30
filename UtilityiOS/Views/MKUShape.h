//
//  MKUShape.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-03-05.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBezierPath+Utility.h"

@interface MKUShape : UIView
/** @brief color is RGBA */
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) ShapeType type;

- (instancetype)initWithType:(ShapeType)type color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
+ (MKUShape *)shapeWithType:(ShapeType)type color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end
