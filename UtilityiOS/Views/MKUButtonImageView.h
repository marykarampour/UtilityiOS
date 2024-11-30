//
//  MKUButtonImageView.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IndexPath.h"

@interface MKUButtonImageView : UIView

/** @brief default text color is labelMediumColor */
@property (nonatomic, strong, readonly) UILabel *titleView;

/** @brief Default initializer, if init is used instead the default value of imageHeight is used
 @param imageHeight Default is 20.0
 */
- (instancetype)initWithImageHeight:(CGFloat)imageHeight;

- (void)setTarget:(id)target action:(SEL)action;
- (void)setLabelTitle:(NSString *)title;
- (void)setImageName:(NSString *)image;
- (void)setIndexPath:(NSIndexPath *)indexPath;

@end
