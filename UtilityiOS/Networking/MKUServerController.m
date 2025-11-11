//
//  ServerController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUServerController.h"
#import "NSObject+ProcessModel.h"
#import "MKURESTNetworkManager.h"
#import "MKUSOAPNetworkManager.h"
#import "NSData+Compression.h"
#import "MKUServerEndpoints.h"
#import "MKUModel.h"

@interface MKUServerController ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<MKUServicesProtocol>> *networkManagers;
@property (nonatomic, strong) id<MKUServicesProtocol> authManager;

@end

@implementation MKUServerController

- (instancetype)init {
    if (self = [super init]) {
        self.networkManagers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addManagerWithType:(NSUInteger)type baseURLString:(NSString *)URL isSOAP:(BOOL)isSOAP isAuth:(BOOL)isAuth {
    Class cls = isSOAP ? [MKUSOAPNetworkManager class] : [MKURESTNetworkManager class];
    id<MKUServicesProtocol> manager = [cls managerWithBaseURLString:URL];
    manager.serviceDelegate = self;
    if (manager) {
        [self.networkManagers setObject:manager forKey:@(type)];
        if (isAuth) self.authManager = manager;
    }
}

- (id<MKUServicesProtocol>)managerForType:(NSUInteger)type {
    return [self.networkManagers objectForKey:@(type)];
}

- (void)requestWithServerType:(NSUInteger)serverType endpointPrefix:(NSString *)endpointPrefix service:(NSString *)service action:(NSString *)action type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *,NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion {
    [[self managerForType:serverType] requestWithEndpointPrefix:endpointPrefix service:service action:action type:type parameters:parameters headers:headers completionHandler:completion];
}

#pragma mark - swizzled in category

+ (void)authWithUserID:(__kindof NSObject *)userID password:(NSString *)password completion:(MKUServerResultErrorBlock)completion {
    if (completion) completion(nil, nil);
}

+ (void)logoutUserWithCompletion:(MKUServerResultErrorBlock)completion {
    if (completion) completion(nil, nil);
}

#pragma mark - process

+ (void)processLogin:(id)result forManager:(id<MKUServicesProtocol>)manager headers:(NSDictionary *)headers error:(NSError *)error completionHeader:(void (^)(id, NSError *))completion {
    if (!error && result) {
        NSString *token = [result objectForKey:[self authTokenKey]];
        if (token.length == 0) {
            token = [headers objectForKey:[self authTokenKey]];
        }
        if (token) {
            [manager setHeaders:@{[self tokenKey]:token}];
        }
    }
    if (completion) completion(result, error);
}

+ (void)processLogoutForManager:(id<MKUServicesProtocol>)manager error:(NSError *)error completionHeader:(void (^)(id, NSError *))completion {
    [manager setHeaders:@{[self tokenKey]:@""}];
}

+ (void)processResult:(id)resultObject error:(NSError *)error class:(Class)modelClass key:(NSString *)key completion:(MKUServerResultErrorBlock)completion {
    if (resultObject) {
        if ([resultObject isKindOfClass:[NSDictionary class]]) {
            if (!key) {
                [self processResult:resultObject error:error class:modelClass completion:^(id result, NSError *error) {
                    if (completion) completion(result, error);
                }];
            }
            else {
                id values = resultObject[key];
                if (values) {
                    [self processResult:values error:error class:modelClass completion:^(id result, NSError *error) {
                        if (completion) completion(result, error);
                    }];
                }
                else {
                    if (completion) completion(nil, [self noContent]);
                }
            }
        }
        else if ([resultObject isKindOfClass:[NSArray class]]) {
            [self processResult:resultObject error:error class:modelClass completion:^(id result, NSError *error) {
                if (completion) completion(result, error);
            }];
        }
        else {
            if (completion) completion(nil, [self noContent]);
        }
    }
    else {
        if (completion) completion(nil, error);
    }
}

#pragma mark - headers

- (void)setHeaders:(NSDictionary *)headers serverType:(NSUInteger)serverType {
    [[self managerForType:serverType] setHeaders:headers];
}

- (void)resetHeaders:(NSArray *)headers serverType:(NSUInteger)serverType {
    [[self managerForType:serverType] resetHeaders:headers];
}

- (void)resetAuthorizationHeaderForServerType:(NSUInteger)serverType {
    [[self managerForType:serverType] resetAuthorizationHeader];
}

+ (NSDictionary *)headersForUsername:(NSString *)username {
    return @{};
}

+ (NSDictionary *)basicAuthHeaders {
    return @{};
}

+ (NSString *)authTokenKey {
    return @"token";
}

+ (NSString *)tokenKey {
    return @"x-token";
}

#pragma mark - errors

+ (NSError *)unauthorizedWithMessage:(NSString *)message {
    return [NSError errorWithDomain:NSNetServicesErrorDomain code:401 userInfo:@{NSLocalizedDescriptionKey:message.length ? message : @"Unauthorized"}];
}

+ (NSError *)noContent {
    return [NSError errorWithDomain:NSNetServicesErrorDomain code:204 userInfo:@{NSLocalizedDescriptionKey:@"No Content"}];
}

@end
