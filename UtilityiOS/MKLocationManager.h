//
//  MKLocationManager.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MKLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *location;
@property (nonatomic, assign) BOOL isGeofencing;

+ (instancetype)instance;

- (float)latitude;
- (float)longitude;
- (float)speed;
- (CLLocationCoordinate2D)getLocation;
- (float)getHeadingForDirectionToCoordinate:(CLLocationCoordinate2D)location;
- (float)bearingBetweenLocationAndLocation:(CLLocation *)endLocation;



@end
