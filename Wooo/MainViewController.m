//
//  MainViewController.m
//  Wooo
//
//  Created by jhihguan on 2015/3/27.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "WoooViewController.h"

@interface MainViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) WoooViewController *woooViewController;
@property (nonatomic, strong) MapViewController *mapViewController;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _pageViewController.delegate = self;
    _pageViewController.view.backgroundColor = [UIColor clearColor];

    _woooViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WoooViewController"];
    _mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    NSArray *vcArray = @[_woooViewController];
    
    [_pageViewController setViewControllers:vcArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    _pageViewController.dataSource = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    CGRect pageViewRect = self.view.bounds;
    _pageViewController.view.frame = pageViewRect;
    [_pageViewController didMoveToParentViewController:self];
    
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[MapViewController class]]) {
        return nil;
    } else {
        return _mapViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[MapViewController class]]) {
        return _woooViewController;
    } else {
        return nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
