//
//  AppTheme.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-28.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Utility.h"

typedef NS_ENUM(NSUInteger, AppThemeStyle) {
    AppThemeStyle_LIGHT,
    AppThemeStyle_DARK
};

extern AppThemeStyle THEME_STYLE;

@interface AppTheme : NSObject

+ (void)applyTheme;


//Abstracts

//Appearance

+ (UIKeyboardAppearance)keyboardAppearance;

//color
+ (UIColor *)barTintColor;
+ (UIColor *)barTextColor;
+ (UIColor *)seperatorColor;
+ (UIColor *)sectionHeaderTextColor;
+ (UIColor *)sectionHeaderBackgroundColor;
+ (UIColor *)sectionFooterTextColor;
+ (UIColor *)sectionFooterBackgroundColor;
+ (UIColor *)tableFooterBackgroundColor;
+ (UIColor *)tableCellBackgroundColor;
+ (UIColor *)tableCellAccessoryViewColor;
+ (UIImage *)tableCellDisclosureIndicatorImage;

+ (UIColor *)translusentBackground;
+ (UIColor *)VCBackgroundColor;
+ (UIColor *)VCForgroundColor;

+ (UIColor *)textDefaultColor;
+ (UIColor *)textHighlightColor;
+ (UIColor *)textLightColor;
+ (UIColor *)textMediumColor;
+ (UIColor *)textDarkColor;

+ (UIColor *)textFieldLightColor;
+ (UIColor *)textFieldMediumColor;
+ (UIColor *)textFieldDarkColor;

+ (UIColor *)labelLightColor;
+ (UIColor *)labelMediumColor;
+ (UIColor *)labelDarkColor;

+ (UIColor *)buttonBackgroundColor;
+ (UIColor *)buttonTextColor;
+ (UIColor *)buttonHighlightedColor;

+ (UIColor *)textViewBackgroundColor;
+ (UIColor *)textViewBorderColor;
+ (UIColor *)textViewPlaceholderColor;
+ (UIColor *)textViewTextColor;
+ (UIColor *)textViewCharTextColor;

+ (UIColor *)textFieldBackgroundColor;
+ (UIColor *)textFieldBorderColor;
+ (UIColor *)textFieldPlaceholderColor;
+ (UIColor *)textFieldTextColor;

+ (UIColor *)badgeBackgroundColor;
+ (UIColor *)badgeTextColor;

//font
+ (UIFont *)XXsmallLabelFont;
+ (UIFont *)XsmallLabelFont;
+ (UIFont *)smallLabelFont;
+ (UIFont *)mediumLabelFont;
+ (UIFont *)largeLabelFont;
+ (UIFont *)XlargeLabelFont;

+ (UIFont *)XXsmallBoldLabelFont;
+ (UIFont *)XsmallBoldLabelFont;
+ (UIFont *)smallBoldLabelFont;
+ (UIFont *)mediumBoldLabelFont;
+ (UIFont *)largeBoldLabelFont;
+ (UIFont *)XlargeBoldLabelFont;

+ (UIFont *)textViewFont;
+ (UIFont *)textFieldFont;
+ (UIFont *)tableFooterFont;

@end
