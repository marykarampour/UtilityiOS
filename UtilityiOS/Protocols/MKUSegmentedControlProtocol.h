//
//  MKUSegmentedControlProtocol.h
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2026-08-09.
//  Copyright © 2026 Commodity Forwarders Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUSegmentedControlProtocol <NSObject>

@end

@protocol MKUSegmentedControlModelProtocol <NSObject>

@required
- (NSInteger)selectedDocumentIndex;
+ (StringArr *)segmentNames;

@end
