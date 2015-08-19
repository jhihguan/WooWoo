//
//  WoooInfoTableViewCell.h
//  Wooo
//
//  Created by jhihguan on 2015/3/28.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoooInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;

@end
