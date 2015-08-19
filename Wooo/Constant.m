//
//  Constant.m
//  Wooo
//
//  Created by jhihguan on 2015/3/27.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "Constant.h"

@implementation Constant

#ifdef DEV
#define WO_OBJECT @"WoWooDev"
#else
#define WO_OBJECT @"WoWoo"
#endif

NSString *const kWoooObject = WO_OBJECT;
NSString *const kLastWoooTime = @"LAST_WOOO_TIME";
NSString *const kLastWoooLatitude = @"LAST_WOOO_LATITUDE";
NSString *const kLastWoooLongitude = @"LAST_WOOO_LONGITUDE";
NSString *const kNotificationTag = @"NOTIFY_2.01";
NSString *const kNotificationMapTag = @"NOTIFY_MAP_2.01";
NSString *const kPortraitButtonText = @"崩潰";
NSString *const kLandscapeButtonText = @"╰(崩〒潰)╯";
NSString *const kWoooCreateAtKey = @"woooooAt";
NSString *const kWoooLocationKey = @"location";
NSString *const kWoooIsUploadKey = @"isUpload";
NSString *const kWoooRateKey = @"rate";
NSString *const kWoooSuccessMessage = @"崩潰成功 (╯≧▽≦)╯ ~╩═══╩";
NSString *const kWoooFailMessage = @"網路異常 ( ￣ c￣)y▂▂▂ξ";
NSString *const kWoooRegionValue = @"WOOO_SEARCH_DISTANCE";

@end
