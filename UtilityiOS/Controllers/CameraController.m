//
//  CameraController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "CameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Editing.h"
#import "NSObject+Alert.h"
#import "UIImage+Editing.h"

@interface CameraController ()

@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation CameraController

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
        [self ImagePickerAuthorization];
    }
    return self;
}

- (void)ImagePickerAuthorization {
    AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (auth == AVAuthorizationStatusDenied) {
        [self OKAlertWithTitle:[Constants CameraDisabledTitle_STR] message:[NSString stringWithFormat:[Constants CameraAccessMessage_BLANK_STR], [Constants TakingPicture_STR]]];
    }
}

- (void)presentCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self OKAlertWithTitle:[Constants Error_STR] message:[Constants NoCamera_STR]];
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.viewController presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([self.viewController respondsToSelector:@selector(imagePickerPickedImageDate:)]) {
        NSData *image = [info[UIImagePickerControllerOriginalImage] shrink];
        [self.viewController performSelector:@selector(imagePickerPickedImageDate:) withObject:image];
    }
}

@end
