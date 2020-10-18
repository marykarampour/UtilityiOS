//
//  MKLabel.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKLabel : UILabel

@end

@interface MKLabelMetaData : NSObject

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;

+ (MKLabelMetaData *)dataWithInsets:(UIEdgeInsets)insets font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor;

@end

/** @brief This class is a view containing a MKLabel for easy inset and layout optons */
@interface MKEmbededLabel : UIView

@property (nonatomic, strong) MKLabelMetaData *metaData;
@property (nonatomic, strong, readonly) MKLabel *label;

@end
