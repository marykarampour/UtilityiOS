//
//  MasterDetailProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MasterProtocol;

@protocol DetailProtocol <NSObject>

@required
@property (nonatomic, weak) id<MasterProtocol> masterDelegate;

@end

@protocol MasterProtocol <NSObject>

@required
@property (nonatomic, weak) id<DetailProtocol> detailDelegate;

@end

