//
//  MKUObjectProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUModel.h"

@protocol MKUModelObjectProtocol <NSObject>

@optional
- (void)didSetObject:(__kindof MKUModel *)object;

@property (nonatomic, strong) __kindof MKUModel *object;

@end
