//
//  MKCoreDataManager.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-19.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCoreDataManager.h"
#import "NSObject+Utility.h"

@implementation MKCoreDataManager

@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize writerManagedObjectContext = _writerManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (instancetype)initWithModelPath:(NSString *)modelPath storePath:(NSString *)storePath {
    if (self = [super init]) {
        _modelPath = modelPath;
        _storePath = storePath;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminatingSave:) name:[Constants NotificationName_App_Terminated] object:nil];
    }
    return self;
}

- (void)terminatingSave:(NSNotification *)object {
    [self saveContext:self.writerManagedObjectContext completion:nil];
}
//TODO: in applicationWillTerminate how about the writer save?
- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *error;
    if (context) {
        if ([context hasChanges] && ![context save:&error]) {
            NSAssert(error, error.localizedDescription);
            return;
        }
    }
}

- (void)saveContext:(NSManagedObjectContext *)context completion:(void (^)(void))completion {
    [context performBlock:^{
        [self saveContext:context];
        if (completion) completion();
    }];
}

- (NSManagedObjectContext *)temporaryContext {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    moc.parentContext = self.mainManagedObjectContext;
    return moc;
}

- (void)saveItems:(NSArray<__kindof MKModel *> *)items ofClass:(Class)itemClass entityName:(NSString *)entityName completion:(void (^)(NSError *))completion {
    
    StringArr *propertyNames = [NSObject propertyNamesOfClass:itemClass];
    __block NSError *error;
    NSManagedObjectContext *context = [self temporaryContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];

    [context performBlock:^{
        for (MKModel *item in items) {
            NSUInteger count = [self.mainManagedObjectContext countForFetchRequest:fetchRequest error:&error];
//            if (count == 0) {
                NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
                for (NSString *key in propertyNames) {
                    [newItem setPrimitiveValue:[item valueForKey:key] forKey:key];
                }
//            }
        }
        [self saveContext:context];
        [self saveContext:self.mainManagedObjectContext completion:^{
            [self saveContext:self.writerManagedObjectContext completion:^{
                if (completion) completion(error);
            }];
        }];
    }];
}

- (void)loadItemsOfClass:(Class)itemClass predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor * _Nullable)sortDescriptor entityName:(NSString *)entityName completion:(void (^)(NSArray *, NSError *))completion {
    
    [self.mainManagedObjectContext performBlock:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
        if (predicate) {
            [fetchRequest setPredicate:predicate];
        }
        if (sortDescriptor) {
            fetchRequest.sortDescriptors = @[sortDescriptor];
        }
        
        NSError *error;
        NSArray *result = [self.mainManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSMutableArray <MKModel *> *arr = [[NSMutableArray alloc] init];
        
        StringArr *propertyNames = [NSObject propertyNamesOfClass:itemClass];
        
        for (NSManagedObject *object in result) {
            id item = [[itemClass alloc] init];
            for (NSString * name in propertyNames) {
                if ([object respondsToSelector:NSSelectorFromString(name)]) {
                    [item setValue:[object valueForKey:name] forKey:name];
                }
            }
            [arr addObject:item];
        }
        if (error) {
            DEBUGLOG(@"%@", error.localizedDescription);
        }
        completion(arr, error);
    }];
}

- (void)loadItemsOfClass:(Class)itemClass inInterval:(__kindof MKInterval *)interval dateKey:(NSString *)dateKey entityName:(NSString *)entityName ascending:(BOOL)ascending completion:(void (^)(NSArray *, NSError *))completion {
    NSPredicate *predicate = interval ? [NSPredicate predicateWithFormat:@"((%K >= %@) AND (%K <= %@))", dateKey, [NSDate dateWithTimeIntervalSince1970:interval.start.integerValue], dateKey, [NSDate dateWithTimeIntervalSince1970:interval.end.integerValue]] : nil;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:dateKey ascending:ascending];

    [self loadItemsOfClass:itemClass predicate:predicate sortDescriptor:sortDescriptor entityName:entityName completion:completion];
}

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (_mainManagedObjectContext) {
        return _mainManagedObjectContext;
    }
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainManagedObjectContext.parentContext = [self writerManagedObjectContext];
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)writerManagedObjectContext {
    if (_writerManagedObjectContext) {
        return _writerManagedObjectContext;
    }
    if ([self persistentStoreCoordinator]) {
        _writerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_writerManagedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        //TODO: could be set
        _writerManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _writerManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelPath withExtension:@"momd"];
    DEBUGLOG(@"Core data model path: %@", modelURL.description);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[Constants appDocumentsDirectory] URLByAppendingPathComponent:self.storePath];
    DEBUGLOG(@"Core data store path: %@", storeURL.description);
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSAssert(error, error.localizedDescription);
        return nil;
    }
    return _persistentStoreCoordinator;
}

@end
