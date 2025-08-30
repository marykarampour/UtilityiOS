//
//  MKUViewObjectProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKUViewObjectProtocol <NSObject>

@required
@property (nonatomic, strong) __kindof UIView *view;

@end

