//
//  ServerController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelIncludeHeaders.h"
#import "NetworkManager.h"

@interface ServerController : NSObject

- (AFHTTPSessionManager *)service:(NSDictionary *)params completion:(void (^)(id result, NSError *error))completion;

@end
