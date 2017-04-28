//
//  MKPair.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"

@interface MKPair : MKModel

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

@end

typedef NSArray<MKPair *> MKPairArr;
typedef NSMutableArray<MKPair *> MMKPairArr;
