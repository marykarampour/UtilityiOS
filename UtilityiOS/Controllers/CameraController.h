//
//  CameraController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraProtocol <NSObject>

@optional
- (void)imagePickerPickedImageDate:(NSData *)data;

@end

@interface CameraController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)presentCamera;

@end
