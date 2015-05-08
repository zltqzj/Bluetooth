//
//  LocationThread.m
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "LocationThread.h"
#import "CLLocationManager+Block.h"
#import "KANullInputSource.h"

@implementation LocationThread


- (void)main {   // 线程启动
    NSLog(@"线程启动");
   
    
     [[[KANullInputSource alloc] init] addToCurrentRunLoop] ;
    _timer =   [CSPausibleTimer timerWithTimeInterval:5 target:self selector:@selector(searhJPGandUpload) userInfo:nil repeats:YES];
    [_timer start];
    [self initMapLocationObject]; // 初始化定位对象

    while (!self.isCancelled) {
        BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"after runloop counting.........: %d", ret);
    }
    
}

-(void)searhJPGandUpload{
    NSLog(@"1111");
}

// 单例方法得到线程的对象
+ (id)sharedManager {
    static LocationThread *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [sharedMyManager start];
    });
    return sharedMyManager;
}


#pragma  mark - 定位

-(void)initMapLocationObject{  // 初始化定位对象
  
    _locationManager = [CLLocationManager sharedManager];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest; // 最高精度
    _locationManager.distanceFilter  = 5.0f;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    [_locationManager dismissHeadingCalibrationDisplay];
    if(IS_OS_8_OR_LATER) {
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager performSelector:@selector(requestAlwaysAuthorization)];
        }
    }
   // [_locationManager startUpdatingLocation];

    
}



// 关闭GPS定位
-(void)closeGPSLocation{
    [_locationManager stopUpdatingLocation];
}

#pragma  mark - 蓝牙
// 蓝牙连接的方法
-(void)initBlueTooth{
    [_pbl startfind];

}

-(void)closeBlueToothConnect//关闭蓝牙连接
{
    [_pbl stopfind];
}


#pragma  mark - 定位的代理方法 CLLocationManagerDelegate

//locationManagerShouldDisplayHeading
-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    [manager dismissHeadingCalibrationDisplay];
    return NO;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    // NSLog(@"改变权限");
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    NSLog(@"%@",locations);
    
    
}

@end
