//
//  MKMessageComposerController.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-22.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKMessageComposerProtocol <NSObject>

@optional
- (void)messageComposerDidFinishSendingMail;

@end

@interface MKMessageComposerController : NSObject

- (instancetype)initWithViewController:(__kindof UIViewController<MKMessageComposerProtocol> *)viewController;

- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message;
- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients;
- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message attachmments:(NSDictionary <NSString *, NSData *> *)attachmments;

@end
