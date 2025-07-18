//
//  MKULocationManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MKUNotificationController.h"
#import "MKUModel.h"

@interface MKUGeoFencePoint : MKUModel

@property (nonatomic, strong) NotificationIdentifier identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D point;

@end

@interface MKULocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *location;
/** @brief delay between fire time of two notifications when creating a geofence zone. Default is 10 seconds.*/
@property (nonatomic, assign) float geofencePointNotificationDelay;


+ (instancetype)instance;

+ (NSNotificationName)MKULocationUpdateNotificationName;

- (float)latitude;
- (float)longitude;
- (float)speed;
- (CLLocationCoordinate2D)getLocation;
- (float)getHeadingForDirectionToCoordinate:(CLLocationCoordinate2D)location;
- (float)bearingBetweenLocationAndLocation:(CLLocation *)endLocation;

//Geofencing
- (void)createGeofencedZone:(NSArray<__kindof MKUGeoFencePoint *> *)geofencedPoints;
- (void)createGeofenceForPoint:(CLLocationCoordinate2D)point;


#pragma mark - utility

+ (CLLocationCoordinate2D)DefaultLocation;
+ (void)addressWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(void (^)(StringArr * address))completion;

@end
