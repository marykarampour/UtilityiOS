//
//  MKCoreDataManager.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-19.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MKEventCountObject.h"
#import "MKDateRange.h"

@interface MKCoreDataManager : NSObject
//TODO: use NSFetchedResultsController
@property (strong, nonatomic, readonly) NSManagedObjectContext       *mainManagedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext       *writerManagedObjectContext;

@property (strong, nonatomic, readonly) NSManagedObjectModel         *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readonly) NSString *modelPath;
@property (nonatomic, strong, readonly) NSString *storePath;

- (instancetype)initWithModelPath:(NSString *)modelPath storePath:(NSString *)storePath;

- (void)saveContext:(NSManagedObjectContext *)context;
/** @brief performs save on a perform block */
- (void)saveContext:(NSManagedObjectContext *)context completion:(void (^)(void))completion;
- (NSManagedObjectContext *)temporaryContext;

- (void)saveItems:(NSArray<__kindof MKModel *> *)items ofClass:(Class)itemClass entityName:(NSString *)entityName completion:(void (^)(NSError *error))completion;

- (void)loadItemsOfClass:(Class)itemClass predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor * _Nullable)sortDescriptor entityName:(NSString *)entityName completion:(void (^)(NSArray *result, NSError *error))completion;
/** @brief utility method for fetching items by date range
 @param dateKey name of date property
 */
- (void)loadItemsOfClass:(Class)itemClass inInterval:(__kindof MKInterval *)interval dateKey:(NSString *)dateKey entityName:(NSString *)entityName ascending:(BOOL)ascending completion:(void (^)(NSArray *result, NSError *error))completion;

@end
//TODO: can create a singlton and add this as property, the app sets the property to the app's subclass of this ? 
//TODO: if not singlton it should save all contexts in aplicationWillTerminate or it can contain an array of contexts
