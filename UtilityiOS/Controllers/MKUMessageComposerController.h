//
//  MKUMessageComposerController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-22.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MKU_MESSAGE_COMPOSER_RESULT) {
    MKU_MESSAGE_COMPOSER_RESULT_CANCELLED,
    MKU_MESSAGE_COMPOSER_RESULT_SAVED,
    MKU_MESSAGE_COMPOSER_RESULT_SENT,
    MKU_MESSAGE_COMPOSER_RESULT_FAILED
};

@protocol MKUMessageComposerProtocol <NSObject>

@optional
- (void)messageComposerDidFinishWithResult:(MKU_MESSAGE_COMPOSER_RESULT)result;

@end

@interface MKUMessageComposerController : NSObject

- (instancetype)initWithViewController:(__kindof UIViewController<MKUMessageComposerProtocol> *)viewController;
- (instancetype)initWithViewController:(__kindof UIViewController *)viewController delegate:(id<MKUMessageComposerProtocol>)delegate;
+ (instancetype)initComposerWithRecipient:(NSString *)recipient completion:(void(^)(MKU_MESSAGE_COMPOSER_RESULT result))completion;

/** @return YES if it can send mail, otherwise NO. */
- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message;
- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients;
- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message attachmments:(NSDictionary <NSString *, NSData *> *)attachmments;
- (void)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients attachmments:(NSDictionary <NSString *, NSData *> *)attachmments;
- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients attachments:(NSDictionary <NSString *, NSData *> *)attachments;
- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients BCCRecipients:(NSArray<NSString *> *)BCCRecipients attachments:(NSDictionary <NSString *, NSData *> *)attachments;
- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message recipients:(NSArray<NSString *> *)recipients BCCRecipients:(NSArray<NSString *> *)BCCRecipients attachments:(NSDictionary <NSString *, NSData *> *)attachments asHTML:(BOOL)asHTML;

/** @param asHTML == YES it will send the message with isHTML = NO. */
- (BOOL)sendEmailWithTitle:(NSString *)title message:(NSString *)message asHTML:(BOOL)asHTML;
+ (void)emailToAddress:(NSString *)text;
+ (instancetype)initComposerWithRecipient:(NSString *)recipient completion:(void(^)(MKU_MESSAGE_COMPOSER_RESULT result))completion;

@end

