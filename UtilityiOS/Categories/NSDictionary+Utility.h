//
//  NSDictionary+Utility.h
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2025-12-23.
//  Copyright © 2025 Commodity Forwarders Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

- (NSDictionary *)removeNull;
- (StringSet *)NullKeys;
- (StringArr *)NullKeysArray;

@end
