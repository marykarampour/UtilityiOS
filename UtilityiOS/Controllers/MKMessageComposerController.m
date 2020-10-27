//
//  MKMessageComposerController.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-22.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKMessageComposerController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "NSData+Utility.h"

@interface MKMessageComposerController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) __kindof UIViewController<MKMessageComposerProtocol> *viewController;

@end

@implementation MKMessageComposerController

- (instancetype)initWithViewController:(__kindof UIViewController<MKMessageComposerProtocol> *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
    }
    return self;
}

- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message {
    
    if (MFMailComposeViewController.canSendMail) {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setTitle:title];
        [mail setMessageBody:message isHTML:NO];
        
        [self.viewController presentViewController:mail animated:YES completion:nil];
    }
}

- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients {
    
    if (MFMailComposeViewController.canSendMail) {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setTitle:title];
        [mail setMessageBody:message isHTML:NO];
        [mail setToRecipients:recipients];
        
        [self.viewController presentViewController:mail animated:YES completion:nil];
    }
}

- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message attachmments:(NSDictionary<NSString *,NSData *> *)attachmments {
    
    if (MFMailComposeViewController.canSendMail) {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:title];
        [mail setMessageBody:message isHTML:[message containsString:@"<html>"]];
        
        [attachmments enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
            [mail addAttachmentData:obj mimeType:[obj contentType] fileName:key];
        }];
    
        [self.viewController presentViewController:mail animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        if ([self.viewController respondsToSelector:@selector(messageComposerDidFinishSendingMail)]) {
            [self.viewController messageComposerDidFinishSendingMail];
        }
    }];
}

@end
