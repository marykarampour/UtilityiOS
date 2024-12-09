//
//  MKUViewProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUViewProtocol <NSObject>

@required
+ (NSString *)identifier;
+ (CGFloat)estimatedHeight;

@optional
+ (CGFloat)estimatedHeightForNumberOfLines:(NSInteger)lines;
+ (CGFloat)estimatedHeightForType:(NSUInteger)type;

@end

@protocol MKUControlProtocol <NSObject>

@required
- (void)addTarget:(id)target action:(SEL)action;

@end

