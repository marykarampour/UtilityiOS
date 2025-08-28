//
//  MKUDocumentPickerController.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUDocumentPickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIViewController+Navigation.h"
#import <AVFoundation/AVFoundation.h>
#import <VisionKit/VisionKit.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Editing.h"
#import "NSArray+Utility.h"
#import "NSObject+Alert.h"
#import "MKUSpinner.h"

static NSDictionary <NSNumber *, UTType *> *supportedDocTypes;

@interface MKUDocumentPickerController () <UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, VNDocumentCameraViewControllerDelegate, PHPickerViewControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id<MKUDocumentPickerDelegate> delegate;
@property (nonatomic, strong) NSArray <UTType *> *acceptedDocTypes;
@property (nonatomic, assign) MKU_IMAGE_PICKER_TYPE type;

- (void)showCamera;
- (void)showPhotos;
- (void)showDocs;
- (void)showVision;
- (NSString *)pickerTitleForType:(MKU_IMAGE_PICKER_TYPE)type;
- (SEL)pickerActionForType:(MKU_IMAGE_PICKER_TYPE)type;
- (void)performPresentDocumentPickerType:(MKU_IMAGE_PICKER_TYPE)type withImage:(NSData *)data;
- (void)performPresentDocumentPickerAction:(SEL)action title:(NSString *)title withImage:(NSData *)data;
- (ActionObject *)deleteActionWithImage:(NSData *)data;

@end

#pragma mark - subclasses

@interface MKUDocumentPickerController_Camera : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Camera

- (instancetype)init {
    return [super init];
}

@end


@interface MKUDocumentPickerController_Photos_Import : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Photos_Import

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    [self performPresentDocumentPickerType:MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT withImage:data];
}

@end


@interface MKUDocumentPickerController_Photos_Export : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Photos_Export

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    [self presentDocumentExportWithType:MKU_IMAGE_PICKER_TYPE_PHOTOS_EXPORT data:[NSArray arrayWithNullableObject:data]];
}

@end


@interface MKUDocumentPickerController_Docs_Import : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Docs_Import

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    [self performPresentDocumentPickerType:MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT withImage:data];
}

@end


@interface MKUDocumentPickerController_Docs_Export : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Docs_Export

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    [self presentDocumentExportWithType:MKU_IMAGE_PICKER_TYPE_DOCS_EXPORT data:[NSArray arrayWithNullableObject:data]];
}

@end


@interface MKUDocumentPickerController_Vision : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Vision

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    [self performPresentDocumentPickerType:MKU_IMAGE_PICKER_TYPE_VISION withImage:data];
}

@end


@interface MKUDocumentPickerController_Camera_Docs : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Camera_Docs

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    NSArray<ActionObject *> *arr = [NSArray arrayWithObjects:
                                    [ActionObject actionWithTitle:[Constants Camera_STR] target:self action:@selector(showCamera)],
                                    [ActionObject actionWithTitle:[Constants Document_Picker_STR] target:self action:@selector(showDocs)],
                                    [self deleteActionWithImage:data], nil];
    [NSObject actionSheetWithTitle:nil message:nil alertActions:arr];
}

@end


@interface MKUDocumentPickerController_Photos_Docs : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Photos_Docs

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    NSArray<ActionObject *> *arr = [NSArray arrayWithObjects:
                                    [ActionObject actionWithTitle:[Constants Photo_Library_STR] target:self action:@selector(showPhotos)],
                                    [ActionObject actionWithTitle:[Constants Document_Picker_STR] target:self action:@selector(showDocs)],
                                    [self deleteActionWithImage:data], nil];
    [NSObject actionSheetWithTitle:nil message:nil alertActions:arr];
}

@end


@interface MKUDocumentPickerController_Photos_Camera : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Photos_Camera

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    NSArray<ActionObject *> *arr = [NSArray arrayWithObjects:
                                    [ActionObject actionWithTitle:[Constants Camera_STR] target:self action:@selector(showCamera)],
                                    [ActionObject actionWithTitle:[Constants Photo_Library_STR] target:self action:@selector(showPhotos)],
                                    [self deleteActionWithImage:data], nil];
    [NSObject actionSheetWithTitle:nil message:nil alertActions:arr];
}

@end


@interface MKUDocumentPickerController_Photos_Camera_Docs : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Photos_Camera_Docs

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    NSArray<ActionObject *> *arr = [NSArray arrayWithObjects:
                                    [ActionObject actionWithTitle:[Constants Camera_STR] target:self action:@selector(showCamera)],
                                    [ActionObject actionWithTitle:[Constants Photo_Library_STR] target:self action:@selector(showPhotos)],
                                    [ActionObject actionWithTitle:[Constants Document_Picker_STR] target:self action:@selector(showDocs)],
                                    [self deleteActionWithImage:data], nil];
    [NSObject actionSheetWithTitle:nil message:nil alertActions:arr];
}

@end


@interface MKUDocumentPickerController_Photos_Camera_Vision_Docs : MKUDocumentPickerController

@end

@implementation MKUDocumentPickerController_Photos_Camera_Vision_Docs

- (instancetype)init {
    return [super init];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    NSArray<ActionObject *> *arr = [NSArray arrayWithObjects:
                                    [ActionObject actionWithTitle:[Constants Camera_STR] target:self action:@selector(showCamera)],
                                    [ActionObject actionWithTitle:[Constants Photo_Library_STR] target:self action:@selector(showPhotos)],
                                    [ActionObject actionWithTitle:[Constants Document_Detection_STR] target:self action:@selector(showVision)],
                                    [ActionObject actionWithTitle:[Constants Document_Picker_STR] target:self action:@selector(showDocs)],
                                    [self deleteActionWithImage:data], nil];
    [NSObject actionSheetWithTitle:nil message:nil alertActions:arr];
}

@end

#pragma mark - base class

@implementation MKUDocumentPickerController

+ (void)initialize {
    if (!supportedDocTypes) {
        supportedDocTypes =
            @{@(MKU_DOCUMENT_TYPE_PDF)  : UTTypePDF,
              @(MKU_DOCUMENT_TYPE_GIF)  : UTTypeGIF,
              @(MKU_DOCUMENT_TYPE_JPEG) : UTTypeJPEG,
              @(MKU_DOCUMENT_TYPE_TIFF) : UTTypeTIFF,
              @(MKU_DOCUMENT_TYPE_PNG)  : UTTypePNG,
              @(MKU_DOCUMENT_TYPE_RTF)  : UTTypeText,
              @(MKU_DOCUMENT_TYPE_TEXT) : UTTypePlainText,
              @(MKU_DOCUMENT_TYPE_DATA) : UTTypeData,
              @(MKU_DOCUMENT_TYPE_DOC)  : [UTType typeWithIdentifier:@"com.microsoft.word.doc"]};
    }
}

- (void)setAcceptedDocumentTypes:(MKU_DOCUMENT_TYPE)docType {
    NSMutableArray *types = [[NSMutableArray alloc] init];
    NSUInteger type = MKU_DOCUMENT_TYPE_PDF;
    for (unsigned int i=1; type < MKU_DOCUMENT_TYPE_COUNT; type = 1U << i, i++) {
        if (docType & type) {
            UTType *doc = [self docTypeNameForType:type];
            if (doc) {
                [types addObject:doc];
            }
        }
    }
    self.acceptedDocTypes = types;
}

- (UTType *)docTypeNameForType:(MKU_DOCUMENT_TYPE)type {
    return [supportedDocTypes objectForKey:@(type)];
}

- (instancetype)initWithViewController:(UIViewController<MKUDocumentPickerDelegate> *)viewController {
    return [self initWithViewController:viewController delegate:viewController type:MKU_IMAGE_PICKER_TYPE_CAMERA];
}

- (instancetype)initWithViewController:(UIViewController *)viewController delegate:(id<MKUDocumentPickerDelegate>)delegate {
    return [self initWithViewController:viewController delegate:delegate type:MKU_IMAGE_PICKER_TYPE_CAMERA];
}

- (instancetype)initWithViewController:(UIViewController<MKUDocumentPickerDelegate> *)viewController type:(MKU_IMAGE_PICKER_TYPE)type {
    return [self initWithViewController:viewController delegate:viewController type:type];
}

- (instancetype)initWithViewController:(UIViewController *)viewController delegate:(id<MKUDocumentPickerDelegate>)delegate type:(MKU_IMAGE_PICKER_TYPE)type {
    
    if (type & MKU_IMAGE_PICKER_TYPE_CAMERA && type & MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT && type & MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT && type & MKU_IMAGE_PICKER_TYPE_VISION)
        self = [[MKUDocumentPickerController_Photos_Camera_Vision_Docs alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_CAMERA && type & MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT && type & MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT)
        self = [[MKUDocumentPickerController_Photos_Camera_Docs alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_CAMERA && type & MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT)
        self = [[MKUDocumentPickerController_Photos_Camera alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_CAMERA && type & MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT)
        self = [[MKUDocumentPickerController_Camera_Docs alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT && type & MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT)
        self = [[MKUDocumentPickerController_Photos_Docs alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT)
        self = [[MKUDocumentPickerController_Photos_Import alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_PHOTOS_EXPORT)
        self = [[MKUDocumentPickerController_Photos_Export alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT)
        self = [[MKUDocumentPickerController_Docs_Import alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_DOCS_EXPORT)
        self = [[MKUDocumentPickerController_Docs_Export alloc] init];
    
    else if (type & MKU_IMAGE_PICKER_TYPE_VISION)
        self = [[MKUDocumentPickerController_Vision alloc] init];
    
    else
        self = [[MKUDocumentPickerController_Camera alloc] init];
    
    self.type = type;
    self.viewController = viewController;
    self.delegate = delegate;
    self.maxMultipleSelection = [Constants Image_Picker_Max_Selection];
    
    [self checkImagePickerAuthorization];
    
    return self;
}

- (void)checkImagePickerAuthorization {
    AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (auth == AVAuthorizationStatusDenied) {
        [self.viewController OKAlertWithTitle:[Constants Camera_Disabled_Error_Title_STR] message:[Constants Camera_Disabled_Error_Message_STR]];
    }
}

- (void)showCamera {
    [self presentPickerWithType:MKU_IMAGE_PICKER_TYPE_CAMERA];
}

- (void)showPhotos {
    [self presentPickerWithType:MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT];
}

- (void)showDocs {
    [self presentPickerWithType:MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT];
}

- (void)showVision {
    [self presentPickerWithType:MKU_IMAGE_PICKER_TYPE_VISION];
}

- (void)presentPickerWithType:(MKU_IMAGE_PICKER_TYPE)type data:(NSArray<NSData *> *)data {
    
    if (type == MKU_IMAGE_PICKER_TYPE_CAMERA && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
#if !TARGET_IPHONE_SIMULATOR
        [self.viewController OKAlertWithTitle:kErrorString message:[Constants No_Camera_Error_Message_STR]];
        return;
#endif
    }
    
    UIViewController *vc;
    
    if (type == MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT) {
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:self.acceptedDocTypes];
        picker.delegate = self;
        picker.allowsMultipleSelection = self.allowsMultipleSelection;
        vc = picker;
    }
    else if (type == MKU_IMAGE_PICKER_TYPE_DOCS_EXPORT) {
        if (data.count == 0) return;

        NSMutableArray<NSURL *> *URLs = [[NSMutableArray alloc] init];
        
        for (NSData *obj in data) {
            NSURL *URL = [Constants writeToTempDirectoryWithFileName:[Constants Untitled_STR] directory:nil data:obj];
            if (URL) [URLs addObject:URL];
        }
        
        if (URLs.count == 0) return;
        
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForExportingURLs:URLs];
        picker.delegate = self;
        picker.allowsMultipleSelection = self.allowsMultipleSelection;
        vc = picker;
    }
    else if (type == MKU_IMAGE_PICKER_TYPE_PHOTOS_EXPORT) {
        if (data.count == 0) return;
        
        [data enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *im = [UIImage imageWithData:obj];
            id target;
            if (im) {
                if (idx == data.count - 1)
                    target = self;
                UIImageWriteToSavedPhotosAlbum(im, target, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
        
        return;
    }
    else if (TARGET_IPHONE_SIMULATOR || type == MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT) {
        vc = [self photoPickerController];
    }
    else if (type == MKU_IMAGE_PICKER_TYPE_VISION) {
        VNDocumentCameraViewController *vision = [[VNDocumentCameraViewController alloc] init];
        vision.delegate = self;
        vc = vision;
    }
    else {
        vc = [self imagePickerControllerWithType:MKU_IMAGE_PICKER_TYPE_CAMERA];
    }
    
    [self.viewController updateNavBarMode:MKU_THEME_STYLE_LIGHT];
    [self.viewController presentViewController:vc animationType:nil timingFunction:nil completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self dispatchDelegateWithExportedImage:image error:error];
}

- (void)presentPickerWithType:(MKU_IMAGE_PICKER_TYPE)type {
    [self presentPickerWithType:type data:nil];
}

- (UIImagePickerController *)imagePickerControllerWithType:(MKU_IMAGE_PICKER_TYPE)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = type == MKU_IMAGE_PICKER_TYPE_CAMERA ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    return picker;
}

- (UIViewController *)photoPickerController {
    if (@available(iOS 15.0, *)) {
        
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] initWithPhotoLibrary:[PHPhotoLibrary sharedPhotoLibrary]];
        config.selectionLimit = self.allowsMultipleSelection ? self.maxMultipleSelection : 1;
        
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
        picker.delegate = self;
        return picker;
    }
    else {
        return [self imagePickerControllerWithType:MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT];
    }
}

- (void)presentDocumentExportWithType:(MKU_IMAGE_PICKER_TYPE)type data:(NSArray<NSData *> *)data {
    [self presentPickerWithType:type data:data];
}

- (void)presentDocumentPicker {
    [self presentDocumentPickerWithImage:nil];
}

- (void)presentDocumentPickerWithImage:(NSData *)data {
    [self performPresentDocumentPickerType:MKU_IMAGE_PICKER_TYPE_CAMERA withImage:data];
}

- (void)performPresentDocumentPickerType:(MKU_IMAGE_PICKER_TYPE)type withImage:(NSData *)data {
    [self performPresentDocumentPickerAction:[self pickerActionForType:type] title:[self pickerTitleForType:type] withImage:data];
}

- (void)performPresentDocumentPickerAction:(SEL)action title:(NSString *)title withImage:(NSData *)data {
    if (data.length) {
        NSArray<ActionObject *> *arr = @[[ActionObject actionWithTitle:[Constants Delete_STR] target:self action:@selector(presentDeleteAlertWithImage:) object:data],
                                         [ActionObject actionWithTitle:title target:self action:action object:data]];
        [NSObject actionSheetWithTitle:nil message:nil alertActions:arr];
    }
    else if ([self respondsToSelector:action]) {
        [self performSelectorOnMainThread:action withObject:nil waitUntilDone:YES];
    }
}

- (void)presentDeleteAlertWithImage:(NSData *)data {
    [NSObject actionAlertWithTitle:[Constants Delete_Prompt_Message_STR] message:nil alertActionHandler:^{
        if ([self.delegate respondsToSelector:@selector(documentPickerCanDeleteData:)]) {
            [self.delegate performSelector:@selector(documentPickerCanDeleteData:) withObject:data];
        }
    }];
}

- (NSString *)pickerTitleForType:(MKU_IMAGE_PICKER_TYPE)type {
    switch (type) {
        case MKU_IMAGE_PICKER_TYPE_CAMERA:        return [Constants Camera_STR];
        case MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT: return [Constants Photo_Library_STR];
        case MKU_IMAGE_PICKER_TYPE_VISION:        return [Constants Document_Detection_STR];
        case MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT:   return [Constants Document_Picker_STR];
        default:                                  return nil;
    }
}

- (SEL)pickerActionForType:(MKU_IMAGE_PICKER_TYPE)type {
    switch (type) {
        case MKU_IMAGE_PICKER_TYPE_CAMERA:        return @selector(showCamera);
        case MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT: return @selector(showPhotos);
        case MKU_IMAGE_PICKER_TYPE_VISION:        return @selector(showVision);
        case MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT:   return @selector(showDocs);
        default:                                  return nil;
    }
}

- (ActionObject *)deleteActionWithImage:(NSData *)data {
    if (data.length == 0) return nil;
    return [ActionObject actionWithTitle:[Constants Delete_STR] target:self action:@selector(presentDeleteAlertWithImage:) object:data];
}

#pragma mark - picker protocols

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewController:picker];
    [MKUSpinner show];
    [UIImage shrinkImage:info[UIImagePickerControllerOriginalImage] completion:^(NSData *data) {
        [MKUSpinner hide];
        [self dispatchDelegateWithData:data];
    }];
}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    [self dismissViewController:picker];
    for (PHPickerResult *obj in results) {
        [obj.itemProvider loadDataRepresentationForTypeIdentifier:@"public.image" completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dispatchDelegateWithData:data];
            });
        }];
    }
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentURLs:(NSArray<NSURL *> *)documentURLs {
    [self dismissViewController:controller];
    for (NSURL *url in documentURLs) {
        [self dispatchDelegateWithData:[self dataFromURL:url]];
    }
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [self dismissViewController:controller];
    [self dispatchDelegateWithData:[self dataFromURL:url]];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didImportDocumentAtURL:(NSURL *)sourceURL toDestinationURL:(NSURL *)destinationURL {
    [self dismissViewController:controller];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    [self dismissViewController:controller];
    for (NSURL *url in urls) {
        NSData *data = [self dataFromURL:url];
        if (self.type & MKU_IMAGE_PICKER_TYPE_DOCS_EXPORT)
            [self dispatchDelegateWithExportedData:data error:nil];
        else
            [self dispatchDelegateWithData:data];
    }
}

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFinishWithScan:(VNDocumentCameraScan *)scan {
    [self dismissViewController:controller];
    for (NSUInteger i=0; i<scan.pageCount; i++) {
        [self dispatchDelegateWithImage:[scan imageOfPageAtIndex:i]];
    }
}

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFailWithError:(NSError *)error {
    [self dismissViewController:controller];
    [self dispatchDelegateDidFailWithError:error];
}

- (void)documentCameraViewControllerDidCancel:(VNDocumentCameraViewController *)controller {
    [self dismissViewController:controller];
    [self dispatchDelegateDidCancel];
}

- (void)dispatchDelegateWithData:(NSData *)data {
    if ([self.delegate respondsToSelector:@selector(documentPickerPickedData:)]) {
        [self.delegate documentPickerPickedData:data];
    }
}

- (void)dispatchDelegateWithImage:(UIImage *)image {
    if ([self.delegate respondsToSelector:@selector(documentPickerPickedImage:)]) {
        [self.delegate documentPickerPickedImage:image];
    }
}

- (void)dispatchDelegateWithExportedData:(NSData *)data error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(documentPickerDidExportData:withError:)]) {
        [self.delegate documentPickerDidExportData:data withError:error];
    }
}

- (void)dispatchDelegateWithExportedImage:(UIImage *)image error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(documentPickerDidExportImage:withError:)]) {
        [self.delegate documentPickerDidExportImage:image withError:error];
    }
}

- (void)dispatchDelegateDidFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(documentPickerDidFailWithError:)]) {
        [self.delegate documentPickerDidFailWithError:error];
    }
}

- (void)dispatchDelegateDidCancel {
    if ([self.delegate respondsToSelector:@selector(documentPickerDidCancel)]) {
        [self.delegate documentPickerDidCancel];
    }
}

- (void)dismissViewController:(UIViewController *)controller {
    [self.viewController updateNavBarMode:MKU_THEME_STYLE_DARK];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSData *)dataFromURL:(NSURL *)url {
    NSData *data = [self accessDataFromURL:url];
    if (data.length == 0) {
        BOOL access = [url startAccessingSecurityScopedResource];
        if (access) {
            data = [self accessDataFromURL:url];
            [url stopAccessingSecurityScopedResource];
        }
    }
    return data;
}

- (NSData *)accessDataFromURL:(NSURL *)url {
    NSError *err;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&err];
    if (err) {
        DEBUGLOG(@"%@", err.localizedDescription);
    }
    return data;
}

- (NSArray<UTType *> *)acceptedDocTypes {
    if (!_acceptedDocTypes) {
        _acceptedDocTypes = [supportedDocTypes allValues];
    }
    return _acceptedDocTypes;
}

@end
