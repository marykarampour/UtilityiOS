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

typedef NS_OPTIONS(NSUInteger, MKU_IMAGE_PICKER_TYPE) {
    MKU_IMAGE_PICKER_TYPE_CAMERA  = 1 << 0,
    MKU_IMAGE_PICKER_TYPE_PHOTOS  = 1 << 1,
    MKU_IMAGE_PICKER_TYPE_VISION  = 1 << 2,
    MKU_IMAGE_PICKER_TYPE_DOCS    = 1 << 3,
    MKU_IMAGE_PICKER_TYPE_BROWSER = 1 << 4
};

@protocol MKUDocumentPickerProtocol <NSObject>

@optional
- (void)presentDocumentPickerWithImage:(NSData *)data;

@end

@protocol MKUDocumentPickerDelegate <NSObject>

@optional
- (void)documentPickerPickedData:(NSData *)data;
- (void)documentPickerPickedImage:(UIImage *)image;
- (void)documentPickerCanDeleteData:(NSData *)data;

@end

@interface MKUDocumentPickerController : NSObject <MKUDocumentPickerProtocol>

@property (nonatomic, assign) BOOL usesVision;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/** @brief If allowsMultipleSelection == YES it will be used to set selectionLimit in the photo picker. Default is 1.*/
@property (nonatomic, assign) NSUInteger maxMultipleSelection;

/** @brief Default is MKU_IMAGE_PICKER_TYPE_CAMERA */
- (instancetype)initWithViewController:(UIViewController <MKUDocumentPickerDelegate> *)viewController;
/** @brief Default is MKU_IMAGE_PICKER_TYPE_CAMERA */
- (instancetype)initWithViewController:(UIViewController *)viewController delegate:(id<MKUDocumentPickerDelegate>)delegate;

- (instancetype)initWithViewController:(UIViewController <MKUDocumentPickerDelegate> *)viewController type:(MKU_IMAGE_PICKER_TYPE)type;
- (instancetype)initWithViewController:(UIViewController *)viewController delegate:(id<MKUDocumentPickerDelegate>)delegate type:(MKU_IMAGE_PICKER_TYPE)type;

- (void)presentDocumentPicker;
- (void)setAcceptedDocumentTypes:(MKU_DOCUMENT_TYPE)docType;

@end
