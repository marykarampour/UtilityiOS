//
//  MKUObjectProtocol.h
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2026-03-26.
//  Copyright © 2026 Commodity Forwarders Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUObjectProtocol <NSObject>

@required
+ (NSObject<MKUObjectProtocol> *)objectWithObject:(id)obj;

@end
