//
//  LoginManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "TextFieldController.h"
#import "KeyboardAdjuster.h"

@interface LoginManager : NSObject<TextFieldDelegate>

@property (nonatomic, strong, readonly) KeyboardAdjuster *viewAdjuster;

- (instancetype)initWithViewController:(__kindof LoginViewController *)viewController;
- (void)performLoginWithUsername:(NSString *)username password:(NSString *)passsword;

@end
