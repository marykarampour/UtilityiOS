//
//  MKDocumentPickerController.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKDocumentPickerController.h"

static StringArr *docTypes;

@implementation MKDocumentPickerController

+ (void)initialize {
    if (!docTypes) {
        docTypes = @[(NSString *)kUTTypePDF,
                     (NSString *)kUTTypeImage,
                     (NSString *)kUTTypeJPEG,
                     (NSString *)kUTTypeJPEG2000,
                     (NSString *)kUTTypeTIFF,
                     (NSString *)kUTTypePNG,
                     (NSString *)kUTTypeText];
    }
}

- (void)showDocumentPicker {
    switch (self.type) {
        case DocumentPickerType_Browser: {
            if (@available(iOS 11.0, *)) {
                [self presentBrowser];
            }
            else {
                [self presentMenu];
            }
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
        UIDocumentBrowserViewController *pickerVC = [[UIDocumentBrowserViewController alloc] initForOpeningFilesWithContentTypes:docTypes];
        pickerVC.delegate = self;
        [self.viewController presentViewController:pickerVC animated:YES completion:^{}];
    }
}

- (void)presentMenu {
    UIDocumentMenuViewController *pickerVC = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:docTypes inMode:UIDocumentPickerModeImport];
    pickerVC.delegate = self;
    [pickerVC addOptionWithTitle:@"Photos" image:nil order:UIDocumentMenuOrderFirst handler:^{
        UIImagePickerController *imgVC = [[UIImagePickerController alloc] init];
        imgVC.delegate = self;
        [self.viewController presentViewController:imgVC animated:YES completion:^{
            
        }];
    }];
    [self.viewController presentViewController:pickerVC animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSData *data = UIImagePNGRepresentation(img);
    [self dispatchVCWithData:data];
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
