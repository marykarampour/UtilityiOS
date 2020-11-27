//
//  KeychainWrapper.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKKeychainWrapper : NSObject

- (void)KWSetObject:(id)object forKey:(id)key;
- (id)KWObjectForKey:(id)key;
- (void)writeToKeychain;

@end
