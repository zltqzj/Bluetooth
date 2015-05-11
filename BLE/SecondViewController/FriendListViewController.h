//
//  FriendListViewController.h
//  BLE
//
//  Created by zkr on 5/11/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^didSelectRow) (NSDictionary *rowDict);

@interface FriendListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(weak,nonatomic) IBOutlet UITableView* listTable;// 暂时不用了
@property(copy,nonatomic) didSelectRow blockDidSelect;

@end
