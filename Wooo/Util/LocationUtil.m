//
//  LocationUtil.m
//  Wooo
//
//  Created by jhihguan on 2015/3/28.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "LocationUtil.h"

@implementation LocationUtil

+(LocationUtil *)sharedLocation {
    static LocationUtil *_locationUtil;
    static dispatch_once_t onceLocationToke;
    dispatch_once(&onceLocationToke, ^{
        _locationUtil = [[LocationUtil alloc] init];
        _locationUtil.locationManager = [[CLLocationManager alloc] init];
        _locationUtil.locationManager.delegate = _locationUtil;
    });
    return _locationUtil;
}

#pragma mark - location manager delegate

-(void)askForLocationPermission {
    [_locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            _isAllowLocation = YES;
            [_locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"取得座標錯誤 %@", error);
}


@end
