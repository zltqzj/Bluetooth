//
//  HRMViewController.m
//  HeartMonitor
//
//  Created by Steven F. Daniel on 30/11/13.
//  Copyright (c) 2013 GENIESOFT STUDIOS. All rights reserved.
//

#import "HRMViewController.h"
#import "AppDelegate.h"

@interface HRMViewController ()

@end

@implementation HRMViewController

- (void)startfind
{
	// Do any additional setup after loading the view, typically from a nib.
	self.polarH7DeviceData = nil;
    _laststate = 0;
	_connected = @"";
    _centralManager = nil;
	// Scan for all available CoreBluetooth LE devices
	
	CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
  	self.centralManager = centralManager;
}

-(void)stopfind
{
    if((_polarH7HRMPeripheral!=nil)&&(![_connected isEqualToString:@""] ))
    {
        [_centralManager cancelPeripheralConnection:_polarH7HRMPeripheral];
        _polarH7HRMPeripheral = nil;
    }
    NSDictionary* dict = @{@"state": /*@"未连接"*/ @"disconnect"};
    AppDelegate*   delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
    [delegate performSelectorOnMainThread:@selector(getBlueToothState:) withObject:dict waitUntilDone:NO];
    _centralManager = nil;
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	// Determine the state of the peripheral
	if ([central state] == CBCentralManagerStatePoweredOff) {
		NSLog(@"CoreBluetooth BLE hardware is powered off");
        _laststate = CBCentralManagerStatePoweredOff;
	}
	else if ([central state] == CBCentralManagerStatePoweredOn) {
		NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        if (_laststate == CBCentralManagerStatePoweredOff)
        {
            //            if(self.centralManager!=nil){
            //                self.centralManager = nil;
            //                NSArray *services = @[[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]];
            //                CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
            //                [centralManager scanForPeripheralsWithServices:services options:nil];
            //                self.centralManager = centralManager;
            //            }
        }
        NSArray *services = @[[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]];
        [self.centralManager scanForPeripheralsWithServices:services options:nil];
        
        _laststate = CBCentralManagerStatePoweredOn;
        NSDictionary* dict = @{@"state": /*@"查找..."*/@"bluetooth_searching"};
        AppDelegate*   delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
        [delegate performSelectorOnMainThread:@selector(getBlueToothState:) withObject:dict waitUntilDone:NO];
	}
	else if ([central state] == CBCentralManagerStateUnauthorized) {
		NSLog(@"CoreBluetooth BLE state is unauthorized");
	}
	else if ([central state] == CBCentralManagerStateUnknown) {
		NSLog(@"CoreBluetooth BLE state is unknown");
	}
	else if ([central state] == CBCentralManagerStateUnsupported) {
		NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
	}
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //设备失去连接 通知给开始界面！
    NSDictionary* dict = @{@"state": /*@"已连接"*/@"connect"};
    AppDelegate*   delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
    [delegate performSelectorOnMainThread:@selector(disconnectBLE:) withObject:dict waitUntilDone:NO];
}

// method called whenever we have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	[peripheral setDelegate:self];
    [peripheral discoverServices:nil];
	self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSDictionary* dict = @{@"state": /*@"已连接"*/@"connect"};
    AppDelegate*   delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
    [delegate performSelectorOnMainThread:@selector(getBlueToothState:) withObject:dict waitUntilDone:NO];
}

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
		[peripheral discoverCharacteristics:nil forService:service];
	}
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
	if (![localName isEqual:@""]) {
		// We found the Heart Rate Monitor
        NSLog(@"%@",localName);
		[self.centralManager stopScan];
		self.polarH7HRMPeripheral = peripheral;
		peripheral.delegate = self;
		[self.centralManager connectPeripheral:peripheral options:nil];
	}
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]])  {  // 1
		for (CBCharacteristic *aChar in service.characteristics)
		{
			// Request heart rate notifications
			if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_NOTIFICATIONS_SERVICE_UUID]]) { // 2
				[self.polarH7HRMPeripheral setNotifyValue:YES forCharacteristic:aChar];
			}
			// Request body sensor location
			else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_UUID]]) { // 3
				[self.polarH7HRMPeripheral readValueForCharacteristic:aChar];
			}
            //			else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_ENABLE_SERVICE_UUID]]) { // 4
            //				// Read the value of the heart rate sensor
            //				UInt8 value = 0x01;
            //				NSData *data = [NSData dataWithBytes:&value length:sizeof(value)];
            //				[peripheral writeValue:data forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
            //			}
		}
	}
	// Retrieve Device Information Services for the Manufacturer Name
	if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID]])  { // 5
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_UUID]]) {
                [self.polarH7HRMPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Manufacturer Name Characteristic");
            }
        }
	}
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	// Updated value for heart rate measurement received
	if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_NOTIFICATIONS_SERVICE_UUID]]) { // 1
		// Get the Heart Rate Monitor BPM
		[self getHeartBPMData:characteristic error:error];
	}
	// Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_UUID]]) {  // 2
		[self getManufacturerName:characteristic];
    }
	// Retrieve the characteristic value for the body sensor location received
	else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_UUID]]) {  // 3
		[self getBodyLocation:characteristic];
    }
	
}

// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
	// Get the Heart Rate Monitor BPM
	NSData *data = [characteristic value];      // 1
	const uint8_t *reportData = [data bytes];
	uint16_t bpm = 0;
	
    NSLog(@"%d %d  %d",reportData[0],reportData[1],reportData[2]);
    
	if ((reportData[0] & 0x01) == 0) {          // 2
		// Retrieve the BPM value for the Heart Rate Monitor
		bpm = reportData[1];
        NSDictionary* dict = @{@"state": [NSString stringWithFormat:@"%@次/分钟",valueToString(bpm)]};
        AppDelegate*   delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
        [delegate performSelectorOnMainThread:@selector(getBlueToothState:) withObject:dict waitUntilDone:NO];
	}
	else {
		bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));  // 3
	}
	// Display the heart rate value to the UI if no error occurred
	if( (characteristic.value)  || !error ) {   // 4
		self.heartRate = bpm;
        NSLog(@"current heartbeat is %d",self.heartRate);
        //[self doHeartBeat];
		//self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
	}
	return;
}

// Instance method to get the manufacturer name of the device
- (void) getManufacturerName:(CBCharacteristic *)characteristic
{
	NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
	self.manufacturer = [NSString stringWithFormat:@"Manufacturer: %@", manufacturerName];
	return;
}

// Instance method to get the body location of the device
- (void) getBodyLocation:(CBCharacteristic *)characteristic
{
	NSData *sensorData = [characteristic value];
	uint8_t *bodyData = (uint8_t *)[sensorData bytes];
	if (bodyData ) {
		uint8_t bodyLocation = bodyData[0];
		self.bodyData = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"];
	}
	else {
		self.bodyData = [NSString stringWithFormat:@"Body Location: N/A"];
	}
	return;
}

// instance method to stop the device from rotating - only support the Portrait orientation
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
}

// instance method to simulate our pulsating Heart Beat
//- (void) doHeartBeat
//{
//	CALayer *layer = [self heartImage].layer;
//	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//	pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
//	pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//
//	pulseAnimation.duration = 60. / self.heartRate / 2.;
//	pulseAnimation.repeatCount = 1;
//	pulseAnimation.autoreverses = YES;
//	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//	[layer addAnimation:pulseAnimation forKey:@"scale"];
//
//	self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
//}


@end