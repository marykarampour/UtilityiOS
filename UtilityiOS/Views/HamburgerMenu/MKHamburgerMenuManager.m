//
//  MKHamburgerMenuManager.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKHamburgerMenuManager.h"
#import "UIViewController+Utility.h"
//#import "MKAssets+KaChing.h" fix in util library
#import "MKAssets.h"

@interface MKHamburgerMenuManager ()

@property (nonatomic, strong, readwrite) MKHamburgerContainerViewController *menuVC;
@property (nonatomic, strong, readwrite) __kindof UIViewController *presentingVC;

@end


@implementation MKHamburgerMenuManager

+ (MKHamburgerMenuManager *)instance {
    static MKHamburgerMenuManager *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[MKHamburgerMenuManager alloc] init];
    });
    return menu;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (MKHamburgerContainerViewController *)menuVC {
    if (!_menuVC) {
        _menuVC = [[MKHamburgerContainerViewController alloc] init];
    }
    return _menuVC;
}

- (UIBarButtonItem *)barButtonItem {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[MKAssets Hamburger_Icon] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    menuButton.tintColor = [AppTheme barTintColor];
    return menuButton;
}

- (void)setPresentingViewController:(__kindof UIViewController *)presentingVC {
    self.presentingVC = presentingVC;
    presentingVC.navigationItem.leftBarButtonItem = [self barButtonItem];
}

- (void)prepareMenuForPresentation {
    self.presentingVC.navigationController.providesPresentationContextTransitionStyle = YES;
    self.presentingVC.navigationController.definesPresentationContext = YES;
    self.menuVC.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (void)menuButtonPressed:(UIBarButtonItem *)sender {
    [self prepareMenuForPresentation];
    [self.presentingVC.navigationController presentViewController:self.menuVC animated:NO completion:^{
        [self.menuVC updateMenuIsHidden:NO comletion:nil];
    }];
}

- (void)dismissMenu {
    [self.menuVC updateMenuIsHidden:YES comletion:^{
        [self.menuVC dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
