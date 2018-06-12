//
//  MKDocumentPickerController.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuickLook/QuickLook.h>

typedef NS_ENUM(NSUInteger, MKDocumentPickerType) {
    MKDocumentPickerType_Picker,
    MKDocumentPickerType_Menu,
    MKDocumentPickerType_MenuCamera,
    MKDocumentPickerType_Browser,
};

typedef NS_OPTIONS(NSUInteger, MKDocumentType) {
    MKDocumentType_PDF = 1U << 0,
    MKDocumentType_IMAGE = 1U << 1,
    MKDocumentType_JPEG = 1U << 2,
    MKDocumentType_JPEG2000 = 1U << 3,
    MKDocumentType_TIFF = 1U << 4,
    MKDocumentType_PNG = 1U << 5,
    MKDocumentType_TEXT = 1U << 6,
    MKDocumentType_CONTENT = 1U << 7,
    MKDocumentType_DOC = 1U << 8,
    MKDocumentType_COUNT = 1U << 9
};


@protocol MKDocumentPickerProtocol <NSObject>

@optional
- (void)documentPickerReturnedData:(NSData *)data;

@end

@interface MKDocumentPickerController : NSObject  <UIDocumentBrowserViewControllerDelegate, UIImagePickerControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate>


@property (nonatomic, weak) __kindof UIViewController<MKDocumentPickerProtocol> *viewController;
@property (nonatomic, assign) MKDocumentPickerType type;

- (void)setAcceptedDocumentTypes:(MKDocumentType)docType;

- (void)showDocumentPicker;

@end
