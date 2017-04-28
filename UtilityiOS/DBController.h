//
//  DBORM.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface DBController : NSObject

@property (nonatomic, strong) DBManager *dbManager;

+ (DBController *)instance;

- (BOOL)dbVersionIsUpToDate;
- (void)initializeDB;
- (void)resetDB;
- (void)updateDB;

@end
