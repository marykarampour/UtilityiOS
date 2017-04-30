//
//  LoginManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "LoginManager.h"
#import "SplitViewManager.h"

@interface LoginManager ()

@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation LoginManager

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
    }
    return self;
}

- (void)performLoginWithUsername:(NSString *)username password:(NSString *)passsword {
    [[SplitViewManager instance].splitViewController animateLogin];
}

@end
