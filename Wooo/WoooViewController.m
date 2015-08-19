//
//  ViewController.m
//  Wooo
//
//  Created by jhihguan on 2015/3/19.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "WoooViewController.h"
#import "MapViewController.h"
#import "WoooViewModel.h"
#import "WoooIntroView.h"
#import "Constant.h"

@interface WoooViewController ()<UIAlertViewDelegate>{
    FBKVOController *_KVOController;
    WoooViewModel *_viewModel;
    NSDate *_longPressDate;
    CGSize _coverSize;
}

@property (weak, nonatomic) IBOutlet UIButton *woooooButton;
@property (strong, nonatomic) UIImageView *powerImageView;
@property (strong, nonatomic) UIView *powerCoverView;
@property (nonatomic, strong) UILabel *powerRateLabel;
@property (nonatomic, strong) WoooIntroView *introView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation WoooViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[WoooViewModel alloc] init];
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    [self setupObserver];
    
    [self setupView];
    
}

- (void)setupView {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.minimumPressDuration = 0.6f;
    [_woooooButton addGestureRecognizer:longPressGestureRecognizer];
    
    _powerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userPower"]];
    _powerCoverView = [[UIView alloc] init];
    _powerCoverView.backgroundColor = [UIColor blackColor];
    _powerRateLabel = [[UILabel alloc] init];
    _powerRateLabel.text = @" 0%";
    _powerRateLabel.font = [UIFont systemFontOfSize:10.0f];
    _powerRateLabel.textColor = [UIColor whiteColor];
    _powerRateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_powerImageView];
    [self.view addSubview:_powerCoverView];
    [self.view addSubview:_powerRateLabel];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNotificationTag]) {
        _introView = [[WoooIntroView alloc] init];
        [self firstIntro];
    }
}

#pragma mark - observer

- (void)setupObserver {
    [_KVOController observe:_viewModel keyPath:@"woooButtonText" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_woooooButton setTitle:change[NSKeyValueChangeNewKey] forState:UIControlStateNormal];
        CGRect frame = [[UIScreen mainScreen] bounds];
        if (_introView) {
            [_introView removeFromSuperview];
            [self firstIntro];
        }
        _powerImageView.frame = CGRectMake(16, frame.size.height/2-100, 20, 200);
        _coverSize = _powerImageView.frame.size;
        CGRect coverFrame = _powerCoverView.frame;
        coverFrame.origin = CGPointMake(16, frame.size.height/2 - 100);
        if (_powerCoverView.frame.size.width == 0) {
            coverFrame.size = _coverSize;
        }
        _powerCoverView.frame = coverFrame;
        _powerRateLabel.frame = CGRectMake(10, coverFrame.origin.y + coverFrame.size.height - 20, _coverSize.width + 10, 20);
    }];
    
    [_KVOController observe:_viewModel keyPath:@"rate" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        CGFloat rate = [change[NSKeyValueChangeNewKey] doubleValue];
        CGRect frame = _powerImageView.frame;
        CGFloat height = _coverSize.height - rate*2;
        _powerCoverView.frame = CGRectMake(frame.origin.x, frame.origin.y, _coverSize.width, height);
        _powerRateLabel.text = [NSString stringWithFormat:@"%d%%", (int)rate];
        _powerRateLabel.frame = CGRectMake(frame.origin.x, frame.origin.y + height - 20, _coverSize.width + 10, 20);
    }];
    
    [_KVOController observe:_viewModel keyPath:@"statusMessage" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        _messageLabel.hidden = NO;
        _messageLabel.text = change[NSKeyValueChangeNewKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _messageLabel.hidden = YES;
        });
    }];
}

#pragma mark - gesture recognizer

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [_viewModel longPressStart];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [_viewModel longPressEnd];
    }
}

#pragma mark - intro function

- (void)firstIntro {
    [_introView setupIntroView];
    [self.view addSubview:_introView];
}


#pragma mark - life cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
