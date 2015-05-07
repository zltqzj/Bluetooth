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
@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    [_mapView initBasicData];
    _mapView.showsUserLocation = YES;
    _mapView.userInteractionEnabled = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.rotateEnabled = NO;
    _mapView.delegate  = self;
    [_mapView setMFlag:1];

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

    [_mapView updateMap :[self convertStringToArray:dict[@"data"]]];

    [_mapView addKMAnno];
     // Do any additional setup after loading the view.
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
@end
