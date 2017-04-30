//
//  AppTheme.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-28.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "AppTheme.h"

static AppThemeStyle const THEME_STYLE = AppThemeStyleLight;

@implementation AppTheme

+ (void)applyTheme {
    [[UINavigationBar appearance] setBarTintColor:[self barTintColor]];
    [[UINavigationBar appearance] setTintColor:[self textHighlightColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self textMediumColor], NSFontAttributeName:[self mediumLabelFont]}];
    
    [[UITabBar appearance] setBarTintColor:[self VCBackgroundColor]];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self textDefaultColor], NSFontAttributeName:[self mediumLabelFont]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self textHighlightColor], NSFontAttributeName:[self mediumLabelFont]} forState:UIControlStateSelected];
}

#pragma mark - color

+ (UIColor *)textHighlightColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}
     
+ (UIColor *)barTintColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)seperatorColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)VCBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)VCForgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textDefaultColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

#pragma mark - font

+ (UIFont *)smallLabelFont {
    return [UIFont systemFontOfSize:12.0];
}

+ (UIFont *)mediumLabelFont {
    return [UIFont systemFontOfSize:16.0];
}

+ (UIFont *)largeLabelFont {
    return [UIFont systemFontOfSize:22.0];
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


@end
