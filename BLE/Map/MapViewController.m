//
//  MapViewController.m
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "MapViewController.h"
#import "FileManager.h"
#import "KilometerAnno.h"
#import "KilometerAnotationView.h"
#import "NetUtils.h"
#import "TSMessage.h"
@interface MapViewController ()
@property(strong,nonatomic) NetUtils* netUtils;
@property(assign,nonatomic)double maxlon;
@property(assign,nonatomic)double minlon;
@property(assign,nonatomic)double maxlat;
@property(assign,nonatomic)double minlat;
@end

@implementation MapViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"%@",_listPoint);
}

-(BOOL)justyfyLocationAndBackgroudRefresh{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [TSMessage showNotificationWithTitle:@"定位服务没有开启" subtitle:@"在 设置->隐私中开启定位服务" type:TSMessageNotificationTypeError];//定位服务没有开启   //在 设置->隐私中开启定位服务
        return NO;
    }
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] != UIBackgroundRefreshStatusAvailable) {
        [TSMessage showNotificationWithTitle:@"后台应用程序刷新没有开启" subtitle:@"设置->通用->后台应用程序刷新 开启服务" type:TSMessageNotificationTypeError];//后台应用程序刷新没有开启   设置->通用->后台应用程序刷新 开启服务
        return NO;
    }
    return YES;
}


-(void)resetMaxMin{
    _maxlat = -90.0;
    _minlat = 90.0;
    _maxlon = -180.0;
    _minlon = 180.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_listPoint);
    NSMutableArray* point2draw = [NSMutableArray arrayWithArray:_listPoint];
    [self.tabBarController.tabBar setHidden:YES];
    [_mapView initBasicData];
 
    _mapView.showsUserLocation = NO;
    _mapView.userInteractionEnabled = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.rotateEnabled = NO;
    _mapView.delegate  = self;
    [_mapView setMFlag:1];
    [self resetMaxMin];// 
    _netUtils = [[NetUtils alloc] init];
    
    __unsafe_unretained MapViewController *vc = self;
    _listPoint = [NSMutableArray new];
   __block double totalDistance = 0;// 累积的距离
 
        [point2draw enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if (idx >=1) {

            NSDictionary* prePoint =point2draw[idx-1];
            
            double la1 = [prePoint[@"gps_lat"] doubleValue];
            double lo1 = [prePoint[@"gps_lng"] doubleValue];

            
            double la2 =  [obj[@"gps_lat"] doubleValue];
            double lo2 = [obj[@"gps_lng"] doubleValue];
                NSLog(@"%f,%f,%f,%f",la1,lo1,la2,lo2);
                
                //第一个坐标
                CLLocation *current=[[CLLocation alloc] initWithLatitude:la1 longitude:lo1];
                //第二个坐标
                CLLocation *before=[[CLLocation alloc] initWithLatitude:la2 longitude:lo2];
                // 计算距离
                CLLocationDistance meters=[current distanceFromLocation:before];
                NSLog(@"%f",meters);
                totalDistance +=meters;
                
                
                if(_maxlon < lo2)
                    _maxlon = lo2;
                if(_minlon > lo2)
                    _minlon = lo2;
                if (_maxlat < la2)
                    _maxlat = la2;
                if (_minlat > la2)
                    _minlat = la2;

                
            }
            NSLog(@"%f",totalDistance);
           
            
            
            NSLog(@"%f,%f,%f,%f",_maxlat,_maxlon,_minlat,_minlon);
            CLLocation* leftbottom = [[CLLocation alloc] initWithLatitude:_minlat longitude:_minlon];
            CLLocation* rightbottom = [[CLLocation alloc] initWithLatitude:_minlat longitude:_maxlon];
            CLLocationDistance distance_w = [rightbottom distanceFromLocation:leftbottom];
            
            CLLocation* lefttop = [[CLLocation alloc] initWithLatitude:_maxlat longitude:_minlon];
            CLLocationDistance distance_h = [lefttop distanceFromLocation:leftbottom];
            
            NSDictionary* dict = @{@"LATITUDE_A": obj[@"gps_lat"],@"LONGITUDE_A":obj[@"gps_lng"],@"SECTION":@"1",@"centerGPS":[NSString stringWithFormat:@"%f,%f,%f,%f",(_maxlon+_minlon)/2,(_maxlat+_minlat)/2,distance_w,distance_h],@"DISTANCE":[NSString stringWithFormat:@"%f",totalDistance]};
            [vc.listPoint addObject:dict];
            
            _mapView.centerGps = CLLocationCoordinate2DMake((_maxlat+_minlat)/2,(_maxlon+_minlon)/2);
            _mapView.r_logitude = distance_w /1000;
            _mapView.r_latitude = distance_h /1000;
            
        }];
        [vc.mapView updateMap:vc.listPoint];
        [vc.mapView addKMAnno];

    
    
    
/*
    NSString* fileName = [NSString stringWithFormat:@"%@_display.rtf",@"254990"];
    
    FileManager* fm = [FileManager sharedManager];
    NSLog(@"%@",[fm fileName:fileName]);
    NSData* data = [NSData dataWithContentsOfFile:[fm fileName:fileName]];
 
    
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",dict);
    NSString* map_w = [dict objectForKey:@"map_w"];
    NSString* map_h = [dict objectForKey:@"map_h"];
    NSString* gps =[dict objectForKey:@"center_gps"];
    
    // NSLog(@"%@ %@ %@",map_w,map_h,gps);
    
    NSArray* array = [gps componentsSeparatedByString:@","];
    
    if (array.count > 1)
    {
        _mapView.centerGps = CLLocationCoordinate2DMake([[array objectAtIndex:1] doubleValue], [[array objectAtIndex:0] doubleValue]);
        _mapView.r_logitude = [map_w doubleValue];
        _mapView.r_latitude = [map_h doubleValue];
        [_mapView setCenterLocation];
    }

    NSLog(@"%@",[self convertStringToArray:dict[@"data"]]);
    [_mapView updateMap :[self convertStringToArray:dict[@"data"]]];

    [_mapView addKMAnno];
     // Do any additional setup after loading the view.
 */
}

-(NSMutableArray*)convertStringToArray:(NSString*)str{
    if (str ==nil) {
        return nil;
    }
    //LATITUDE#LONGITUDE#LATITUDE_A#LONGITUDE_A#SPEED#ALTITUDE#SECTION#DISTANCE#HEARTRATE#INTERVAL|
    NSArray* array = [str componentsSeparatedByString:@"|"];
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i<array.count;i++)
    {
        NSString * obj = [array objectAtIndex:i];
        NSArray* tem = [obj componentsSeparatedByString:@"#"];// 容错保护
        if (tem!=nil && tem.count>1) {
            // NSLog(@"111%@",tem);
            NSString* cadence = nil;
            if (tem ==nil || tem.count <11) { // 这里容错保护一下，否则以前的活动没有这个字段会崩溃
                cadence = @"0";
            }
            else{
                cadence =[tem objectAtIndex:10];
            }
            NSDictionary* dict = @{@"LATITUDE": [tem objectAtIndex:0],@"LONGITUDE": [tem objectAtIndex:1],@"LATITUDE_A": [tem objectAtIndex:2],@"LONGITUDE_A": [tem objectAtIndex:3],@"SECTION": [tem objectAtIndex:6],@"SPEED":[tem objectAtIndex:4],@"ALTITUDE":[tem objectAtIndex:5],@"DISTANCE":[tem objectAtIndex:7],@"HEARTRATE":[tem objectAtIndex:8],@"INTERVAL":[tem objectAtIndex:9],@"CADENCE":cadence}; // 这里再加一个字段
            [newArray addObject:dict];
            
        }
    }
    return newArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"123123");
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
}

#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]] ){
        
        ((MKUserLocation *)annotation).title =@"myLocation"; //@"我的位置";
        //  ((MKUserLocation *)annotation).subtitle = @"中关村东路66号";
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKAnnotationView* pinView = (MKAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if (!pinView)
        {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyCustomAnnotation"];
            
            if ([[annotation title] isEqualToString:@"起点"]) {//起点
                
                customPinView.image = [UIImage imageNamed:@"map_start.png"];
            }
            
            else if ([[annotation title] isEqualToString:@"终点"]){//终点
                
                customPinView.image = [UIImage imageNamed:@"map_end.png"];
            }
            
            else{
                //customPinView.pinColor = MKPinAnnotationColorPurple;
            }
            
            customPinView.canShowCallout = YES;
            return customPinView;
        }
        else{
            if ([[annotation title] isEqualToString:@"起点"]) {// 起点
                
                pinView.image = [UIImage imageNamed:@"map_start.png"];
            }
            
            else if ([[annotation title] isEqualToString:@"终点"]){ //终点
                
                pinView.image = [UIImage imageNamed:@"map_end.png"];
            }
            
            pinView.canShowCallout = YES;
            return pinView;
        }
        
    }
    else if ([annotation isKindOfClass:[KilometerAnno class]]){
        KilometerAnno *calloutAnnotation = (KilometerAnno *)annotation;
        
        KilometerAnotationView *annotationView = (KilometerAnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"KILOMETERVIEW"];
        if (!annotationView)
        {
            annotationView = [[KilometerAnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"KILOMETERVIEW"];
        }
        annotationView.canShowCallout = NO;
        //annotationView.image = [ UIImage imageNamed:@"km_bg"];
        annotationView.kmLabel.text = calloutAnnotation.content;
        return annotationView;
    }
    else
        return nil;
    
}




- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
    MKOverlayView* overlayView = nil;
    
    //if(overlay == _mapview.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if (_mapView.routeLineView) {
            [_mapView.routeLineView removeFromSuperview];
        }
        
        _mapView.routeLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        _mapView.routeLineView.fillColor = [UIColor redColor];
        _mapView.routeLineView.strokeColor = [UIColor redColor];
        _mapView.routeLineView.lineWidth = 5;
        
        overlayView = _mapView.routeLineView;
    }
    
    return overlayView;
}


-(void)dealloc{
    NSLog(@"地图页面销毁");
}
@end
