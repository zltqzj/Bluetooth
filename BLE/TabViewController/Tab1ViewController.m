//
//  Tab1ViewController.m
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "Tab1ViewController.h"
#import "Tab1Cell.h"
#import "MapViewController.h"
#import "NetUtils.h"

@interface Tab1ViewController () <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)   NSMutableArray* listData;
@property(strong,nonatomic) NetUtils* netUtils;

@end

@implementation Tab1ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    SETTING_NAVGATION_STYLE
    self.title = @"首页";
    [self.tabBarController.tabBar setHidden:NO];

    [_listTable registerClass:[Tab1Cell class] forCellReuseIdentifier:@"Tab1Cell"];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    NSDictionary* dict1 = @{@"url": @"",@"title":@"the first line",@"detail":@"none"};
    NSDictionary* dict2 = @{@"url": @"",@"title":@"the second line",@"detail":@"none"};
    NSDictionary* dict3 = @{@"url": @"",@"title":@"the third line",@"detail":@"none"};
    __unsafe_unretained Tab1ViewController *vc = self;

    _listData = [NSMutableArray new];
 
 
    _netUtils = [[NetUtils alloc] init];
    [_netUtils GetContentWithUrl:GPS1_RESULT withSuccessBlock:^(id returnData) {
         //NSLog(@"%@",returnData);
        
        vc.listData = [NSMutableArray arrayWithArray:returnData];
        [vc.listTable reloadData];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}// Default is 1 if not implemented


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tab1Cell* tab1cell = [tableView dequeueReusableCellWithIdentifier:@"Tab1Cell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;

    NSArray* listPoint = _listData[row];
    tab1cell.titleLabel.text = valueToString(row); //dict[@"title"];
    tab1cell.detailLabel.text =listPoint[0][@"time"]; //dict[@"detail"];
    tab1cell.avatarImageView.image   = [UIImage imageNamed:@"pin"];
    return tab1cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    MapViewController* map = viewOnSb(@"MapViewController");
    NSArray* listPoint = _listData[row];
    map.listPoint = [NSMutableArray arrayWithArray:listPoint];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:map animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

@end
