//
//  MKArchive.m
//  Powerband Exchange
//
//  Created by Maryam Karampour on 2019-07-25.
//  Copyright © 2019 Powerband Global Dealer Services. All rights reserved.
//

#import "MKArchive.h"
#import "NSObject+Utility.h"

@interface MKArchive ()

@property (nonatomic, strong, readwrite) NSString *path;

@end

@implementation MKArchive

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        self.path = path;
    }
    return self;
}

- (instancetype)initWithObject:(__kindof MKModel *)object {
    if (self = [super init]) {
        self.object = object;
    }
    return self;
}

- (NSString *)docsDirectory {
    RaiseExceptionMissingMethodInClass
    return nil;
}

- (BOOL)createDataPath {
    if (!_path) {
        _path = [self nextDataPath];
    }
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:self.path withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        DEBUGLOG(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}

- (NSString *)nextDataPath {
    return [MKArchiveDataBase nextDataPathOfClass:[self class] prefix:self.directoryPrefix];
}

- (MKModel *)object {
    if (_object) return _object;
    
    NSString *dataPath = [self.path stringByAppendingPathComponent:[Constants Archive_Data_Path]];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    
    if (!codedData) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _object = [unarchiver decodeObjectForKey:[Constants Archive_Data_Key]];
    [unarchiver finishDecoding];
    
    return _object;
}

- (void)saveToFile {
    if (!self.object) return;
    
    [self createDataPath];
    
    NSString *dataPath = [self.path stringByAppendingPathComponent:[Constants Archive_Data_Path]];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.object forKey:[Constants Archive_Data_Key]];
    [archiver encodeObject:[self updatedFileIDList] forKey:[Constants Archive_File_ID_Key]];
    
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    
    [self saveData];
}

- (NSDictionary *)updatedFileIDList {
    NSDictionary *savedIds = [self savedFileIDList];
    NSMutableDictionary *Ids = savedIds ? savedIds.mutableCopy : [[NSMutableDictionary alloc] init];
    
    [self.data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
        [Ids setObject:[NSObject timestampGUID] forKey:key];
    }];
    return Ids;
}

- (NSDictionary *)savedFileIDList {
    
    NSString *dataPath = [self.path stringByAppendingPathComponent:[Constants Archive_Data_Path]];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    
    if (!codedData) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NSDictionary *Ids = [unarchiver decodeObjectForKey:[Constants Archive_File_ID_Key]];
    [unarchiver finishDecoding];
    
    return Ids;
}

- (NSString *)fileIDForKey:(NSString *)key {
    return [[self savedFileIDList] objectForKey:key];
}

- (NSData *)dataForKey:(NSString *)key {
    NSData *data = [self.data objectForKey:key];
    if (!data) {
        data = [NSData dataWithContentsOfFile:[self pathForDataKey:key]];
    }
    return data;
}

- (void)deleteDoc {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.path error:&error];
    if (!success) {
        DEBUGLOG(@"Error removing document path: %@", error.localizedDescription);
    }
}

- (void)saveData:(NSData *)data path:(NSString *)path {
    if (!data) return;
    [self createDataPath];
    
    NSString *imagePath = [self.path stringByAppendingPathComponent:path];
    [data writeToFile:imagePath atomically:YES];
    data = nil;
}

- (void)saveData {
    [self.data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
        [self saveData:obj path:key];
    }];
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    NSMutableDictionary *dict = self.data ? self.data.mutableCopy : [[NSMutableDictionary alloc] init];
    [dict setObject:data forKey:key];
    self.data = dict;
}

- (NSString *)pathForDataKey:(NSString *)key {
    return [self.path stringByAppendingPathComponent:key];
}

@end


@implementation MKArchiveDataBase

+ (NSString *)privateDocsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

+ (NSMutableArray<MKArchive *> *)loadDataOfClass:(Class)docClass {
    NSString *documentsDirectory = [MKArchiveDataBase privateDocsDir];
    DEBUGLOG(@"Loading docs from %@", documentsDirectory);
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        DEBUGLOG(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    NSString *dir = NSStringFromClass(docClass);
    for (NSString *file in files) {
        if ([file.pathExtension compare:dir options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            id doc = [[docClass alloc] initWithPath:fullPath];
            if (doc) {
                [retval addObject:doc];
            }
        }
    }
    
    return retval;
}

+ (NSString *)nextDataPathOfClass:(Class)docClass prefix:(NSString *)prefix {
    NSString *documentsDirectory = [MKArchiveDataBase privateDocsDir];
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        DEBUGLOG(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    NSString *dirPrefix = prefix;
    NSString *dir = NSStringFromClass(docClass);
    
    if (!dirPrefix) {
        int maxNumber = 0;
        for (NSString *file in files) {
            if ([file.pathExtension compare:dir options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                NSString *fileName = [file stringByDeletingPathExtension];
                maxNumber = MAX(maxNumber, fileName.intValue);
            }
        }
        dirPrefix = [NSString stringWithFormat:@"%d", maxNumber+1];
    }
    
    NSString *availableName = [NSString stringWithFormat:@"%@.%@", dirPrefix, dir];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}

+ (void)deleteAllDocs {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[MKArchiveDataBase privateDocsDir] error:&error];
    if (!success) {
        DEBUGLOG(@"Error removing document path: %@", error.localizedDescription);
    }
}

@end
