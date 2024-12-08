//
//  MKUViewControllerTransitionProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VC_TRANSITION_RESULT_TYPE) {
    VC_TRANSITION_RESULT_TYPE_UNKNOWN,
    VC_TRANSITION_RESULT_TYPE_OK,
    VC_TRANSITION_RESULT_TYPE_CANCEL,
    VC_TRANSITION_RESULT_TYPE_BACK,
    VC_TRANSITION_RESULT_TYPE_FORWARD
};

@protocol MKUViewControllerTransitionDelegate <NSObject>

@optional
- (void)viewController:(__kindof UIViewController *)viewController didReturnWithResultType:(VC_TRANSITION_RESULT_TYPE)resultType object:(id)object;

@end

@protocol MKUViewControllerTransitionProtocol <NSObject>

@required
@property (nonatomic, weak) id<MKUViewControllerTransitionDelegate> transitionDelegate;

@optional
- (void)didSetTransitionDelegate:(id<MKUViewControllerTransitionDelegate>)transitionDelegate;

@end
