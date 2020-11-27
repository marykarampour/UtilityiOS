//
//  GraphLib.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-30.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphLib : NSObject

- (NSString *)queryForParameters:(DictStringDictStringStringArr *)paramsDict tableName:(NSString *)tableName;

@end
