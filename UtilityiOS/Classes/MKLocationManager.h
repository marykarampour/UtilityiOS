//
//  MKLocationManager.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MKNotificationController.h"

@interface MKGeoFencePoint : NSObject

@property (nonatomic, strong) NotificationIdentifier identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D point;

@end

@interface MKLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *location;
/** @brief delay between fire time of two notifications when creating a geofence zone. Default is 10 seconds.*/
@property (nonatomic, assign) float geofencePointNotificationDelay;


+ (instancetype)instance;

+ (NSNotificationName)MKLocationUpdateNotificationName;

- (float)latitude;
- (float)longitude;
- (float)speed;
- (CLLocationCoordinate2D)getLocation;
- (float)getHeadingForDirectionToCoordinate:(CLLocationCoordinate2D)location;
- (float)bearingBetweenLocationAndLocation:(CLLocation *)endLocation;

//Geofencing
- (void)createGeofencedZone:(NSArray<MKGeoFencePoint *> *)geofencedPoints;
- (void)createGeofenceForPoint:(CLLocationCoordinate2D)point;

@end
