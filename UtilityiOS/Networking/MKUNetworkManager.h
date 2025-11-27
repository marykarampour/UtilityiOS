//
//  MKUNetworkManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-10-02.
//  Copyright © 2025 Prometheus Software. All rights reserved.
//

#import "MKUServicesProtocol.h"

@interface MKUMultipartInfo : NSObject

@property (nonatomic, assign) MKU_NETWORK_CONTENT_TYPE contentType;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSData *data;

@end

@interface MKUNetworkManager : NSObject <MKUServicesProtocol>

@property (nonatomic, strong) NSString *serverBaseURL;
@property (nonatomic, weak) id<MKUServicesDelegate> serviceDelegate;

@end
