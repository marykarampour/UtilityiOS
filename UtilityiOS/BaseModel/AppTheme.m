//
//  AppTheme.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-28.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "AppTheme.h"

@implementation AppTheme

+ (void)applyTheme {
    [[UINavigationBar appearance] setBarTintColor:[self barTintColor]];
    [[UINavigationBar appearance] setTintColor:[self navBarTintColor]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self barTextColor], NSFontAttributeName:[self navBarFont]}];
    
    /*
    [[UIBarButtonItem appearance] setTintColor:[self barTextColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self barTextColor], NSFontAttributeName:[self navBarFont]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self barTextColor], NSFontAttributeName:[self navBarFont]} forState:UIControlStateSelected];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self barTextColor], NSFontAttributeName:[self navBarFont]} forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self barTextDisabledColor], NSFontAttributeName:[self navBarFont]} forState:UIControlStateDisabled];
    if (@available(iOS 9.0, *)) {
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self barTextColor], NSFontAttributeName:[self navBarFont]} forState:UIControlStateFocused];
    }*/
    
    [[UITabBar appearance] setBarTintColor:[self VCBackgroundColor]];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self textDefaultColor], NSFontAttributeName:[self mediumLabelFont]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self textHighlightColor], NSFontAttributeName:[self mediumLabelFont]} forState:UIControlStateSelected];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[self segmentedControlSelectedColor],
       NSFontAttributeName:[self segmentedControlFont]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[self segmentedControlNormalColor],
       NSFontAttributeName:[self segmentedControlFont]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setBackgroundColor:[AppTheme segmentedControlNormalColor]];
    [[UISegmentedControl appearance] setTintColor:[AppTheme segmentedControlSelectedColor]];
    
    [UITextField appearance].keyboardAppearance = [AppTheme keyboardAppearance];
    
    [[UIStepper appearance] setTintColor:[self stepperTintColor]];
    
    [[UISearchBar appearance] setBarTintColor:[self searchBarElementsTintColor]];
    [[UISearchBar appearance] setTintColor:[self searchBarTintColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[self searchBarTextFieldBackgroundColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[self searchBarTextColor]];
}

+ (UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDefault;
}

#pragma mark - color

+ (UIColor *)textHighlightColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blueColor];
        case AppThemeStyle_DARK: return [UIColor blueColor];
        default: return [UIColor whiteColor];
    }
}
     
+ (UIColor *)barTintColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)navBarTintColor {
    return [self barTextColor];
}

+ (UIColor *)stepperTintColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)barTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)barTextDisabledColor {
    return [UIColor grayColor];
}

+ (UIColor *)seperatorColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor grayColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)translusentBackground {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor colorWithWhite:0.0 alpha:0.67];
        case AppThemeStyle_DARK: return [UIColor colorWithWhite:1.0 alpha:0.33];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)VCBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)VCForgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

#pragma mark - table

+ (UIColor *)sectionHeaderTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionFooterBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}


+ (UIColor *)sectionFooterTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionHeaderBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableFooterBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableCellBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableCellAccessoryViewColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIImage *)tableCellDisclosureIndicatorImage {
    return [UIImage imageNamed:@""];
}

#pragma mark - text

+ (UIColor *)textDefaultColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor colorWithWhite:0.3 alpha:1.0];
        case AppThemeStyle_DARK: return [UIColor colorWithWhite:0.7 alpha:1.0];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor colorWithWhite:0.7 alpha:1.0];
        case AppThemeStyle_DARK: return [UIColor colorWithWhite:0.3 alpha:1.0];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonHighlightedColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewBorderColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewPlaceholderColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewCharTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}


+ (UIColor *)textFieldBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldBorderColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldPlaceholderColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)badgeBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)badgeTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)checkboxTintColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)checkboxDisabledColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

#pragma mark - font

+ (UIFont *)XXsmallLabelFont {
    return [UIFont systemFontOfSize:8.0];
}

+ (UIFont *)XsmallLabelFont {
    return [UIFont systemFontOfSize:10.0];
}

+ (UIFont *)smallLabelFont {
    return [UIFont systemFontOfSize:12.0];
}

+ (UIFont *)mediumLabelFont {
    return [UIFont systemFontOfSize:16.0];
}

+ (UIFont *)largeLabelFont {
    return [UIFont systemFontOfSize:22.0];
}

+ (UIFont *)XlargeLabelFont {
    return [UIFont systemFontOfSize:24.0];
}

+ (UIFont *)XXsmallBoldLabelFont {
    return [UIFont boldSystemFontOfSize:8.0];
}

+ (UIFont *)XsmallBoldLabelFont {
    return [UIFont boldSystemFontOfSize:10.0];
}

+ (UIFont *)smallBoldLabelFont {
    return [UIFont boldSystemFontOfSize:12.0];
}

+ (UIFont *)mediumBoldLabelFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *)largeBoldLabelFont {
    return [UIFont boldSystemFontOfSize:22.0];
}

+ (UIFont *)XlargeBoldLabelFont {
    return [UIFont boldSystemFontOfSize:24.0];
}

+ (UIFont *)textViewFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *)textFieldFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *)tableFooterFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *)sectionHeaderFont {
    return [UIFont boldSystemFontOfSize:14.0];
}

+ (UIFont *)sectionFooterFont {
    return [UIFont boldSystemFontOfSize:14.0];
}

+ (UIFont *)XlargeTallBoldFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:24.0];
}

+ (UIFont *)largeTallBoldFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0];
}

+ (UIFont *)mediumTallBoldFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0];
}

+ (UIFont *)largeTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0];
}

+ (UIFont *)XlargeTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:24.0];
}

+ (UIFont *)mediumTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0];
}

+ (UIFont *)smallTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
}

+ (UIFont *)XsmallTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
}

+ (UIFont *)XXsmallTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:10.0];
}

+ (UIFont *)XXlargeTallFont {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:30.0];
}

+ (UIFont *)XXXsmallBoldLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:8.0];
}

+ (UIFont *)XXXsmallLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:8.0];
}


+ (UIColor *)tableCellSelectedColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blueColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableHeaderBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blueColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableHeaderTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)collectionViewSectionHeaderBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blueColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)collectionViewSectionHeaderTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIFont *)collectionViewSectionHeaderFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIColor *)tableFooterTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)segmentedControlNormalColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor blackColor];
        case AppThemeStyle_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)segmentedControlSelectedColor {
    switch (THEME_STYLE) {
        case AppThemeStyle_LIGHT: return [UIColor whiteColor];
        case AppThemeStyle_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)searchBarElementsTintColor {
    return [UIColor clearColor];
}

+ (UIColor *)searchBarTintColor {
    return [UIColor blackColor];
}

+ (UIColor *)searchBarTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)searchBarTextFieldBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIFont *)navBarFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *)segmentedControlFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *)tableHeaderFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIColor *)blackBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x030e1e alpha:alpha];
}

+ (UIColor *)nightBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x172a44 alpha:alpha];
}

+ (UIColor *)darkBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x1c4780 alpha:alpha];
}

+ (UIColor *)darkBrightBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x007aff alpha:alpha];
}

+ (UIColor *)mediumBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x608ac3 alpha:alpha];
}

+ (UIColor *)lightBlueColorWithAlpha:(CGFloat)alpha {//8eaedb - //b4e6f4 - //a8f2f9
    return [UIColor colorWithRGB:0xccffff alpha:alpha];
}

+ (UIColor *)mistBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xc9d2de alpha:alpha];
}

+ (UIColor *)brightBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x00ffff alpha:alpha];//4095ff - //7edaf4 - //3adae8
}

+ (UIColor *)whiteBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xe5f0f3 alpha:alpha];
}

+ (UIColor *)darkGreenColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x0e0f0f alpha:alpha];
}

+ (UIColor *)mediumGreenColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x06d513 alpha:alpha];//215d0f
}

+ (UIColor *)lightGreenColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x94c94d alpha:alpha];
}

+ (UIColor *)mistGreenColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xc8e7a0 alpha:alpha];
}

+ (UIColor *)brightGreenColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x53f722 alpha:alpha];
}

+ (UIColor *)brightSilverColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xcbcac8 alpha:alpha];
}

+ (UIColor *)lightSilverColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xf9f8f6 alpha:alpha];
}

+ (UIColor *)mediumSilverColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xa9a8a7 alpha:alpha];
}

+ (UIColor *)darkSilverColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x686868 alpha:alpha];
}

+ (UIColor *)blackSilverColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x343537 alpha:alpha];
}

+ (UIColor *)brightRedColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xff0000 alpha:alpha];
}

+ (UIColor *)lightRedColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xff9e9e alpha:alpha];
}

+ (UIColor *)mediumRedColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xf31e1e alpha:alpha];
}

+ (UIColor *)darkRedColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xde1111 alpha:alpha];
}

+ (UIColor *)blackRedColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0x8e0202 alpha:alpha];
}

+ (UIColor *)mediumYellowColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xffdf6c alpha:alpha];
}

+ (UIColor *)darkOrangeColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xff6633 alpha:alpha];
}

+ (UIColor *)lightOrangeColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRGB:0xffae00 alpha:alpha];
}



@end
