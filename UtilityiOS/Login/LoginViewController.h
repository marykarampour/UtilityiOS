//
//  LoginViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+SplitView.h"
#import "MKUStackedViews.h"
#import "MKUTextField.h"

@interface LoginViewController : MKUDetailViewController

@property (nonatomic, strong, readonly) MKUStackedViews<MKUTextField *> *loginView;

- (void)login;

@end
