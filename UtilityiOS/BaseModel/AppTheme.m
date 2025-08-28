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
    
    if ([self tabbarBackgroundImage])
        [[UITabBar appearance] setBackgroundImage:[self tabbarBackgroundImage]];
    [[UITabBar appearance] setBackgroundColor:[self tabbarBackgroundColor]];
    [[UITabBar appearance] setBarTintColor:[self tabbarBackgroundColor]];
    [[UITabBar appearance] setTintColor:[self tabbarBarTintColor]];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self tabbarTextColorNormal], NSFontAttributeName:[self tabbarFont]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[self tabbarTextColorSelected], NSFontAttributeName:[self tabbarFont]} forState:UIControlStateSelected];
    
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

    [[UISearchBar appearance] setBackgroundColor:[self searchBarBackgroundColor]];
    [[UISearchBar appearance] setBarTintColor:[self searchBarElementsTintColor]];
    [[UISearchBar appearance] setTintColor:[self searchBarTintColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setBackgroundColor:[self searchBarTextFieldBackgroundColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[self searchBarTextColor]];
    
    NSArray<Class<UIAppearanceContainer>> *arr = @[[UISegmentedControl class]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:arr] setNumberOfLines:0];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:arr] setLineBreakMode:NSLineBreakByWordWrapping];
    
    [[UIPageControl appearance] setPageIndicatorTintColor:[self pageIndicatorTintColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[self currentPageIndicatorTintColor]];
    [[UIPageControl appearance] setHidesForSinglePage:YES];
}

+ (UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDefault;
}

#pragma mark - color

+ (UIColor *)textHighlightColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blueColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blueColor];
        default: return [UIColor whiteColor];
    }
}
     
+ (UIColor *)barTintColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)navBarTintColor {
    return [self barTextColor];
}

+ (UIColor *)stepperTintColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)barTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)barTextDisabledColor {
    return [UIColor grayColor];
}

+ (UIColor *)seperatorColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor grayColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)translusentBackground {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor colorWithWhite:0.0 alpha:0.67];
        case MKU_THEME_STYLE_DARK: return [UIColor colorWithWhite:1.0 alpha:0.33];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)VCBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)VCForgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

#pragma mark - table

+ (UIColor *)sectionHeaderTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [self sectionHeaderLightTextColor];
        case MKU_THEME_STYLE_DARK:  return [self sectionHeaderDarkTextColor];
        default:                    return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionFooterBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [self sectionFooterLightBackgroundColor];
        case MKU_THEME_STYLE_DARK:  return [self sectionFooterDarkBackgroundColor];
        default:                    return [UIColor whiteColor];
    }
}


+ (UIColor *)sectionFooterTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [self sectionFooterLightTextColor];
        case MKU_THEME_STYLE_DARK:  return [self sectionFooterDarkTextColor];
        default:                    return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionHeaderBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [self sectionHeaderLightBackgroundColor];
        case MKU_THEME_STYLE_DARK:  return [self sectionHeaderDarkBackgroundColor];
        default:                    return [UIColor whiteColor];
    }
}

+ (UIColor *)sectionHeaderLightTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)sectionHeaderLightBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)sectionFooterLightTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)sectionFooterLightBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)sectionHeaderDarkTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)sectionHeaderDarkBackgroundColor {
    return [UIColor blackColor];
}

+ (UIColor *)sectionFooterDarkTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)sectionFooterDarkBackgroundColor {
    return [UIColor blackColor];
}

+ (UIColor *)tableFooterBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableCellBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableCellAccessoryViewColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIImage *)tableCellDisclosureIndicatorImage {
    return [UIImage imageNamed:@""];
}

+ (UIColor *)defaultSectionHeaderColor {
    return [UIColor colorWithRed:232/255.0f green:233/255.0f blue:237/255.0f alpha:1.0f];
}

#pragma mark - text

+ (UIColor *)textDefaultColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textLightColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor colorWithWhite:0.3 alpha:1.0];
        case MKU_THEME_STYLE_DARK: return [UIColor colorWithWhite:0.7 alpha:1.0];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textMediumColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor colorWithWhite:0.7 alpha:1.0];
        case MKU_THEME_STYLE_DARK: return [UIColor colorWithWhite:0.3 alpha:1.0];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textDarkColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldLightColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldMediumColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldDarkColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelLightColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelMediumColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)labelDarkColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonHighlightedColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonBorderColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonDisclosureChevronColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)buttonDisclosureBorderColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewBorderColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewPlaceholderColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textViewCharTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}


+ (UIColor *)textFieldBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldBorderColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldPlaceholderColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)textFieldTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)badgeBackgroundColorForState:(MKU_BADGE_VIEW_STATE)state {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)badgeTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)checkboxTintColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)checkboxDisabledColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tabbarTextColorNormal {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tabbarTextColorSelected {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tabbarBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tabbarBarTintColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)pageIndicatorTintColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)currentPageIndicatorTintColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor blackColor];
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

+ (UIFont *)buttonFont {
    return [UIFont boldSystemFontOfSize:16.0];
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

+ (UIFont *)tabbarFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:8.0];
}

+ (UIColor *)tableCellSelectedColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blueColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableHeaderBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blueColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)tableHeaderTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)collectionViewSectionHeaderBackgroundColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blueColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)collectionViewSectionHeaderTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIFont *)collectionViewSectionHeaderFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIColor *)tableFooterTextColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)segmentedControlNormalColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor blackColor];
        case MKU_THEME_STYLE_DARK: return [UIColor whiteColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)segmentedControlSelectedColor {
    switch (APP_THEME_STYLE) {
        case MKU_THEME_STYLE_LIGHT: return [UIColor whiteColor];
        case MKU_THEME_STYLE_DARK: return [UIColor blackColor];
        default: return [UIColor whiteColor];
    }
}

+ (UIColor *)searchBarBackgroundColor {
    return [UIColor whiteColor];
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

+ (UIImage *)tabbarBackgroundImage {
    return nil;
}

@end
