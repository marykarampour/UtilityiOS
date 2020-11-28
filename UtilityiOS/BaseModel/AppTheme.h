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
+ (UIColor *)navBarTintColor;
+ (UIColor *)barTextColor;
+ (UIColor *)barTextDisabledColor;
+ (UIColor *)stepperTintColor;
+ (UIColor *)seperatorColor;
+ (UIColor *)sectionHeaderTextColor;
+ (UIColor *)sectionHeaderBackgroundColor;
+ (UIColor *)sectionFooterTextColor;
+ (UIColor *)sectionFooterBackgroundColor;
+ (UIColor *)tableFooterBackgroundColor;
+ (UIColor *)tableFooterTextColor;
+ (UIColor *)tableCellBackgroundColor;
+ (UIColor *)tableCellAccessoryViewColor;
+ (UIImage *)tableCellDisclosureIndicatorImage;
+ (UIFont *)sectionHeaderFont;
+ (UIFont *)sectionFooterFont;

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

+ (UIColor *)checkboxTintColor;
+ (UIColor *)checkboxDisabledColor;

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
+ (UIFont *)XlargeTallBoldFont;
+ (UIFont *)largeTallBoldFont;
+ (UIFont *)mediumTallBoldFont;
+ (UIFont *)largeTallFont;
+ (UIFont *)XlargeTallFont;
+ (UIFont *)mediumTallFont;
+ (UIFont *)smallTallFont;
+ (UIFont *)XsmallTallFont;
+ (UIFont *)XXsmallTallFont;
+ (UIFont *)XXlargeTallFont;
+ (UIFont *)XXXsmallBoldLabelFont;
+ (UIFont *)XXXsmallLabelFont;

+ (UIFont *)textViewFont;
+ (UIFont *)textFieldFont;
+ (UIFont *)tableFooterFont;

+ (UIFont *)navBarFont;

+ (UIFont *)segmentedControlFont;
+ (UIColor *)segmentedControlNormalColor;
+ (UIColor *)segmentedControlSelectedColor;

+ (UIColor *)tableCellSelectedColor;
+ (UIColor *)tableHeaderBackgroundColor;
+ (UIColor *)tableHeaderTextColor;
+ (UIFont *)tableHeaderFont;

+ (UIColor *)collectionViewSectionHeaderBackgroundColor;
+ (UIColor *)collectionViewSectionHeaderTextColor;
+ (UIFont *)collectionViewSectionHeaderFont;

+ (UIColor *)searchBarTintColor;
+ (UIColor *)searchBarElementsTintColor;
+ (UIColor *)searchBarTextColor;
+ (UIColor *)searchBarTextFieldBackgroundColor;

+ (UIColor *)blackBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)nightBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)darkBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)mediumBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)mistBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)brightBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)whiteBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)darkBrightBlueColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)darkGreenColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)mediumGreenColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightGreenColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)mistGreenColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)brightGreenColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)brightSilverColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightSilverColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)mediumSilverColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)darkSilverColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)blackSilverColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)brightRedColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightRedColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)mediumRedColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)darkRedColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)blackRedColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)mediumYellowColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)darkOrangeColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightOrangeColorWithAlpha:(CGFloat)alpha;

@end
