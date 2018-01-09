//
//  MKSpinner.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKSpinner : UIView

+ (MKSpinner *)spinner;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;
+ (void)show;
+ (void)hide;

@end
