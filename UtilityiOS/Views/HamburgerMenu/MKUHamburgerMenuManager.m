//
//  MKUHamburgerMenuManager.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUHamburgerMenuManager.h"
#import "UIViewController+Utility.h"
#import "MKUAssets.h"

@interface MKUHamburgerMenuManager ()

@property (nonatomic, strong, readwrite) MKUHamburgerContainerViewController *menuVC;
@property (nonatomic, strong, readwrite) __kindof UIViewController *presentingVC;

@end


@implementation MKUHamburgerMenuManager

+ (MKUHamburgerMenuManager *)instance {
    static MKUHamburgerMenuManager *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[MKUHamburgerMenuManager alloc] init];
    });
    return menu;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (MKUHamburgerContainerViewController *)menuVC {
    if (!_menuVC) {
        _menuVC = [[MKUHamburgerContainerViewController alloc] init];
    }
    return _menuVC;
}

- (void)initializeContainerWithMenu:(__kindof MKUHamburgerViewController *)menuVC {
    self.menuVC = [[MKUHamburgerContainerViewController alloc] initWithMenuVC:menuVC];
}

- (UIBarButtonItem *)barButtonItem {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[MKUAssets systemIconWithName:[MKUAssets Lines_Horizontal_Image_Name] color:[AppTheme barTextColor]] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    return menuButton;
}

- (void)setPresentingViewController:(__kindof UIViewController *)presentingVC {
    self.presentingVC = presentingVC;
    self.menuVC.menuVC.presentingVC = presentingVC;
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
    [self.presentingVC.navigationController presentViewController:self.menuVC animationType:nil timingFunction:kCAAnimationLinear completion:^{
        [self.menuVC updateMenuIsHidden:NO comletion:nil];
    }];
}

- (void)dismissMenuWithCompletion:(void (^)(void))completion {
    [self.menuVC updateMenuIsHidden:YES comletion:^{
        [self.menuVC dismissViewControllerAnimated:NO completion:completion];
    }];
}

@end
