//
//  MKUMutableObjectVCProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUFieldModel.h"
#import "MKUObjectProtocol.h"
#import "MKUViewControllerTransitionProtocol.h"
#import "MKUNavBarButtonTargetProtocol.h"

/** @brief In MKU app almost all screens have a save and possibly also a reset button.
 Because this feature is very common these buttons are added to UIViewController as category. */
@protocol MKUMutableObjectVCProtocol <MKUFieldModelDelegate, MKUNavBarButtonTargetProtocol, MKUObjectProtocol>

@optional
/** @note Default checks:
 @code
 [self.object.OriginalObject isEqual:self.object.UpdatedObject]
 @endcode
 */
- (BOOL)canPerformSaveObject;
/** @brief If canPerformSaveObject returns NO, this method is called and save is aborted. Use this method to perform cleanup
 or show information prompts to user. */
- (void)handleAbortSaveObject;

/** @note Default checks:
 @code
 [self prepareDataForUpdate];
 
 if ([self performDefaultSavePressedAction]) {
 [self dispatchDelegateForSaveDone];
 return;
 }
 
 [self performSaveOrUpdateObjectWithCompletion:self.performSaveOrUpdateObjectCompletionHandler];
 @endcode
 */
- (void)handleSaveObject;
- (void)updateObjectWithCompletion:(void(^)(BOOL result, NSError *error))completion;
- (void)saveObjectWithCompletion:(void(^)(NSNumber *result, NSError *error))completion;

- (BOOL)canUpdate;
/** @brief Last chance to process data for saving. */
- (void)prepareDataForUpdate;
- (void)didFinishUpdateWithResultID:(NSNumber *)ID;

/** @brief Sets the Save and Reset right bar button items.
 @note viewControllerContainingNavigationBar must be set before calling this method. */
- (void)setMutableNavBarItems;

/** @brief This is called in reset, setObject and setUpdatedObject methods, use this to update any single cells like segments, or other needed updates,
 default does nothing. Call super if you have date cells, it will automatically set the values in date cells. */
- (void)didResetUpdateObject:(__kindof NSObject<MKUFieldModelProtocol> *)object;

/** @brief Called every time object is set. Use this as a replacement for overriding setObject: which is implemented in category UIViewController (MKUMutableObjectVC)
 and should not be overriden. */
- (void)didSetObject:(__kindof MKUUpdateObject *)object;

/** @brief Only calls dispatchDelegateForSaveDone after end editing. Defalt returns NO. */
- (BOOL)performDefaultSavePressedAction;

- (void)dispatchDelegateForSaveDone;
+ (Class)classForObject;

#pragma mark - KVO

- (void)updateObject:(__kindof NSObject<MKUFieldModelProtocol> *)object didUpdateKey:(NSString *)key;

@required
/** @brief Handles action performed when pressing the reset button. Default in MKUMutableObjectTableViewController is:.
 @code
 [self.object reset];
 [self didResetUpdateObject:self.object.UpdatedObject];
 @endcode
 */

/** @brief This is called when save is pressed as the completion of performSaveOrUpdateObjectWithCompletion.
 If nil, performSaveOrUpdateObjectWithCompletion will shows success failure error alerts, otherwise it will perform the completion with no alerts.
 @note Default completion is nil. Set to perform other actions. */
@property (copy) void(^performSaveOrUpdateObjectCompletionHandler)(BOOL result, NSError *error);

@property (nonatomic, strong) __kindof MKUUpdateObject *object;

/** @brief It calls setObject: */
- (void)setUpdatedObject:(__kindof NSObject<MKUFieldModelProtocol> *)updatedObject;

@end

