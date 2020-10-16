//
//  MKArchive.h
//  Powerband Exchange
//
//  Created by Maryam Karampour on 2019-07-25.
//  Copyright © 2019 Powerband Global Dealer Services. All rights reserved.
//

#import "MKModel.h"

@interface MKArchive : MKModel

@property (nonatomic, strong) __kindof MKModel *object;

/** @brief path of file locally saved */
@property (nonatomic, strong, readonly) NSString *path;
/** @brief url of file externally saved, e.g. a location on the web or outside app's container */
@property (nonatomic, strong) NSString *url;
/** @brief if this property is null, a number (max prefix numbers + 1) will be used */
@property (nonatomic, strong) NSString *directoryPrefix;

/** @brief the key should be alphanumeric, fileID is generated as a timestamp-GUID, format of saved filename is key-fileID */
@property (nonatomic, strong) NSDictionary <NSString *, NSData *> *data;

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithObject:(__kindof MKModel *)object;

/** @brief saves both the object and the array of data */
- (void)saveToFile;
- (void)deleteDoc;
- (BOOL)createDataPath;

/** @brief saves one item in data array */
    //- (void)saveData:(NSData *)data path:(NSString *)path;

/** @brief saves all items in data array */
- (void)saveData;
- (NSString *)nextDataPath;
- (NSData *)dataForKey:(NSString *)key;
- (NSString *)pathForDataKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(nonnull NSString *)key;
- (NSString *)fileIDForKey:(NSString *)key;

@end

@interface MKArchiveDataBase : NSObject

/** @brief the name of the class is also used as the directory name */
+ (NSMutableArray <__kindof MKArchive *> *)loadDataOfClass:(Class)docClass;
+ (NSString *)nextDataPathOfClass:(Class)docClass prefix:(NSString *)prefix;
+ (void)deleteAllDocs;

@end
