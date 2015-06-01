//
//  DeviceListViewController.h
//  BLE
//
//  Created by zkr on 6/1/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) IBOutlet UITableView* listTable;
@property(strong,nonatomic) NSArray* listData;

@end
