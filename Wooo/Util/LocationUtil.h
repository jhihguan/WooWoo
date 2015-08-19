//
//  LocationUtil.h
//  Wooo
//
//  Created by jhihguan on 2015/3/28.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtil : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isAllowLocation;

+(LocationUtil *)sharedLocation;
-(void)askForLocationPermission;

@end
