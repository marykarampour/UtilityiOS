//
//  UIControl+Utility.h
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2026-08-14.
//  Copyright © 2026 Commodity Forwarders Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Utility)

- (void)addActionHandelr:(VoidSenderActionHandler)action forControlEvents:(UIControlEvents)controlEvents;

@end
