//
//  MKURadioButtonViewProtocol.h
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2026-08-10.
//  Copyright © 2026 Commodity Forwarders Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKURadioButtonView;

@protocol MKURadioButtonViewProtocol <NSObject>

@optional
- (void)radioButton:(MKURadioButtonView *)view didSetOn:(BOOL)on;

@end
