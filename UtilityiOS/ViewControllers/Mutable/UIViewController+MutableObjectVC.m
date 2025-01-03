//
//  UIViewController+MutableObjectVC.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+MutableObjectVC.h"
#import "UIViewController+ViewControllerTransition.h"
#import "NSObject+NavBarButtonTarget.h"
#import "UIViewController+Utility.h"
#import "NSObject+Alert.h"
#import <objc/runtime.h>
#import "MKUSpinner.h"

static char OBJECT_KEY;
static char PERFORM_SAVE_ACTION_HANDLER_KEY;

@implementation UIViewController (MutableObjectVC)

#pragma mark - properties

- (void)setObject:(__kindof MKUUpdateObject *)object {
    objc_setAssociatedObject(self, &OBJECT_KEY, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self respondsToSelector:@selector(didSetObject:)])
        [self didSetObject:object];
    
    if (![object isKindOfClass:[MKUUpdateObject class]]) return;
    
    if ([object.UpdatedObject respondsToSelector:@selector(setUpdateDelegate:)])
        object.UpdatedObject.updateDelegate = self;
    if ([self respondsToSelector:@selector(didResetUpdateObject:)])
        [self didResetUpdateObject:object.UpdatedObject];
}

- (__kindof MKUUpdateObject *)object {
    return objc_getAssociatedObject(self, &OBJECT_KEY);
}

- (void)setUpdatedObject:(__kindof NSObject<MKUFieldModelProtocol> *)updatedObject {
    if (![self.class respondsToSelector:@selector(classForObject)]) return;
    [self setObject:[[[self.class classForObject] alloc] initWithObject:updatedObject]];
}

- (void)setPerformSaveOrUpdateObjectCompletionHandler:(void (^)(BOOL, NSError *))performSaveOrUpdateObjectCompletionHandler {
    objc_setAssociatedObject(self, &PERFORM_SAVE_ACTION_HANDLER_KEY, performSaveOrUpdateObjectCompletionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(BOOL, NSError *))performSaveOrUpdateObjectCompletionHandler {
    return objc_getAssociatedObject(self, &PERFORM_SAVE_ACTION_HANDLER_KEY);
}

#pragma mark - methods

- (id)saveObject {
    return self.object;
}

- (void)reset {
    [self.object reset];
    if ([self respondsToSelector:@selector(didResetUpdateObject:)])
        [self didResetUpdateObject:self.object.UpdatedObject];
    [self dispathTransitionDelegateToReturnWithResult:VC_TRANSITION_RESULT_TYPE_CANCEL object:self.object.UpdatedObject];
}

- (void)handleSavePressed {
    if (![self respondsToSelector:@selector(canPerformSaveObject)]) return;
    
    if (![self canPerformSaveObject]) {
        if (![self respondsToSelector:@selector(handleAbortSaveObject)]) return;
        [self handleAbortSaveObject];
        return;
    }
    
    if ([self respondsToSelector:@selector(prepareDataForUpdate)])
        [self prepareDataForUpdate];
    
    if ([self respondsToSelector:@selector(performDefaultSavePressedAction)] && [self performDefaultSavePressedAction]) {
        if (![self respondsToSelector:@selector(dispatchDelegateForSaveDone)]) return;
        [self dispatchDelegateForSaveDone];
        return;
    }
    
    if ([self respondsToSelector:@selector(handleSaveObject)])
        [self handleSaveObject];
    else
        [self performSaveOrUpdateObjectWithCompletion:self.performSaveOrUpdateObjectCompletionHandler];
}

- (void)defaultDispatchDelegateForSaveDone {
    [self dispathTransitionDelegateToReturnWithObject:self.object.UpdatedObject];
}

- (void)performSaveOrUpdateObjectWithCompletion:(void (^)(BOOL, NSError *))completion {
    
    [MKUSpinner show];
    if ([self respondsToSelector:@selector(canUpdate)] &&
        [self respondsToSelector:@selector(updateObjectWithCompletion:)] &&
        [self canUpdate]) {
        [self updateObjectWithCompletion:^(BOOL result, NSError *error) {
            [MKUSpinner hide];
            if (completion) {
                completion(result, error);
            }
            else {
                [self handleSaveObjectCompletionWithSuccess:result ID:nil error:error];
            }
        }];
    }
    else if ([self respondsToSelector:@selector(saveObjectWithCompletion:)]) {
        [self saveObjectWithCompletion:^(NSNumber *result, NSError *error) {
            [MKUSpinner hide];
            if (completion) {
                if ([self respondsToSelector:@selector(didFinishUpdateWithResultID:)])
                    [self didFinishUpdateWithResultID:result];
                completion(0 < [result integerValue], error);
            }
            else {
                [self handleSaveObjectCompletionWithSuccess:0 < [result integerValue] ID:result error:error];
            }
        }];
    }
}

- (void)handleSaveObjectCompletionWithSuccess:(BOOL)success ID:(NSNumber *)ID error:(NSError *)error {
    if (!error && success) {
        if (ID && [self respondsToSelector:@selector(didFinishUpdateWithResultID:)])
            [self didFinishUpdateWithResultID:ID];
        [self OKAlertWithTitle:[Constants Save_STR] message:nil];
        [self dispatchDelegateForSaveDone];
    }
    else if (error) {
        [self OKAlertWithTitle:[Constants Update_Failed_Title_STR] message:error.localizedDescription];
    }
}

- (void (^)(NSNumber *ID, NSError *error))IDResultCompletion {
    return ^(NSNumber *ID, NSError *error) {
        [self handleSaveObjectCompletionWithSuccess:0 < [ID integerValue] ID:ID error:error];
    };
}

- (void (^)(BOOL, NSError *))successResultCompletion {
    return ^(BOOL success, NSError *error) {
        [self handleSaveObjectCompletionWithSuccess:success ID:nil error:error];
    };
}

#pragma mark - navbar

- (void)setMutableNavBarItems {
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_RESET position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
}

@end

