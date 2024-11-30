//
//  KeychainWrapper+User.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "MKUKeychainWrapper.h"

@interface MKUKeychainWrapper (User)

- (void)setUsername:(NSString *)username;
- (void)setPassword:(NSString *)password;
- (NSString *)username;
- (NSString *)password;

@end
