//
//  NetworkManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NetworkManager.h"


const NSInteger REQUEST_TIMEOUT = 60;
static NSArray *selectors;
typedef AFHTTPSessionManager *(* operator)(id manager, SEL cmd, id url, id parameters, id success, id failure);

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

+ (instancetype)instance {
    
    static NetworkManager *instanceM = nil;
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^{
        instanceM = [[NetworkManager alloc] init];
    });
    return instanceM;
}

+ (void)initialize {
    if (!selectors) {
        selectors = @[[NSValue valueWithPointer:@selector(GET:parameters:success:failure:)],
                      [NSValue valueWithPointer:@selector(POST:parameters:success:failure:)],
                      [NSValue valueWithPointer:@selector(PUT:parameters:success:failure:)],
                      [NSValue valueWithPointer:@selector(DELETE:parameters:success:failure:)],
                      [NSValue valueWithPointer:@selector(HEAD:parameters:success:failure:)],
                      [NSValue valueWithPointer:@selector(PATCH:parameters:success:failure:)]];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[AppCommon BaseURL]];
        DEBUGLOG(@"Base url: %@", [AppCommon BaseURL]);
        
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        self.manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html;charset=utf-8", nil]];
    }
    return self;
}

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    
    SEL selector = [selectors[type] pointerValue];
    operator requestOperator = (operator)[self.manager methodForSelector:selector];
    
    return requestOperator(self.manager, selector, url, parameters,
                           ^(NSURLSessionDataTask *task, id responseObject) {
                               DEBUGLOG(@"Success Response: %@ - %@", task.response, responseObject);
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                               if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                                  DEBUGLOG(@"Success Response Header: %@", [httpResponse allHeaderFields]);
                               }
                               completion(responseObject, nil);
                           },
                           ^(NSURLSessionDataTask *task, NSError *error) {
                               DEBUGLOG(@"Error Response: %@ - %@", task.response, error.localizedDescription);
                               completion(nil, error);
                           });
    
}

- (void)setHeaders:(NSDictionary *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

@end
