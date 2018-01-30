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
    
    [[UISegmentedControl appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[self buttonTextColor],
       NSFontAttributeName:[self mediumLabelFont]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[self buttonBackgroundColor],
       NSFontAttributeName:[self mediumLabelFont]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setBackgroundColor:[AppTheme buttonTextColor]];
    [[UISegmentedControl appearance] setTintColor:[AppTheme buttonBackgroundColor]];
}

#pragma mark - color

+ (UIColor *)textHighlightColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blueColor];
        case AppThemeStyleDark: return [UIColor blueColor];
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
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor grayColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)translusentBackground {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor colorWithWhite:0.0 alpha:0.67];
        case AppThemeStyleDark: return [UIColor colorWithWhite:1.0 alpha:0.33];
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

+ (UIColor *)sectionHeaderTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionFooterBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}


+ (UIColor *)sectionFooterTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionHeaderBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textDefaultColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textLightColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor colorWithWhite:0.3 alpha:1.0];
        case AppThemeStyleDark: return [UIColor colorWithWhite:0.7 alpha:1.0];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textMediumColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor colorWithWhite:0.7 alpha:1.0];
        case AppThemeStyleDark: return [UIColor colorWithWhite:0.3 alpha:1.0];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textDarkColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor whiteColor];
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

+ (UIColor *)buttonBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonHighlightedColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewBorderColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewPlaceholderColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewCharTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}


+ (UIColor *)textFieldBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldBorderColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldPlaceholderColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)badgeBackgroundColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor whiteColor];
        case AppThemeStyleDark: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)badgeTextColor {
    switch (THEME_STYLE) {
        case AppThemeStyleLight: return [UIColor blackColor];
        case AppThemeStyleDark: return [UIColor whiteColor];
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

+ (UIFont *)largeBoldTitleFont {
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


@end
