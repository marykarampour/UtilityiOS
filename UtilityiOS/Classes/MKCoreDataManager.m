//
//  MKCoreDataManager.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-19.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCoreDataManager.h"
//TODO: if not singlton it should save all contexts in aplicationWillTerminate or it can contain an array of contexts

@implementation MKCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (instancetype)initWithModelPath:(NSString *)modelPath storePath:(NSString *)storePath {
    if (self = [super init]) {
        _modelPath = modelPath;
        _storePath = storePath;
    }
    return self;
}

- (void)saveContext {
    NSError *error;
    if (self.managedObjectContext) {
        if ([self.managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            NSAssert(error, error.localizedDescription);
            return;
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    if ([self persistentStoreCoordinator]) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelPath withExtension:@"momd"];
    DEBUGLOG(@"%@", modelURL.description);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[Constants appDocumentsDirectory] URLByAppendingPathComponent:self.storePath];
    DEBUGLOG(@"%@", storeURL.description);
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSAssert(error, error.localizedDescription);
        return nil;
    }
    return _persistentStoreCoordinator;
}

@end
