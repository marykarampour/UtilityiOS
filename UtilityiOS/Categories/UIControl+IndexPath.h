//
//  UIControl+IndexPath.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "IndexPathProtocol.h"

@interface UIControl (IndexPath) <IndexPathProtocol>

@property (nonatomic, strong) NSString *GUID;

@end
