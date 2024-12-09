//
//  KeyboardAdjuster.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-29.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

__deprecated
@interface KeyboardAdjuster : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)registerObserver;
- (void)removeObserver;
- (void)setReferenceView:(UIView *)view;

@end
