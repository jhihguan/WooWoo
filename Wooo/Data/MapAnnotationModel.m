//
//  MapAnnotationData.m
//  Wooo
//
//  Created by jhihguan on 2015/3/20.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "MapAnnotationModel.h"

@implementation MapAnnotationModel

//- (NSUInteger)capacity {
//    NSLog(@"%td", _capacity);
//    return _capacity;
//}

- (CGSize)getImageSize {
    if (_capacity == 0) {
        return CGSizeMake(25, 25);
    } else if (_capacity < 5) {
        return CGSizeMake(35, 35);
    } else if (_capacity < 20) {
        return CGSizeMake(45, 45);
    } else if (_capacity < 50) {
        return CGSizeMake(60, 60);
    } else {
        return CGSizeMake(80, 80);
    }
}

- (UIFont *)getFontSize {
    if (_capacity == 0) {
        return [UIFont systemFontOfSize:12.0f];
    } else if (_capacity < 5) {
        return [UIFont systemFontOfSize:16.0f];
    }else if (_capacity < 20) {
        return [UIFont systemFontOfSize:18.0f];
    } else if (_capacity < 50) {
        return [UIFont systemFontOfSize:24.0f];
    } else {
        return [UIFont systemFontOfSize:28.0f];
    }
}

- (NSString *)getLabelText {
    if (_capacity == 0) {
        return @"S";
    } else {
        return [NSString stringWithFormat:@"%td", _capacity];
    }
}

- (UIColor *)getBackgroundColor {
    if (_capacity == 0) {
        return [UIColor colorWithRed:0.147 green:0.280 blue:0.668 alpha:1.000];
    } else if (_capacity < 5) {
        return [UIColor colorWithRed:0.898 green:0.109 blue:0.137 alpha:1];
    } else if (_capacity < 20) {
        return [UIColor colorWithRed:0.913 green:0.117 blue:0.512 alpha:1.000];
    } else if (_capacity < 50) {
        return [UIColor colorWithRed:0.611 green:0.152 blue:0.69 alpha:1];
    } else {
        return [UIColor colorWithRed:0.835 green:0 blue:0.976 alpha:1];
    }
}

- (NSString *)imageName {
    if (_capacity == 0) {
        return @"userDrop";
    } else if (_capacity > 5) {
        return @"medWoo";
    } else if (_capacity > 10) {
        return @"highWoo";
    }
    
    return @"lowWoo";
}

- (NSString *)title {
    if (_capacity == 0) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%td崩潰", _capacity];
    }
}

@end
