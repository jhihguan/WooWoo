//
//  WoooModel.h
//  Wooo
//
//  Created by jhihguan on 2015/3/27.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WoooModel : NSObject

@property CLLocation *location;
@property NSString *woooAt;
@property NSInteger rate;
@property BOOL isUpload;
@property NSString *indexKey;

@end
