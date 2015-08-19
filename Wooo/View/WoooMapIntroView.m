//
//  WoooMapIntroView.m
//  Wooo
//
//  Created by jhihguan on 2015/5/20.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "WoooMapIntroView.h"
#import "Constant.h"

@implementation WoooMapIntroView {
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height/2)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"地圖上長按可以查詢哦~\n\n◢▆▅▄▃-崩╰(〒皿〒)╯潰-▃▄▅▆◣";
    [_introView addSubview:titleLabel];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, frame.size.height/2 + 80, frame.size.width - 20, 40)];
    [okButton setTitle:@"了解！！" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(userClickOk:) forControlEvents:UIControlEventTouchUpInside];
    okButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    okButton.layer.borderWidth = 1.0f;
    
    [_introView addSubview:okButton];
    
    [self addSubview:_introView];
    
}

- (void)userClickOk:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotificationMapTag];
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [_introView removeFromSuperview];
    [self setupIntroView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
