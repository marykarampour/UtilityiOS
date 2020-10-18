//
//  ViewControllerTransitionProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VCTRANSITION_RESULT_TYPE) {
    VCTRANSITION_RESULT_TYPE_UNKNOWN,
    VCTRANSITION_RESULT_TYPE_SUCCESS,
    VCTRANSITION_RESULT_TYPE_FAILURE
};


@protocol MKViewControllerTransitionProtocol <NSObject>

@optional
- (void)viewController:(__kindof UIViewController *)viewController didReturnWithResultType:(VCTRANSITION_RESULT_TYPE)resultType object:(id)object;

@end
