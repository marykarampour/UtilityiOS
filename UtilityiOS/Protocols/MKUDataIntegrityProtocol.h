//
//  MKUDataIntegrityProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUDataIntegrityProtocol;

typedef void(^VALIDATION_BLOCK)(BOOL success, NSString *error);
typedef void(*VALIDATION_OPERATOR)(NSObject <MKUDataIntegrityProtocol> *obj, SEL cmd, VALIDATION_BLOCK);

@protocol MKUDataIntegrityProtocol <NSObject>

@required
- (BOOL)isValid;

@end


@protocol MKUDataValidationProtocol <MKUDataIntegrityProtocol>

@required
- (void)isValidToSaveWithResult:(VALIDATION_BLOCK)result;
- (void)isValidToUpdateWithResult:(VALIDATION_BLOCK)result;

@end


@protocol MKUDataUpdateProtocol <MKUDataIntegrityProtocol>

@required
- (void)canSaveWithResult:(VALIDATION_BLOCK)result;
- (void)canUpdateWithResult:(VALIDATION_BLOCK)result;

@end
