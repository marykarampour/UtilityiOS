//
//  IndexPathProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IndexPathProtocol <NSObject>

@required
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
