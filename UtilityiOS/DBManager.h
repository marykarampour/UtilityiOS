//
//  DBManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-24.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLConstants.h"

@interface DBManager : NSObject

- (instancetype)initWithDBFile:(NSString *)name;
- (void)createDB:(NSDictionary *)tables;
- (void)dropDB;
- (void)createTable:(NSString *)tableName withStatement:(NSString *)statement;
- (void)clearTable:(NSString *)tableName;

- (NSArray *)loadData:(NSString *)query;
- (BOOL)executeQuery:(NSString *)query;
- (NSArray *)loadData:(NSString *)query withParameters:(NSDictionary *)parameters;
- (BOOL)executeQuery:(NSString *)query withParameters:(NSDictionary *)parameters;

- (BOOL)columnExists:(NSString *)column;

@end
