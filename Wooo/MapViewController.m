//
//  MapViewController.m
//  Wooo
//
//  Created by jhihguan on 2015/3/20.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotationModel.h"
#import "MapViewModel.h"
#import "Constant.h"
#import "WoooModel.h"
#import "WoooMapIntroView.h"
#import "WoooInfoTableViewCell.h"
#import <ASValueTrackingSlider.h>
#import <Flurry.h>
#import <FBKVOController.h>

@interface MapViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, ASValueTrackingSliderDataSource> {
    FBKVOController *_KVOController;
}

@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) MapAnnotationModel *pressLocation;
@property (nonatomic, strong) MapViewModel *viewModel;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *queryDistanceSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegment;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _KVOController = [FBKVOController controllerWithObserver:self];
    _viewModel = [[MapViewModel alloc] init];
    
    [self setupView];
    
    [self setupObserver];
    [_viewModel queryNearWooo];
    [Flurry logPageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_viewModel queryRecentWooo];
    [Flurry logEvent:@"Map View"];
}

- (void)setupView {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.minimumPressDuration = 0.6f;
    [_mapView addGestureRecognizer:longPressGestureRecognizer];
    
    _queryDistanceSlider.minimumValue = 10.0f;
    _queryDistanceSlider.maximumValue = 200.0f;
    _queryDistanceSlider.popUpViewCornerRadius = 5.0f;
    [_queryDistanceSlider setMaxFractionDigitsDisplayed:0];
    _queryDistanceSlider.dataSource = self;
    _queryDistanceSlider.value = [[[NSUserDefaults standardUserDefaults] valueForKey:kWoooRegionValue] floatValue];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNotificationMapTag]) {
        WoooMapIntroView *introView = [[WoooMapIntroView alloc] init];
        [introView setupIntroView];
        [self.view addSubview:introView];
    }
}


#pragma mark - tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WoooInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"woooInfoTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[WoooInfoTableViewCell alloc] init];
    }
    WoooModel *woooModel = [_viewModel.detailPointArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = woooModel.woooAt;
    if (woooModel.rate == 100) {
        cell.rateLabel.text = [NSString stringWithFormat:@"%zd", woooModel.rate];
    } else {
        cell.rateLabel.text = [NSString stringWithFormat:@"%zd%%", woooModel.rate];
    }
    cell.uploadImageView.hidden = !woooModel.isUpload;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.detailPointArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - gesture handle

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    [self.mapView removeAnnotation:self.pressLocation];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:_queryDistanceSlider.value] forKey:kWoooRegionValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [_viewModel queryNearWoooByPress:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
    [Flurry logEvent:@"Map Long Press"];
}

#pragma mark - mapview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation> )annotation {
    //    MKAnnotationView
    if ([annotation isKindOfClass:[MapAnnotationModel class]]) {
        static NSString *annotationIdentifier = @"MAP_ANNOTATION_VIEW";
        MKAnnotationView *annotateView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotateView) {
            annotateView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        } else {
            for (UIView *subview in annotateView.subviews) {
                [subview removeFromSuperview];
            }
        }
        MapAnnotationModel *data = (MapAnnotationModel *)annotation;
        CGSize viewSize = [data getImageSize];
        UIGraphicsBeginImageContextWithOptions(viewSize, NO, 0.0);
        UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        annotateView.image = blank;
        CGSize size = annotateView.image.size;
        UILabel *pplLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        pplLabel.font = [data getFontSize];
        pplLabel.textColor = [UIColor whiteColor];
        pplLabel.textAlignment = NSTextAlignmentCenter;
        pplLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        pplLabel.layer.borderWidth = 2.0f;
        pplLabel.layer.cornerRadius = size.width / 2.0f;
        pplLabel.clipsToBounds = YES;
        pplLabel.backgroundColor = [data getBackgroundColor];
        pplLabel.text = [data getLabelText];
        [annotateView addSubview:pplLabel];
        return annotateView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MapAnnotationModel class]]) {
        MapAnnotationModel *mapModel = (MapAnnotationModel *)view.annotation;
        [_viewModel queryMapPointDetails:mapModel.indexKey];
        [Flurry logEvent:@"Map Anno Pess"];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point = MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04 *[views indexOfObject:aV] options:UIViewAnimationOptionCurveEaseInOut animations:^{
            aV.frame = endFrame;
            
            // Animate squash
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
}

#pragma mark - slider datasource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    return [NSString stringWithFormat:@"%.0f km", value];
}

#pragma mark - segment value
- (IBAction)filterSegmentValueChangeAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}


#pragma mark - observer

- (void)setupObserver {
    [_KVOController observe:_viewModel keyPath:@"detailPointArray" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_tableView reloadData];
    }];
    
    [_KVOController observe:_viewModel keyPath:@"location" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        CLLocation *location = change[NSKeyValueChangeNewKey];
        [_mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000) animated:NO];
    }];
    
    [_KVOController observe:_viewModel keyPath:@"mapPointArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        [_mapView removeAnnotations:change[NSKeyValueChangeOldKey]];
        [_mapView addAnnotations:change[NSKeyValueChangeNewKey]];
    }];
    
    [_KVOController observe:_viewModel keyPath:@"pressPoint" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        [_mapView removeAnnotation:change[NSKeyValueChangeOldKey]];
        [_mapView addAnnotation:change[NSKeyValueChangeNewKey]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */
 
@end
