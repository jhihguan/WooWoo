//
//  MapViewModel.h
//  Wooo
//
//  Created by jhihguan on 2015/3/28.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class MapAnnotationModel;
@interface MapViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *detailPointArray;
@property (nonatomic, strong) NSMutableArray *allMapPointArray;
@property (nonatomic, strong) NSMutableArray *mapPointArray;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) MapAnnotationModel *pressPoint;

- (void)queryRecentWooo;
- (void)queryNearWooo;
- (void)queryNearWoooByPress:(CLLocation *)location;
- (void)queryMapPointDetails:(NSString *)indexKey;
@end
