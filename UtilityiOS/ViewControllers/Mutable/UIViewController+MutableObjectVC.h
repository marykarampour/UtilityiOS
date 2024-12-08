//
//  UIViewController+MutableObjectVC.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUMutableObjectVCProtocol.h"

/** @brief This category does not synthesize the properties. It only implements the required methods.
 @note saveObject of MKUSaveBarButtonProtocol is implemented as self.object */
@interface UIViewController (MutableObjectVC) <MKUMutableObjectVCProtocol>


/** @brief By default calls [self dispathTransitionDelegateToReturnWithObject:self.object.UpdatedObject]. */
- (void)defaultDispatchDelegateForSaveDone;

/** @brief This is called when save is pressed. It calls updateObjectWithCompletion or saveObjectWithCompletion.
 If completion = nil, it will shows success failure error alerts, otherwise it will perform the completion with no alerts.
 @note Default completion is nil. Set  performSaveOrUpdateObjectCompletionHandler to perform other actions. */
- (void)performSaveOrUpdateObjectWithCompletion:(void(^)(BOOL result, NSError *error))completion;

/** @brief Called when right bar button item is ressed. By default does:
 @code
 
 [self prepareDataForUpdate];
 
 if ([self performDefaultSavePressedAction]) {
 [self dispatchDelegateForSaveDone];
 return;
 }
 
 [self performSaveOrUpdateObjectWithCompletion:nil];
 
 @endcode
 */
- (void)handleSavePressed;

/** @brief Resets the object and calls didResetUpdateObject: */
- (void)reset;

/** @brief Checks for successful result and shows an appropriate alert and dispatchDelegateForSaveDone if successful. */
- (void)handleSaveObjectCompletionWithSuccess:(BOOL)success ID:(NSNumber *)ID error:(NSError *)error;

/** @brief Performs handleSaveObjectCompletionWithSuccess: ID: error: */
- (void (^)(NSNumber *ID, NSError *error))IDResultCompletion;

/** @brief Performs handleSaveObjectCompletionWithSuccess: ID: error: */
- (void (^)(BOOL success, NSError *error))successResultCompletion;

@end
