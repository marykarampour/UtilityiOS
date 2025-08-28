//
//  MKUViewControllerProtocols.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUViewControllerProtocol <NSObject>

@optional
/** @brief A default init method that takes an int as parameter. Used in menu transitions and search facilities. */
- (instancetype)initWithMKUType:(NSInteger)type;

@end
