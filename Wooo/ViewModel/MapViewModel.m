//
//  MapViewModel.m
//  Wooo
//
//  Created by jhihguan on 2015/3/28.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "MapViewModel.h"
#import "Constant.h"
#import "MapAnnotationModel.h"
#import "LocationUtil.h"
#import "WoooModel.h"
#import <Parse.h>
#import <Flurry.h>

@interface MapViewModel () {
    NSDateFormatter *dateFormatter;
    LocationUtil *_locationUtil;
    NSMutableDictionary *_pointDictionary;
    NSMutableArray *_userHistoryArray;
}


@end

@implementation MapViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _userHistoryArray = [[NSMutableArray alloc] init];
        _detailPointArray = [[NSMutableArray alloc] init];
        _mapPointArray = [[NSMutableArray alloc] init];
        _locationUtil = [LocationUtil sharedLocation];
        _pressPoint = [[MapAnnotationModel alloc] init];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    return self;
}

- (void)queryNearWooo {
    if (_locationUtil.locationManager.location) {
        self.location = _locationUtil.locationManager.location;
    } else {
        self.location = [[CLLocation alloc] initWithLatitude:25.031279 longitude:121.534781];
    }
    [self loadWoooPoints];
}

- (void)queryNearWoooByPress:(CLLocation *)location {
    _location = location;
    [self loadWoooPoints];
}

- (void)loadWoooPoints {
    MapAnnotationModel *pressAnnotaion = [[MapAnnotationModel alloc] init];
    pressAnnotaion.coordinate = _location.coordinate;
    pressAnnotaion.capacity = 0;
    self.pressPoint = pressAnnotaion;

    MapAnnotationModel *searchAnnotation = [[MapAnnotationModel alloc] init];
    searchAnnotation.coordinate = CLLocationCoordinate2DMake(_location.coordinate.latitude, _location.coordinate.longitude);
    PFQuery *query = [PFQuery queryWithClassName:kWoooObject];
    query.limit = 300;
    [query orderByDescending:kWoooCreateAtKey];
    NSNumber *distance = [[NSUserDefaults standardUserDefaults] valueForKey:kWoooRegionValue];
    [query whereKey:kWoooLocationKey nearGeoPoint:[PFGeoPoint geoPointWithLocation:_location] withinKilometers:[distance doubleValue]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error, %@", error);
            [Flurry logError:@"PARSE" message:@"QUERY Map Data" error:error];
        } else {
            NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
            NSMutableArray *locationArray = [[NSMutableArray alloc] init];
            BOOL isNeedAdd;
            _pointDictionary = [[NSMutableDictionary alloc] init];
            for (PFObject *woObject in objects) {
                isNeedAdd = YES;
                PFGeoPoint *woPoint = woObject[kWoooLocationKey];
                
                MapAnnotationModel *mapAnnoModel = [[MapAnnotationModel alloc] init];
                mapAnnoModel.coordinate = CLLocationCoordinate2DMake(woPoint.latitude, woPoint.longitude);
                mapAnnoModel.capacity = 1;
                CLLocation *woLocation = [[CLLocation alloc] initWithLatitude:woPoint.latitude longitude:woPoint.longitude];
                
                WoooModel *woooModel = [[WoooModel alloc] init];
                woooModel.location = woLocation;
                woooModel.rate = [woObject[kWoooRateKey] integerValue];
                woooModel.woooAt = [dateFormatter stringFromDate:woObject[kWoooCreateAtKey]];
                
                for (NSInteger i = 0; i < locationArray.count; i++) {
                    CLLocation *location = [locationArray objectAtIndex:i];
                    if ([location distanceFromLocation:woLocation] < 80.0f) {
                        NSMutableArray *pointArray = [_pointDictionary valueForKey:[NSString stringWithFormat:@"%zd", i]];
                        [pointArray addObject:woooModel];
                        MapAnnotationModel *oldMapModel = [annotationArray objectAtIndex:i];
                        oldMapModel.capacity += 1;
                        isNeedAdd = NO;
                        break;
                    }
                }
                
                if (isNeedAdd) {
                    NSString *key = [NSString stringWithFormat:@"%zd", annotationArray.count];
                    woooModel.indexKey = key;
                    mapAnnoModel.indexKey = key;
                    
                    [_pointDictionary setValue:[[NSMutableArray alloc] initWithObjects:woooModel, nil] forKey:key];
                    [locationArray addObject:woLocation];
                    [annotationArray addObject:mapAnnoModel];
                }
            }
            self.mapPointArray = annotationArray;
        }
    }];
}

- (void)queryRecentWooo {
    PFQuery *query = [PFQuery queryWithClassName:kWoooObject];
    [query fromLocalDatastore];
    query.limit = 30;
    [query orderByDescending:kWoooCreateAtKey];
    [query fromPinWithName:kWoooObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            [Flurry logError:@"PARSE" message:@"QUERY Local Database" error:error];
        } else {
            NSMutableArray *points = [[NSMutableArray alloc] init];
            for (PFObject *woObject in objects) {
                PFGeoPoint *woPoint = woObject[kWoooLocationKey];
                NSDate *time = woObject[kWoooCreateAtKey];
                WoooModel *woooModel = [[WoooModel alloc] init];
                woooModel.location = [[CLLocation alloc] initWithLatitude:woPoint.latitude longitude:woPoint.longitude];
                woooModel.woooAt = [dateFormatter stringFromDate:time];
                woooModel.rate = [woObject[kWoooRateKey] integerValue];
                woooModel.isUpload = [woObject[kWoooIsUploadKey] boolValue];
                [points addObject:woooModel];
            }
            [_userHistoryArray removeAllObjects];
            [_userHistoryArray addObjectsFromArray:points];
            self.detailPointArray = points;
        }
    }];
}

- (void)queryMapPointDetails:(NSString *)indexKey {
    if (indexKey) {
        self.detailPointArray = [_pointDictionary objectForKey:indexKey];
    } else {
        self.detailPointArray = _userHistoryArray;
    }
    
}

@end
