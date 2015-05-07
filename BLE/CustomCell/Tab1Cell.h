//
//  Tab1Cell.h
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab1Cell : UITableViewCell

@property(weak,nonatomic) IBOutlet UILabel* titleLabel;
@property(weak,nonatomic) IBOutlet UILabel* detailLabel;
@property(weak,nonatomic) IBOutlet UIImageView* avatarImageView;

@end
