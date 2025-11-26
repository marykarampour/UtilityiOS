//
//  MKULocationManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "MKULocationManager.h"
#import "NSObject+Alert.h"

static NotificationCategoryIdentifier const GeoFenceCatID = @"GeoFenceCatID";

@implementation MKUGeoFencePoint

@end

@interface MKULocationManager ()

@property (nonatomic, assign) float speed;
@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D lastFencedLocation;

// These are set to prevent multiple consecutive calls being processed
@property (nonatomic, strong) NSTimer *enterRegionTimer;
@property (nonatomic, strong) NSTimer *updateLocationsTimer;
@property (nonatomic, strong) NSArray<MKUGeoFencePoint *> *geofencedPoints;

@end

@implementation MKULocationManager

+ (instancetype)instance {
    static MKULocationManager *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[MKULocationManager alloc] init];
    });
    return location;
}

- (instancetype)init {
    if (self = [super init]) {
        [self checkLocationAuthorizationStatus];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self setMonitoringLocation];
        
        self.geofencePointNotificationDelay = 10.0;
    }
    return self;
}

- (CLLocationCoordinate2D)location2D {
    return self.locationManager.location.coordinate;
}

- (CGPoint)locationPoint {
    return CGPointMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
}

- (double)latitude {
    return [self location2D].latitude;
}

- (double)longitude {
    return [self location2D].longitude;
}

- (float)speed {
    return self.speed;
}

- (CLLocationCoordinate2D)getLocation {
    return self.locationManager.location.coordinate;
}

#pragma mark - calculating locations

- (float)getHeadingForDirectionToCoordinate:(CLLocationCoordinate2D)location {
    
    float fLat = ([self latitude])*M_PI/180.0;
    float fLng = ([self longitude])*M_PI/180.0;
    float tLat = (location.latitude)*M_PI/180.0;
    float tLng = (location.longitude)*M_PI/180.0;
    
    DEBUGLOG(@"%@", self.locationManager.heading);
    
    return (atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))*180.0/M_PI;
}

- (float)calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    
    NSInteger nRadius = 6371; // Earth's radius in Kilometers
    double latDiff = (coord2.latitude - coord1.latitude)*M_PI/180.0;
    double lonDiff = (coord2.longitude - coord1.longitude)*M_PI/180.0;
    double lat1InRadians = (coord1.latitude)*M_PI/180.0;
    double lat2InRadians = (coord2.latitude)*M_PI/180.0;
    
    double nA = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
    // convert to meters
    return nD*1000;
}

- (BOOL)locationIsInRegion:(CLLocationCoordinate2D)coord {
    if ([self calculateDistanceInMetersBetweenCoord:self.locationManager.location.coordinate coord:coord] < [Constants GeoFenceRadiousMeter]) {
        return YES;
    }
    return NO;
}

- (float)bearingBetweenLocationAndLocation:(CLLocation *)endLocation {
    
    CLLocation *northPoint = [[CLLocation alloc] initWithLatitude:(self.locationManager.location.coordinate.latitude)+.01 longitude:endLocation.coordinate.longitude];
    float magA = [northPoint distanceFromLocation:self.locationManager.location];
    float magB = [endLocation distanceFromLocation:self.locationManager.location];
    CLLocation *startLat = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:0];
    CLLocation *endLat = [[CLLocation alloc] initWithLatitude:endLocation.coordinate.latitude longitude:0];
    float aDotB = magA*[endLat distanceFromLocation:startLat];
    
    return (acosf(aDotB/(magA*magB)))*180.0/M_PI;
}

#pragma mark - location

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self setMonitoringLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DEBUGLOG(@"Location manager faild with error: %@", error.localizedDescription);
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        [NSObject OKAlertWithTitle:[Constants LocationRestrictedTitle_STR] message:[Constants LocationRestrictedMessage_STR]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *locatoin = [locations lastObject];
    if ([self calculateDistanceInMetersBetweenCoord:self.lastFencedLocation coord:locatoin.coordinate] >= [Constants GeoFenceRadiousMeter]) {
        self.speed = locatoin.speed;
        // walking
        if (self.speed > 0.5 && self.speed < 2.0) {
            [self postLocationUpdateNotification];
        }
        // driving, update less frequently
        else if (self.speed >= 10.0 && ![self.updateLocationsTimer isValid]) {
            self.updateLocationsTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopUpdateLocationsTimer) userInfo:nil repeats:NO];
            [self postLocationUpdateNotification];
        }
    }
}

#pragma mark - geofencing

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([self.enterRegionTimer isValid]) return;
    self.enterRegionTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopEnterRegionTimer) userInfo:nil repeats:NO];
    
    CLCircularRegion *cRegion = (CLCircularRegion *)region;
    unsigned int i = 1;
    for (MKUGeoFencePoint *point in self.geofencedPoints) {
        if (point.point.latitude == cRegion.center.latitude && point.point.longitude == cRegion.center.longitude) {
            i++;
            [self createNotificationForGeoFencedPoint:point delay:i];
            break;
        }
    }
}

- (void)createGeofencedZone:(NSArray<__kindof MKUGeoFencePoint *> *)geofencedPoints {
    self.geofencedPoints = geofencedPoints;
    self.lastFencedLocation = self.locationManager.location.coordinate;
    for (MKUGeoFencePoint *loc in geofencedPoints) {
        unsigned int i = 1;
        [self createGeofenceForPoint:loc.point];
        if ([self locationIsInRegion:loc.point]) {
            i++;
            [self createNotificationForGeoFencedPoint:loc delay:i];
        }
    }
}

- (void)createGeofenceForPoint:(CLLocationCoordinate2D)point {
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:point radius:[Constants GeoFenceRadiousMeter] identifier:[[NSUUID UUID] UUIDString]];
    [self.locationManager startMonitoringForRegion:region];
}

#pragma mark - notifications

- (void)createNotificationForGeoFencedPoint:(MKUGeoFencePoint *)point delay:(NSUInteger)index {
    [[MKUNotificationController instance] scheduleLocalNotificationWithIdentifier:point.identifier categoryID:GeoFenceCatID body:point.title fireTime:self.geofencePointNotificationDelay*index];
}

#pragma mark - helpers

- (void)checkLocationAuthorizationStatus {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            [self actionAlertWithTitle:[Constants LocationRestrictedTitle_STR] message:[Constants LocationRestrictedMessage_STR] alertAction:@selector(openLocationSettings)];
        }
            break;
        default:
            break;
    }
}

- (void)setMonitoringLocation {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [self.locationManager startMonitoringSignificantLocationChanges];
            if ([CLLocationManager headingAvailable]) {
                self.locationManager.headingFilter = 5.0;
                [self.locationManager startUpdatingHeading];
            }
        }
            break;
        default:
            break;
    }
}

- (void)openLocationSettings {
    if (@available(iOS 8.0, *)) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)stopUpdateLocationsTimer {
    if ([self.updateLocationsTimer isValid]) {
        [self.updateLocationsTimer invalidate];
    }
}

- (void)stopEnterRegionTimer {
    if ([self.enterRegionTimer isValid]) {
        [self.enterRegionTimer invalidate];
    }
}

+ (NSNotificationName)MKULocationUpdateNotificationName {
    return @"MKULocationUpdateNotificationName";
}

- (void)postLocationUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MKULocationManager MKULocationUpdateNotificationName] object:self userInfo:nil];
}

#pragma mark - utiltiy

+ (CLLocationCoordinate2D)DefaultLocation {
    return CLLocationCoordinate2DMake(43.667320, -79.385510);
}

+ (void)addressWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(void (^)(StringArr *))completion {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (completion) completion(placemarks.firstObject.addressDictionary[@"FormattedAddressLines"]);
    }];
}

@end
