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
#import "MapPoint.h"
#import "FriendListViewController.h"
#import "SinoNetUtils.h"
#import "ProgressHUD.h"
static NSInteger const listYValue   = 55;


@interface Tab1ViewController () <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)   NSMutableArray* listData;
@property(strong,nonatomic) NetUtils* netUtils;
@property(strong,nonatomic)  NSMutableArray* annoArray;
@property(strong,nonatomic) FriendListViewController* friendVC;
@property(assign,nonatomic)  BOOL showingFriendList;
@property(strong,nonatomic) SinoNetUtils* sinoNetUtils;

@end

@implementation Tab1ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];

}


-(void)tapMap{
    if (_showingFriendList == YES) {
        [self friendsLocation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SETTING_NAVGATION_STYLE
    self.title = @"地图";
    _showingFriendList = NO;
    [self.tabBarController.tabBar setHidden:NO];
    _mapView.delegate = self;
    _mapView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap)];
    [_mapView addGestureRecognizer:tap];
//    [_listTable registerClass:[Tab1Cell class] forCellReuseIdentifier:@"Tab1Cell"];
//    _listTable.delegate = self;
//    _listTable.dataSource = self;
  
    __unsafe_unretained Tab1ViewController *vc = self;

    _listData = [NSMutableArray new];
 
    _annoArray = [[NSMutableArray alloc] initWithCapacity:0];

    _sinoNetUtils = [SinoNetUtils manager];
    
    [ProgressHUD show:@"正在查询……"];
    
    [_sinoNetUtils getLocatonList1WithUrl:GPS1_RESULT success:^(id returnData) {
       // NSLog(@"%@",returnData);
        vc.listData = [NSMutableArray arrayWithArray:returnData];
        
        [vc.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // 取每一项的第一个字典
            
            NSDictionary *dict = obj[0] ;
        

            CLLocationCoordinate2D lo = CLLocationCoordinate2DMake([dict[@"gps_lat"] doubleValue],[dict[@"gps_lng"] doubleValue]);
            
            MapPoint* mmp = [[MapPoint alloc] initWithCoordinate2D:lo];
            mmp.title =@"张三"; //dict[@""];
            mmp.subtitle = dict[@"time"];
            NSLog(@"%@",dict[@"time"]);
            [vc.annoArray addObject:mmp];
            
        }];
        [vc.mapView addAnnotations:vc.annoArray];
        [ProgressHUD showSuccess:nil];
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
        [ProgressHUD showError:nil];
    }];
    
    
    /*
    _netUtils = [NetUtils manager];
    
    [_netUtils GetContentWithUrl:GPS1_RESULT withSuccessBlock:^(id returnData) {
         //NSLog(@"%@",returnData);
        vc.listData = [NSMutableArray arrayWithArray:returnData];
        
        [vc.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // 取每一项的第一个字典
            NSDictionary *dict = obj[0];
            
            CLLocationCoordinate2D lo = CLLocationCoordinate2DMake([dict[@"gps_lat"] doubleValue],[dict[@"gps_lng"] doubleValue]);
          
            MapPoint* mmp = [[MapPoint alloc] initWithCoordinate2D:lo];
            mmp.title =@"张三"; //dict[@""];
            mmp.subtitle = dict[@"time"];
            [vc.annoArray addObject:mmp];
            
        }];
        [vc.mapView addAnnotations:vc.annoArray];
        //[vc.listTable reloadData];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    */
    
    
    
    //
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.915352,116.397105);
    //缩放比例
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    //确定要显示的区域
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
  //  NSLog(@"level%d",_zoom_level);
    [_mapView  setCenterCoordinate:coordinate zoomLevel:1 animated:NO];
    //让地图显示这个区域
    [_mapView setRegion:region animated:YES];
    
    
    // 导航栏右侧按钮
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame =CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"iconfont-man"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(friendsLocation) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
 // 朋友列表
    _friendVC = viewOnSb(@"FriendListViewController");
    _friendVC.view.frame = CGRectMake(SCREEN_WIDTH+10, listYValue, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_friendVC.view];
    
    _friendVC.blockDidSelect = ^(NSDictionary* dict){
        NSLog(@"%@",dict);
        [vc friendsLocation];//
    };
   
}

-(void)friendsLocation{
    
    if (_showingFriendList ==NO) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            _friendVC.view.frame = CGRectMake(100, listYValue, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        } completion:^(BOOL finished) {
            _showingFriendList = YES;
        }];
    }
    else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            _friendVC.view.frame = CGRectMake(SCREEN_WIDTH+10, listYValue, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        } completion:^(BOOL finished) {
            _showingFriendList = NO;
        }];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]] ){
        
        ((MKUserLocation *)annotation).title = @"我的位置";
        //  ((MKUserLocation *)annotation).subtitle = @"中关村东路66号";
        return nil;  //return nil to use default blue dot view
    }
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        
        static NSString* MapPointAnnoationIdentifer = @"mapPointAnnoationIdentifer";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:MapPointAnnoationIdentifer];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:MapPointAnnoationIdentifer];
            
            customPinView.pinColor = MKPinAnnotationColorRed;
            
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            // NSLog(@"副标题%@",[annotation subtitle]);
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            rightButton.frame = CGRectMake(0, 0, 44, 44);
            [rightButton addTarget:self action:@selector(showDetail:)forControlEvents:UIControlEventTouchUpInside];

            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else
        return nil;
    
}


-(void)showDetail:(id)sender{
    
    
}


// 点击anno触发的事件
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   
    
}

// 点击右侧annoView按钮处罚的事件
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   
    NSLog(@"annoSelected %@",view.annotation);//
    MapPoint* mmp = view.annotation;
    [_annoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //  NSLog(@"%@",obj);
        if ([obj isEqual:mmp]) {
            
            NSLog(@"%d,%@,%@", (int)idx,mmp.title,mmp.subtitle);
            *stop = YES;
            
            MapViewController* map = viewOnSb(@"MapViewController");
            
            NSArray* listPoint = _listData[idx];
            map.listPoint = [NSMutableArray arrayWithArray:listPoint];
            
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationController pushViewController:map animated:YES];
            
        }
    }];
    
}


/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}// Default is 1 if not implemented


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}



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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
*/


-(void)dealloc{
    NSLog(@"地图销毁");
    [ProgressHUD dismiss];
}
@end
