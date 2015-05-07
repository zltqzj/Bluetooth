//
//  HRMViewController.h
//  HeartMonitor
//
//  Created by Steven F. Daniel on 30/11/13.
//  Copyright (c) 2013 GENIESOFT STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <QuartzCore/QuartzCore.h>


#define POLARH7_HRM_DEVICE_INFO_SERVICE_UUID @"180A"       // 180A = Device Information
#define POLARH7_HRM_HEART_RATE_SERVICE_UUID @"180D"        // 180D = Heart Rate Service
#define POLARH7_HRM_ENABLE_SERVICE_UUID @"2A39"
#define POLARH7_HRM_NOTIFICATIONS_SERVICE_UUID @"2A37"
#define POLARH7_HRM_BODY_LOCATION_UUID @"2A38"
#define POLARH7_HRM_MANUFACTURER_NAME_UUID @"2A29"

//6217FF49-AC7B-547E-EECF-016A06970BA9

@interface HRMViewController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *polarH7HRMPeripheral;

@property (assign,nonatomic) CBCentralManagerState laststate;

// Properties to hold data characteristics for the peripheral device
@property (nonatomic, strong) NSString   *connected;
@property (nonatomic, strong) NSString   *bodyData;
@property (nonatomic, strong) NSString   *manufacturer;
@property (nonatomic, strong) NSString   *polarH7DeviceData;
@property (assign,nonatomic) uint16_t heartRate;


// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)startfind;
-(void)stopfind;

// Instance methods to grab device Manufacturer Name, Body Location
- (void) getManufacturerName:(CBCharacteristic *)characteristic;
- (void) getBodyLocation:(CBCharacteristic *)characteristic;

// Instance method to perform heart beat animations
- (void) doHeartBeat;

@end