//
//  MKCoreDataManager.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-19.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MKCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readonly) NSString *modelPath;
@property (nonatomic, strong, readonly) NSString *storePath;

- (instancetype)initWithModelPath:(NSString *)modelPath storePath:(NSString *)storePath;

- (void)saveContext;

@end
