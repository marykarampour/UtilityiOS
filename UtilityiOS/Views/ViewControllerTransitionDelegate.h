//
//  ViewControllerTransitionDelegate.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-16.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ViewControllerTransitionResult) {
    ViewControllerTransitionResult_UNKNOWN,
    ViewControllerTransitionResult_OK,
    ViewControllerTransitionResult_CANCEL,
    ViewControllerTransitionResult_BACK,
    ViewControllerTransitionResult_FORWARD
};

@protocol ViewControllerTransitionDelegate <NSObject>

@optional
- (void)viewController:(UIViewController *)viewController didReturnWithResultType:(ViewControllerTransitionResult)resultType andObject:(id)object;

@end
