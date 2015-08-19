//
//  MapAnnotationData.h
//  Wooo
//
//  Created by jhihguan on 2015/3/20.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotationModel : MKAnnotationView<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSUInteger capacity;
@property (nonatomic, strong) NSString *indexKey;

- (CGSize)getImageSize;
- (UIFont *)getFontSize;
- (UIColor *)getBackgroundColor;
- (NSString *)getLabelText;
@end
