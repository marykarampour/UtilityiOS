//
//  MKUDocumentPickerController.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuickLook/QuickLook.h>
#import "NSData+Utility.h"

@protocol MKUDocumentPickerProtocol <NSObject>

@optional
- (void)presentDocumentPickerWithImage:(NSData *)data;

@end

@protocol MKUDocumentPickerDelegate <NSObject>

@optional
- (void)documentPickerPickedData:(NSData *)data;
- (void)documentPickerPickedImage:(UIImage *)image;
- (void)documentPickerCanDeleteData:(NSData *)data;
- (void)documentPickerDidExportData:(NSData *)data withError:(NSError *)error;
- (void)documentPickerDidExportImage:(UIImage *)image withError:(NSError *)error;
- (void)documentPickerDidFailWithError:(NSError *)error;
- (void)documentPickerDidCancel;

@end

@interface MKUDocumentPickerController : NSObject <MKUDocumentPickerProtocol>

@property (nonatomic, assign) BOOL usesVision;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/** @brief If allowsMultipleSelection == YES it will be used to set selectionLimit in the photo picker. Default is [Constants Image_Picker_Max_Selection].*/
@property (nonatomic, assign) NSUInteger maxMultipleSelection;

/** @brief Default is MKU_IMAGE_PICKER_TYPE_CAMERA */
- (instancetype)initWithViewController:(UIViewController <MKUDocumentPickerDelegate> *)viewController;
/** @brief Default is MKU_IMAGE_PICKER_TYPE_CAMERA */
- (instancetype)initWithViewController:(UIViewController *)viewController delegate:(id<MKUDocumentPickerDelegate>)delegate;

- (instancetype)initWithViewController:(UIViewController <MKUDocumentPickerDelegate> *)viewController type:(MKU_IMAGE_PICKER_TYPE)type;
- (instancetype)initWithViewController:(UIViewController *)viewController delegate:(id<MKUDocumentPickerDelegate>)delegate type:(MKU_IMAGE_PICKER_TYPE)type;

- (void)presentDocumentPicker;
/** @brief Only applicable to MKU_IMAGE_PICKER_TYPE_DOCS_EXPORT  and  MKU_IMAGE_PICKER_TYPE_PHOTOS_EXPORT */
- (void)presentDocumentExportWithType:(MKU_IMAGE_PICKER_TYPE)type data:(NSArray<NSData *> *)data;
- (void)setAcceptedDocumentTypes:(MKU_DOCUMENT_TYPE)docType;

@end
