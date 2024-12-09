//
//  MKUSpinner.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKUSpinner : UIView

+ (MKUSpinner *)spinner;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;
+ (void)show;
+ (void)hide;

@end
