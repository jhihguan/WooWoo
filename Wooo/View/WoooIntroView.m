//
//  WoooIntroView.m
//  Wooo
//
//  Created by jhihguan on 2015/3/28.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "WoooIntroView.h"
#import "LocationUtil.h"
#import "Constant.h"
#import <Flurry.h>

@implementation WoooIntroView {
    UIView *_introView;
}

- (void)setupIntroView {
    self.backgroundColor = [UIColor clearColor];
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.frame = frame;
    _introView = [[UIView alloc] initWithFrame:frame];
    _introView.backgroundColor = [UIColor clearColor];
    UIView *transView = [[UIView alloc] initWithFrame:frame];
    transView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    [_introView addSubview:transView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/2 - 70, frame.size.width - 20, 140)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"崩潰請長按畫面集氣哦~\n\n崩潰訊息需間隔五分鐘哦~\n\n◢▆▅▄▃-崩╰(〒皿〒)╯潰-▃▄▅▆◣";
    [_introView addSubview:titleLabel];
    
    UIButton *allowLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2 + 10, frame.size.height/2 + 80, 100, 40)];
    [allowLocationButton setTitle:@"授權位置" forState:UIControlStateNormal];
    [allowLocationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allowLocationButton addTarget:self action:@selector(userAllowLocation:) forControlEvents:UIControlEventTouchUpInside];
    allowLocationButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    allowLocationButton.layer.borderWidth = 1.0f;
    
    UIButton *notAllowLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2 - 110, frame.size.height/2 + 80, 100, 40)];
    notAllowLocationButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    notAllowLocationButton.layer.borderWidth = 1.0f;
    [notAllowLocationButton setTitle:@"同意授權" forState:UIControlStateNormal];
    [notAllowLocationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notAllowLocationButton addTarget:self action:@selector(userAllowLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_introView addSubview:allowLocationButton];
    [_introView addSubview:notAllowLocationButton];
    
    [self addSubview:_introView];
}

- (void)userAllowLocation:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"授權位置"]) {
        [Flurry logEvent:@"ALLOW LOC RIGHT"];
    } else {
        [Flurry logEvent:@"ALLOW LOC LEFT"];
    }
    [[LocationUtil sharedLocation] askForLocationPermission];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotificationTag];
    [self removeFromSuperview];
}

- (void)userNotAllowLocation {
    UIButton *cantNotAllowButton = [[UIButton alloc] initWithFrame:self.frame];
    cantNotAllowButton.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    cantNotAllowButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    cantNotAllowButton.titleLabel.numberOfLines = 0;
    cantNotAllowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cantNotAllowButton setTitle:@"請點擊同意位置授權~" forState:UIControlStateNormal];
    [cantNotAllowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cantNotAllowButton addTarget:self action:@selector(userAllowLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cantNotAllowButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
