//
//  MKUMessageComposerController.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-22.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUMessageComposerController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "NSString+Validation.h"
#import "NSString+Utility.h"
#import "NSArray+Utility.h"
#import "MKUAppDelegate.h"
#import "NSData+Utility.h"

@interface MKUMessageComposerController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) __kindof UIViewController *viewController;
@property (nonatomic, weak) id<MKUMessageComposerProtocol> delegate;
@property (nonatomic, copy) void (^completionHandler)(MKU_MESSAGE_COMPOSER_RESULT);

@end


@implementation MKUMessageComposerController

- (instancetype)init {
    return [self initWithViewController:[[MKUAppDelegate application] visibleViewController] delegate:nil];
}

- (instancetype)initWithViewController:(__kindof UIViewController<MKUMessageComposerProtocol> *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
        self.delegate = viewController;
    }
    return self;
}

- (instancetype)initWithViewController:(__kindof UIViewController *)viewController delegate:(id<MKUMessageComposerProtocol>)delegate {
    if (self = [super init]) {
        self.viewController = viewController;
        self.delegate = delegate;
    }
    return self;
}

+ (instancetype)initComposerWithRecipient:(NSString *)recipient completion:(void (^)(MKU_MESSAGE_COMPOSER_RESULT))completion {
    
    MKUMessageComposerController *obj = [MKUAppDelegate application].composer;
    obj.completionHandler = completion;
    NSArray *email = [NSArray arrayWithNullableObject:recipient];
    
    if (MFMailComposeViewController.canSendMail) {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = obj;
        if (0 < recipient.length)
            [mail setToRecipients:email];
        
        [[[MKUAppDelegate application] visibleViewController] presentViewController:mail animated:YES completion:nil];
    }
    else if ([MKUMessageComposerController mailToWithTitle:nil message:nil recipients:email BCCRecipients:nil]) {
        return obj;
    }
    else if (obj.completionHandler) {
        obj.completionHandler(MKU_MESSAGE_COMPOSER_RESULT_FAILED);
    }
    
    return obj;
}

- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message {
    return [self sendEmailWithTitle:title message:message recipients:nil BCCRecipients:nil attachments:nil];
}

- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message asHTML:(BOOL)asHTML {
    return [self sendEmailWithTitle:title message:message recipients:nil BCCRecipients:nil attachments:nil asHTML:asHTML];
}

- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients {
    return [self sendEmailWithTitle:title message:message recipients:recipients BCCRecipients:nil attachments:nil];
}

- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients attachments:(NSDictionary<NSString *,NSData *> *)attachments {
    return [self sendEmailWithTitle:title message:message recipients:recipients BCCRecipients:nil attachments:attachments];
}

- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients BCCRecipients:(NSArray<NSString *> *)BCCRecipients attachments:(NSDictionary<NSString *,NSData *> *)attachments {
    return [self sendEmailWithTitle:title message:message recipients:recipients BCCRecipients:BCCRecipients attachments:attachments asHTML:[MKUMessageComposerController isHTML:message]];
}

- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients BCCRecipients:(NSArray<NSString *> *)BCCRecipients attachments:(NSDictionary<NSString *,NSData *> *)attachments asHTML:(BOOL)asHTML {
    
    if (MFMailComposeViewController.canSendMail) {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:title];
        [mail setMessageBody:message isHTML:asHTML];
        
        if ([MKUMessageComposerController isValidRecipient:recipients])
            [mail setToRecipients:recipients];
        if ([MKUMessageComposerController isValidRecipient:BCCRecipients])
            [mail setBccRecipients:BCCRecipients];
        
        [attachments enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
            [mail addAttachmentData:obj mimeType:[obj contentType] fileName:key];
        }];
        
        [self.viewController presentViewController:mail animated:YES completion:nil];
        return YES;
    }
    return [MKUMessageComposerController mailToWithTitle:title message:message recipients:recipients BCCRecipients:BCCRecipients];
}

+ (BOOL)mailToWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients BCCRecipients:(NSArray<NSString *> *)BCCRecipients {
    
    NSString *messageWithoutTags = [NSString removeHTMLTagsFromString:message];
    NSString *URLString = [self mailToStringWithTitle:title message:messageWithoutTags recipients:recipients BCCRecipients:BCCRecipients];
    NSURL *URL = [NSURL URLWithString:URLString];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        return YES;
    }
    return NO;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        
        MKU_MESSAGE_COMPOSER_RESULT type = MKU_MESSAGE_COMPOSER_RESULT_FAILED;
        switch (result) {
            case MFMailComposeResultSent:
                type = MKU_MESSAGE_COMPOSER_RESULT_SENT;
                break;
                
            case MFMailComposeResultCancelled:
                type = MKU_MESSAGE_COMPOSER_RESULT_CANCELLED;
                break;
                
            case MFMailComposeResultSaved:
                type = MKU_MESSAGE_COMPOSER_RESULT_SAVED;
                break;
                
            default:
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(messageComposerDidFinishWithResult:)]) {
            [self.delegate messageComposerDidFinishWithResult:type];
        }
        else if (self.completionHandler) {
            self.completionHandler(type);
        }
    }];
}

#pragma mark - helpers

+ (NSURL *)outlookURL {
    return [NSURL URLWithString:@"ms-outlook://compose?to="];
}

+ (NSString *)mailtoString {
    return @"mailto:";
}

+ (NSURL *)mailtoURL {
    return [NSURL URLWithString:[self mailtoString]];
}

+ (BOOL)hasOutlook {
    return [[UIApplication sharedApplication] canOpenURL:[self outlookURL]];
}

+ (BOOL)isHTML:(NSString *)message {
    return [message isValidHTML];
}

+ (BOOL)isValidRecipient:(NSObject *)obj {
    if (![obj isKindOfClass:[NSArray class]])
        return NO;
    
    NSArray *arr = (NSArray *)obj;
    if (![arr.firstObject isKindOfClass:[NSString class]])
        return NO;
    
    for (NSString *str in arr) {
        if ([str containsString:@"("] || [str containsString:@")"]) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)mailToStringWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients BCCRecipients:(NSArray<NSString *> *)BCCRecipients {
    
    NSString *mailto = [self mailtoString];
    NSString *recipient = recipients.firstObject;
    
    if (0 < recipient.length) {
        mailto = [mailto stringByAppendingString:recipient];
    }
    if (0 < title.length) {
        mailto = [mailto stringByAppendingString:[NSString stringWithFormat:@"?subject=%@", title]];
    }
    
    NSMutableArray<NSString *> *BCC;
    
    if (1 < recipients.count) {
        BCC = [NSMutableArray arrayWithArray:recipients];
        [BCC removeObjectAtIndex:0];
        [BCC addObjectsFromArray:BCCRecipients];
    }
    
    if (0 < BCC.count) {
        NSString *BCCString = [BCC componentsJoinedByString:@","];
        mailto = [mailto stringByAppendingString:[NSString stringWithFormat:@"&bcc=%@", BCCString]];
    }
    if (0 < message.length) {
        mailto = [mailto stringByAppendingString:[NSString stringWithFormat:@"&body=%@", message]];
    }
    return mailto;
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

- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients attachmments:(NSDictionary<NSString *,NSData *> *)attachmments {
    
    if (MFMailComposeViewController.canSendMail) {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:title];
        [mail setToRecipients:recipients];
        [mail setMessageBody:message isHTML:[message containsString:@"<html>"]];
        
        [attachmments enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
            [mail addAttachmentData:obj mimeType:[obj contentType] fileName:key];
        }];
        
        [self.viewController presentViewController:mail animated:YES completion:nil];
    }
}

+ (void)emailToAddress:(NSString *)text {
    if (text.length == 0) return;
    
    [self initComposerWithRecipient:text completion:^(MKU_MESSAGE_COMPOSER_RESULT result) {
        if (result == MKU_MESSAGE_COMPOSER_RESULT_FAILED) {
            [NSObject OKAlertWithTitle:@"Device can not send email" message:nil];
        }
    }];
}

@end
