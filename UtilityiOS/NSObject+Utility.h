//
//  NSObject+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utility)

- (BOOL)MKIsEqual:(id)object;
- (id)MKCopyWithZone:(NSZone *)zone;

@end
