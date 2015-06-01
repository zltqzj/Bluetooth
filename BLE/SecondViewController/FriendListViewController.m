//
//  FriendListViewController.m
//  BLE
//
//  Created by zkr on 5/11/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "FriendListViewController.h"
#import "MJRefresh.h"
@interface FriendListViewController ()
@property(strong,nonatomic)   NSMutableArray* listData;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_listTable registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"UITableViewCell"];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listData = [NSMutableArray new];
    [_listData addObject:@"张三"];
    [_listData addObject:@"李四"];

    [_listData addObject:@"王五"];

    [_listData addObject:@"赵六"];
    [_listData addObject:@"李瑞卿"];

    
    _listTable.tableFooterView = [UIView new];
    
    __unsafe_unretained FriendListViewController* vc = self;
    
    
    // 添加传统的下拉刷新
//    [_listTable addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [vc.listTable.header endRefreshing];
//    }];
    
    // 马上进入刷新状态
   // [_listTable.header beginRefreshing];
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    cell.textLabel.text = _listData[row];
    //NSArray* listPoint = _listData[row];
    // tab1cell.titleLabel.text = valueToString(row); //dict[@"title"];
    // tab1cell.detailLabel.text =listPoint[0][@"time"]; //dict[@"detail"];
    // tab1cell.avatarImageView.image   = [UIImage imageNamed:@"pin"];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSDictionary* dict = @{@"row": valueToString(row)};
    _blockDidSelect(dict);
    
    //
    // MapViewController* map = viewOnSb(@"MapViewController");
    // NSArray* listPoint = _listData[row];
    // map.listPoint = [NSMutableArray arrayWithArray:listPoint];
    //
    // [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // [self.navigationController pushViewController:map animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)dealloc{
    NSLog(@"好友界面销毁");
   
}

@end
