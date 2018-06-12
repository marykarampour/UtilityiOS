//
//  MKDocumentPickerController.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKDocumentPickerController.h"
#import "UIViewController+Alert.h"
#import "MKAssets.h"

static DictNumString *supportedDocTypes;
static StringArr *acceptedDocTypes;

@implementation MKDocumentPickerController

+ (void)initialize {
    if (!supportedDocTypes) {
        supportedDocTypes = @{@(MKDocumentType_PDF):(NSString *)kUTTypePDF,
                              @(MKDocumentType_IMAGE):(NSString *)kUTTypeImage,
                              @(MKDocumentType_JPEG):(NSString *)kUTTypeJPEG,
                              @(MKDocumentType_JPEG2000):(NSString *)kUTTypeJPEG2000,
                              @(MKDocumentType_TIFF):(NSString *)kUTTypeTIFF,
                              @(MKDocumentType_PNG):(NSString *)kUTTypePNG,
                              @(MKDocumentType_TEXT):(NSString *)kUTTypeText,
                              @(MKDocumentType_CONTENT):(NSString *)kUTTypeContent,
                              @(MKDocumentType_DOC): @"com.microsoft.word.doc"};
    }
}

- (void)setAcceptedDocumentTypes:(MKDocumentType)docType {
    MStringArr *types = [[NSMutableArray alloc] init];
    NSUInteger type = MKDocumentType_PDF;
    for (unsigned int i=1; type < MKDocumentType_COUNT; type = 1U << i, i++) {
        if (docType & type) {
            NSString *doc = [self docTypeNameForType:type];
            if (doc) {
                [types addObject:doc];
            }
        }
    }
    acceptedDocTypes = types;
}

- (NSString *)docTypeNameForType:(MKDocumentType)type {
    return [supportedDocTypes objectForKey:@(type)];
}

- (void)showDocumentPicker {
    switch (self.type) {
        case MKDocumentPickerType_Browser: {
            if (@available(iOS 11.0, *)) {
                [self presentBrowser];
            }
            else {
                [self presentMenu];
            }
        }
            break;
        case MKDocumentPickerType_MenuCamera: {
            [self presentMenuCamera];
        }
            break;
        default: {
            [self presentMenu];
        }
            break;
    }
}

- (void)presentBrowser {
    if (@available(iOS 11.0, *)) {
        UIDocumentBrowserViewController *pickerVC = [[UIDocumentBrowserViewController alloc] initForOpeningFilesWithContentTypes:acceptedDocTypes];
        pickerVC.delegate = self;
        [self.viewController presentViewController:pickerVC animated:YES completion:^{}];
    }
}

- (void)presentMenu {
    UIDocumentMenuViewController *pickerVC = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:acceptedDocTypes inMode:UIDocumentPickerModeImport];
    pickerVC.delegate = self;
    [self addImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary toMenu:pickerVC title:[Constants Photo_Library_STR] image:[MKAssets Photo_Library_Icon]];
    [self.viewController presentViewController:pickerVC animated:YES completion:^{}];
}

- (void)presentMenuCamera {
    UIDocumentMenuViewController *pickerVC = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:acceptedDocTypes inMode:UIDocumentPickerModeImport];
    pickerVC.delegate = self;
    [self addImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary toMenu:pickerVC title:[Constants Photo_Library_STR] image:[MKAssets Photo_Library_Icon]];
    [self addImagePickerWithType:UIImagePickerControllerSourceTypeCamera toMenu:pickerVC title:[Constants Camera_STR] image:[MKAssets Camera_Icon]];

    [self.viewController presentViewController:pickerVC animated:YES completion:^{}];
}

- (void)addImagePickerWithType:(UIImagePickerControllerSourceType)type toMenu:(UIDocumentMenuViewController *)menuVC title:(NSString *)title image:(UIImage *)image {
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        [menuVC addOptionWithTitle:title image:image order:UIDocumentMenuOrderFirst handler:^{
            UIImagePickerController *imgVC = [[UIImagePickerController alloc] init];
            imgVC.delegate = self;
            imgVC.allowsEditing = NO;
            imgVC.sourceType = type;
            [self.viewController presentViewController:imgVC animated:YES completion:^{}];
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    [self dispatchVCWithData:data];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    documentPicker.delegate = self;
    [self.viewController presentViewController:documentPicker animated:YES completion:^{}];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    [self dispatchVCWithData:[self dataFromURL:urls.firstObject]];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [self dispatchVCWithData:[self dataFromURL:url]];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentURLs:(NSArray<NSURL *> *)documentURLs {
    [controller dismissViewControllerAnimated:YES completion:^{}];
    [self dispatchVCWithData:[self dataFromURL:documentURLs.firstObject]];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didImportDocumentAtURL:(NSURL *)sourceURL toDestinationURL:(NSURL *)destinationURL {
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

- (void)dispatchVCWithData:(NSData *)data {
    if ([self.viewController respondsToSelector:@selector(documentPickerReturnedData:)]) {
        [self.viewController documentPickerReturnedData:data];
    }
}

- (NSData *)dataFromURL:(NSURL *)url {
    NSData *data = [self accessDataFromURL:url];
    if (!data) {
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


@end
