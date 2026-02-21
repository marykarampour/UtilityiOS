//
//  MKUArrayPropertyProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Maryam Karampour. All rights reserved.
//

#import "MKUViewContentStyleProtocols.h"

@protocol MKUArrayPropertyProtocol <NSObject>

@optional
- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)array;
+ (instancetype)objectWithArray:(NSArray *)array;

@end
