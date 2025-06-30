//
//  KeychainWrapper+User.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "MKUKeychainWrapper+User.h"

@implementation MKUKeychainWrapper (User)

- (void)setUsername:(NSString *)username {
    [self KWSetObject:username forKey:(__bridge id)kSecAttrAccount];
}

- (void)setPassword:(NSString *)password {
    [self KWSetObject:password forKey:(__bridge id)kSecValueData];
}

- (NSString *)username {
    return [self KWObjectForKey:(__bridge id)kSecAttrAccount];
}

- (NSString *)password {
    return [self KWObjectForKey:(__bridge id)kSecValueData];
}

@end
