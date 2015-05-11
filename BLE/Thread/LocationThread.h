//
//  LocationThread.h
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import "CSqlite.h"
#import "CSPausibleTimer.h"
@interface LocationThread : NSThread <CLLocationManagerDelegate>{
    CSqlite *m_sqlite;

}



@property (nonatomic, retain) CLLocationManager* locationManager; // 定位对象

@property(strong,nonatomic) CSPausibleTimer* timer;  // 定时器

 
@property(strong,nonatomic) CLLocation* currentLocation; // 我当前的位置

@property (strong,nonatomic) CLGeocoder* myGeocoder;// 地理编码对象

@property (nonatomic, retain) NSMutableArray* points; // 临时收集点的数组

@property(strong,nonatomic) NSMutableArray* pointsToDraw;// 实际划线的点


+ (id)sharedManager;// 单例


#pragma  mark - 定位
-(void)initMapLocationObject;  // 初始化定位对象

    
#pragma  mark - 蓝牙

// 蓝牙连接的方法
-(void)initBlueTooth;

-(void)closeBlueToothConnect;//关闭蓝牙连接

@end
