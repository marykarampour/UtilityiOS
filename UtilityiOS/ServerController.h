//
//  ServerController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

/** @brief Apps should subclass this, the methods here are samples */
@interface ServerController : NSObject

- (AFHTTPSessionManager *)auth:(NSString *)username password:(NSString *)password completion:(void (^)(id, NSError *))completion ;

- (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(void (^)(id result, NSError *error))completion;

- (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(void (^)(id result, NSError *error))completion;

@end
