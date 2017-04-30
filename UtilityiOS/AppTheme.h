//
//  AppTheme.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-28.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AppThemeStyle) {
    AppThemeStyleLight,
    AppThemeStyleDark
};

@interface AppTheme : NSObject

+ (void)applyTheme;


//Abstracts

//color
+ (UIColor *)seperatorColor;
+ (UIColor *)VCBackgroundColor;
+ (UIColor *)VCForgroundColor;

+ (UIColor *)textLightColor;
+ (UIColor *)textMediumColor;
+ (UIColor *)textDarkColor;

+ (UIColor *)textFieldLightColor;
+ (UIColor *)textFieldMediumColor;
+ (UIColor *)textFieldDarkColor;

+ (UIColor *)labelLightColor;
+ (UIColor *)labelMediumColor;
+ (UIColor *)labelDarkColor;


//font
+ (UIFont *)smallLabelFont;
+ (UIFont *)mediumLabelFont;
+ (UIFont *)largeLabelFont;

+ (UIFont *)smallBoldLabelFont;
+ (UIFont *)mediumBoldLabelFont;
+ (UIFont *)largeBoldLabelFont;


@end
