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

typedef NS_ENUM(NSUInteger, DocumentPickerType) {
    DocumentPickerType_Picker,
    DocumentPickerType_Menu,
    DocumentPickerType_MenuCamera,
    DocumentPickerType_Browser,
};

@protocol MKDocumentPickerProtocol <NSObject>

@optional
- (void)documentPickerReturnedData:(NSData *)data;

@end

@interface MKDocumentPickerController : NSObject  <UIDocumentBrowserViewControllerDelegate, UIImagePickerControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate>


@property (nonatomic, weak) __kindof UIViewController<MKDocumentPickerProtocol> *viewController;
@property (nonatomic, assign) DocumentPickerType type;

- (void)showDocumentPicker;

@end
