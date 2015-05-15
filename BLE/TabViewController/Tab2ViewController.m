//
//  Tab2ViewController.m
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//
#import "Tab2ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CSPausibleTimer.h"
#define kServiceUUID           @"FFF0"
#define kCharacteristicUUID    @"FFF1"
@interface Tab2ViewController ()  <CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) CBCentralManager *centralManager;//中心设备管理器
@property (strong,nonatomic) NSMutableArray *peripherals;//连接的外围设备
@property (strong,nonatomic) CBPeripheral * peripheral;//外设
@property(strong,nonatomic) CSPausibleTimer* timer;  // 定时器
@property(assign,nonatomic) BOOL IS_CONNECTING;// 正在连接状态
@end
@implementation Tab2ViewController
-(IBAction)connect2device:(id)sender{
    
    _centralManager = nil;
    _centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    if ([_timer isPaused]) {
        [_timer start];
    }
}
-(IBAction)cancelConnect2Device:(id)sender{
    [_timer pause];
    if (_peripheral !=nil) {
        [_centralManager cancelPeripheralConnection:_peripheral];
    }
    _log.text = @"取消连接";
    [_signalStrengthen1 setImage:[UIImage imageNamed:@"signal_gray"]];
    [_signalStrengthen2 setImage:[UIImage imageNamed:@"signal_gray"]];
    [_signalStrengthen3 setImage:[UIImage imageNamed:@"signal_gray"]];
    _rssiLabel.text = @"信号强度";
    _distanceLabel.text = @"距离";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    SETTING_NAVGATION_STYLE
    self.title = @"蓝牙";
    [self.tabBarController.tabBar setHidden:NO];
    
    _timer =   [CSPausibleTimer timerWithTimeInterval:5 target:self selector:@selector(readBLRSSI) userInfo:nil repeats:YES];
    [_timer start];
    
}
// 定时器的方法
-(void)readBLRSSI{
    if (_peripheral !=nil) {
        [_peripheral readRSSI];
    }
}
#pragma  mark - RSSI
// 蓝牙RSSI计算距离
- (float)calcDistByRSSI:(int)rssi
{
    int iRssi = abs(rssi);
    if (iRssi>80) {
        return 0;
    }
    float power = (iRssi-59)/(10*2.0);
    return pow(10, power);
}
// 信号强度判断
-(void)signalStrengthenSetting:(int)rssi{
    if (rssi < 0 && rssi >-50) {
        [_signalStrengthen1 setImage:[UIImage imageNamed:@"signal"]];
        [_signalStrengthen2 setImage:[UIImage imageNamed:@"signal"]];
        [_signalStrengthen3 setImage:[UIImage imageNamed:@"signal"]];
    }
    else if (rssi < -50 && rssi > -80){
        [_signalStrengthen1 setImage:[UIImage imageNamed:@"signal"]];
        [_signalStrengthen2 setImage:[UIImage imageNamed:@"signal"]];
        [_signalStrengthen3 setImage:[UIImage imageNamed:@"signal_gray"]];
    }
    else if (rssi < -80)
    {
        [_signalStrengthen1 setImage:[UIImage imageNamed:@"signal_gray"]];
        [_signalStrengthen2 setImage:[UIImage imageNamed:@"signal_gray"]];
        [_signalStrengthen3 setImage:[UIImage imageNamed:@"signal_gray"]];
        
    }
    else{
        [_signalStrengthen1 setImage:[UIImage imageNamed:@"signal_gray"]];
        [_signalStrengthen2 setImage:[UIImage imageNamed:@"signal_gray"]];
        [_signalStrengthen3 setImage:[UIImage imageNamed:@"signal_gray"]];
    }
}
#pragma  mark - CBCentralManagerDelegate
//中心服务器状态更新后
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开.");
            [self writeToLog:@"蓝牙已打开."];
            //扫描外围设备
            //            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
            break;
            
        default:
            NSLog(@"此设备不支持BLE或未打开蓝牙功能.");
            [self writeToLog:@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备."];
            [_signalStrengthen1 setImage:[UIImage imageNamed:@"signal_gray"]];
            [_signalStrengthen2 setImage:[UIImage imageNamed:@"signal_gray"]];
            [_signalStrengthen3 setImage:[UIImage imageNamed:@"signal_gray"]];
            
            break;
    }
}
/**
 *  发现外围设备
 *
 *  @param central           中心设备
 *  @param peripheral        外围设备
 *  @param advertisementData 特征数据
 *  @param RSSI              信号质量（信号强度）
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    /*
     NSLog(@"%@",advertisementData);
     {
     kCBAdvDataIsConnectable = 1;
     }
     */
    // rssi强度 0~-50 Immediate
    // -50~-80 near
    // <-80   far
    int rssi = [RSSI intValue];
    if (rssi < -80) {
        [self writeToLog:@"连接失败，请重新连接"];
        [self cancelConnect2Device:nil];
        return;
    }
    else{
    _rssiLabel.text = [NSString stringWithFormat:@"%@",RSSI];

    [self signalStrengthenSetting:rssi];
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f米",[self calcDistByRSSI:rssi]];
    
    NSLog(@"信号强度: %@", [RSSI stringValue]);
    [self writeToLog:@"发现外围设备..."];
    //停止扫描
    [self.centralManager stopScan];
    //连接外围设备
    if (peripheral) {
        //添加保存外围设备，注意如果这里不保存外围设备（或者说peripheral没有一个强引用，无法到达连接成功（或失败）的代理方法，因为在此方法调用完就会被销毁
        if(![self.peripherals containsObject:peripheral]){
            [self.peripherals addObject:peripheral];
        }
        NSLog(@"开始连接外围设备...");
        [self writeToLog:@"开始连接外围设备..."];
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    }
}
//连接到外围设备
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接外围设备成功!");
    [self writeToLog:@"连接外围设备成功!"];
    //设置外围设备的代理为当前视图控制器
    peripheral.delegate=self;
    //外围设备开始寻找服务
    [peripheral discoverServices:nil];
    _peripheral = peripheral;
}
//连接外围设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接外围设备失败!");
    [self writeToLog:@"连接外围设备失败!"];
}
#pragma mark - CBPeripheral 代理方法
//外围设备寻找到服务后
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"已发现可用服务...");
    [self writeToLog:@"已发现可用服务..."];
    if(error){
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription);
        [self writeToLog:[NSString stringWithFormat:@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription]];
    }
    //遍历查找到的服务
    CBUUID *serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
        //        if([service.UUID isEqual:serviceUUID]){
        //            //外围设备查找指定服务中的特征
        //            [peripheral discoverCharacteristics:nil forService:service];
        //        }
    }
}
//外围设备寻找到特征后
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"已发现可用特征...");
    [self writeToLog:@"已发现可用特征..."];
    if (error) {
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
        [self writeToLog:[NSString stringWithFormat:@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription]];
    }
    //遍历服务中的特征
    CBUUID *serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    // if ([service.UUID isEqual:serviceUUID]) {
    for (CBCharacteristic *characteristic in service.characteristics) {
        // if ([characteristic.UUID isEqual:characteristicUUID]) {
        //情景一：通知
        /*找到特征后设置外围设备为已通知状态（订阅特征）：
         *1.调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
         *2.调用此方法会触发外围设备的订阅代理方法
         */
        NSLog(@"%@",characteristic.description);
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        //情景二：读取
        [peripheral readValueForCharacteristic:characteristic];
        if(characteristic.value){
            NSString *value=[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            if (value!=nil) {
                NSLog(@"读取到特征值：%@",value);
            }
        }
        // }
    }
    // }
}
//特征值被更新后      [peripheral setNotifyValue:YES forCharacteristic:characteristic];
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"收到特征更新通知...");
    [self writeToLog:@"收到特征更新通知..."];
    if (error) {
        NSLog(@"更新通知状态时发生错误，错误信息：%@",error.localizedDescription);
    }
    //给特征值设置新的值
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    if ([characteristic.UUID isEqual:characteristicUUID]) {
        if (characteristic.isNotifying) {
            if (characteristic.properties==CBCharacteristicPropertyNotify) {
                NSLog(@"已订阅特征通知.");
                [self writeToLog:@"已订阅特征通知."];
                return;
            }else if (characteristic.properties ==CBCharacteristicPropertyRead) {
                //从外围设备读取新值,调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
                [peripheral readValueForCharacteristic:characteristic];
            }
            
        }else{
            NSLog(@"停止已停止.");
            //  [self writeToLog:@"已停止."];
            //取消连接
            // [self.centralManager cancelPeripheralConnection:peripheral];
        }
    }
}
//更新特征值后（调用readValueForCharacteristic:方法或者外围设备在订阅后更新特征值都会调用此代理方法）
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"更新特征值时发生错误，错误信息：%@",error.localizedDescription);
        // [self writeToLog:[NSString stringWithFormat:@"更新特征值时发生错误，错误信息：%@",error.localizedDescription]];
        return;
    }
    if (characteristic.value) {
        NSLog(@"读写权限%lu",(unsigned long)characteristic.properties);
        NSString *value=[[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        if (value!=nil) {
            NSLog(@"读取到特征值：%@",value);
            [self writeToLog:[NSString stringWithFormat:@"读取到特征值：%@",value]];
        }
    }else{
        NSLog(@"未发现特征值.");
        [self writeToLog:@"未发现特征值."];
    }
    
    
    
    // 订阅
    NSMutableData* recieveData = [NSMutableData new];
    [recieveData appendData:characteristic.value];
    NSLog(@"%@",recieveData);
    [self writeToLog:[self hexStringFromNSData:recieveData]];
    
    
    
}
- (NSString *)hexStringFromNSData:(NSData *)data
{
    NSUInteger capacity = [data length] * 2;
    
    NSMutableString *string = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *dataBuffer = [data bytes];
    
    for (NSUInteger i = 0; i < [data length]; ++i)
    {
        [string appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
    }
    
    return string;
}
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"信号强度:%@",peripheral.RSSI);
    _rssiLabel.text = [NSString stringWithFormat:@"%@",peripheral.RSSI];
}
/*!
 *  @method peripheral:didReadRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *  @param RSSI			The current RSSI of the link.
 *  @param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    NSLog(@"信号强度:%@",RSSI);
    _rssiLabel.text = [NSString stringWithFormat:@"%@", RSSI];
}
#pragma mark - 属性
-(NSMutableArray *)peripherals{
    if(!_peripherals){
        _peripherals=[NSMutableArray array];
    }
    return _peripherals;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
/**
 *  记录日志
 *
 *  @param info 日志信息
 */
-(void)writeToLog:(NSString *)info{
    if (info ==nil) {
        return;
    }
    self.log.text=[NSString stringWithFormat:@"%@\r\n%@",self.log.text,info];
}
-(void)dealloc{
    NSLog(@"蓝牙界面销毁啦");
}
@end
