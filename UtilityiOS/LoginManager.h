//
//  LoginManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)performLoginWithUsername:(NSString *)username password:(NSString *)passsword;

@end
