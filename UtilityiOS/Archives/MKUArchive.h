//
//  MKUArchive.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2019-07-25.
//  Copyright © 2025 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"

@interface MKUArchive : MKUModel

@property (nonatomic, strong) __kindof MKUModel *object;

/** @brief Path of file locally saved */
@property (nonatomic, strong, readonly) NSString *path;
/** @brief url of file externally saved, e.g. a location on the web or outside app's container */
@property (nonatomic, strong) NSString *url;
/** @brief If this property is null, a number (max prefix numbers + 1) will be used */
@property (nonatomic, strong) NSString *directoryPrefix;

/** @brief Key should be alphanumeric, fileID is generated as a timestamp-GUID, format of saved filename is key-fileID */
@property (nonatomic, strong) NSDictionary <NSString *, NSData *> *data;

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithObject:(__kindof MKUModel *)object;

/** @brief Saves both the object and the array of data */
- (void)saveToFile;

/** @brief Deletes the doc from storage, the object will be unaffected. **/
- (void)deleteDoc;
- (BOOL)createDataPath;

/** @brief Saves one item in data array */
    //- (void)saveData:(NSData *)data path:(NSString *)path;

/** @brief Saves all items in data array */
- (void)saveData;
- (NSString *)nextDataPath;
- (NSData *)dataForKey:(NSString *)key;
- (NSString *)pathForDataKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(nonnull NSString *)key;
- (NSString *)fileIDForKey:(NSString *)key;

@end

@interface MKUArchiveDataBase : NSObject

/** @brief Name of the class is also used as the directory name */
+ (NSMutableArray <__kindof MKUArchive *> *)loadDataOfClass:(Class)docClass;
+ (NSString *)nextDataPathOfClass:(Class)docClass prefix:(NSString *)prefix;
+ (void)deleteAllDocs;

@end
