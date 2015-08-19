//
//  WoooViewModel.h
//  Wooo
//
//  Created by jhihguan on 2015/3/27.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoooViewModel : NSObject

@property (nonatomic) double rate;
@property (nonatomic, strong) NSString *woooButtonText;
@property (nonatomic, strong) NSString *statusMessage;

- (void)saveWooo;
- (void)longPressStart;
- (void)longPressEnd;

@end
