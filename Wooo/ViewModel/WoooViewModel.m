//
//  WoooViewModel.m
//  Wooo
//
//  Created by jhihguan on 2015/3/27.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "WoooViewModel.h"
#import "WoooModel.h"
#import "Constant.h"
#import "LocationUtil.h"
#import <Parse.h>
#import <Flurry.h>

@interface WoooViewModel () {
    BOOL _isWoooooing;
    NSTimer *_pressTimer;
    LocationUtil *_locationUtil;
}

@end

@implementation WoooViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locationUtil = [LocationUtil sharedLocation];
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    }
    return self;
}

- (BOOL)checkPlace {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"崩潰" message:@"請開啓定位服務" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    if (!_locationUtil.isAllowLocation) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"崩潰" message:@"需要位置資訊一起崩潰" delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"前往設定", nil];
        alertView.tag = 101;
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)checkCanSaveWooo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastWoooTime = [userDefaults objectForKey:kLastWoooTime];
    CLLocation *lastWoooLocation = [[CLLocation alloc] initWithLatitude:[userDefaults doubleForKey:kLastWoooLatitude] longitude:[userDefaults doubleForKey:kLastWoooLongitude]];
    if (lastWoooTime && [lastWoooTime timeIntervalSinceNow] > -300.0f) {
        if ([lastWoooLocation distanceFromLocation:_locationUtil.locationManager.location] > 20.0f) {
            
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)saveWooo {
    if (![self checkPlace]) {
        return;
    }
    
    CLLocation *location = _locationUtil.locationManager.location;
    if (location && _rate > 0) {
        [Flurry logEvent:@"Wooooo"];
        PFGeoPoint *userPoint = [PFGeoPoint geoPointWithLocation:location];
        PFObject *woooObject = [PFObject objectWithClassName:kWoooObject];
        woooObject[kWoooLocationKey] = userPoint;
        woooObject[kWoooRateKey] = [NSNumber numberWithInteger:_rate];
        woooObject[kWoooCreateAtKey] = [NSDate date];
        if ([self checkCanSaveWooo]) {
            [woooObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    woooObject[kWoooIsUploadKey] = @YES;
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setValue:[NSDate date] forKey:kLastWoooTime];
                    [userDefault setDouble:location.coordinate.latitude forKey:kLastWoooLatitude];
                    [userDefault setDouble:location.coordinate.longitude forKey:kLastWoooLongitude];
                    [userDefault synchronize];
                    self.statusMessage = kWoooSuccessMessage;
                } else {
                    woooObject[kWoooIsUploadKey] = @NO;
                    NSLog(@"error happen! %@", error);
                    [Flurry logError:@"PARSE" message:@"SAVE Wooo Object" error:error];
                    self.statusMessage = kWoooFailMessage;
                }
                [woooObject pinInBackgroundWithName:kWoooObject];
            }];
        } else {
            woooObject[kWoooIsUploadKey] = @NO;
            [woooObject pinInBackgroundWithName:kWoooObject];
        }

//        [[woRef childByAutoId] setValue:woooDictionary withCompletionBlock:^(NSError *error, Firebase *ref) {
//            if (error) {
//                NSLog(@"write error~ %@", error);
//            } else {
//                woooModel.isUpload = YES;
//            }
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            [realm beginWriteTransaction];
//            [realm addObject:woooModel];
//            [realm commitWriteTransaction];
//        }];
        
        //        self.rate = 0;
    }
}

- (void)longPressStart {
    self.rate = 10.0f;
    _pressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(countPress) userInfo:nil repeats:YES];
}

- (void)longPressEnd {
    [_pressTimer invalidate];
    [self saveWooo];
}

- (void)countPress {
    if (self.rate < 98.0f) {
        self.rate += 1.8f;
    } else {
        self.rate = 100.0f;
    }
}

#pragma mark - detect orientation

- (void)orientationChanged:(NSNotification *)notification{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            self.woooButtonText = kPortraitButtonText;
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            self.woooButtonText = kLandscapeButtonText;
        default:
            break;
    }
}


@end
