//
//  DeviceListViewController.m
//  BLE
//
//  Created by zkr on 6/1/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "DeviceListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Tab2ViewController.h"
#import "CBCentralManager+Blocks.h"
#import "CBPeripheral+Debug.h"
#import "PeripheralCell.h"
@interface DeviceListViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) CBCentralManager *centralManager;//中心设备管理器
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) NSMutableArray *RSSIs;
@property (nonatomic, getter = isScanning) BOOL scanning;
@end

@implementation DeviceListViewController


-(void)dealloc{
    NSLog(@"设备列表销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"外设列表";
    _centralManager=[[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    [_listTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
   
    
    self.peripherals = [NSMutableArray new];
    self.RSSIs = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.listTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PeripheralCell"];
    
//    if (!self.isScanning) {
//        [self.peripherals removeAllObjects];
//        [self.RSSIs removeAllObjects];
//        [self.listTable reloadData];
//        [[CBCentralManager defaultManager] scanForPeripheralsWithServices:nil options:nil didDiscover:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//            [weakSelf addPeripheral:peripheral RSSI:RSSI];
//            [weakSelf.listTable reloadData];
//
//        }];
//        weakSelf.scanning = YES;
//
//    }
//    else {
//        [[CBCentralManager defaultManager] stopScanAndRemoveHandler];
//       
//        weakSelf.scanning = NO;
//    }

    
    
    // Do any additional setup after loading the view.
}

- (void)addPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
    if (![self.peripherals containsObject:peripheral]) {
       
        [self.peripherals addObject:peripheral];
        [self.RSSIs addObject:RSSI];
       
    }
}


-(NSMutableArray *)peripherals{
    if(!_peripherals){
        _peripherals=[NSMutableArray array];
    }
    return _peripherals;
}

//中心服务器状态更新后
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开.");
            //[self writeToLog:@"蓝牙已打开."];
            //扫描外围设备
            //            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
            
        default:
            NSLog(@"此设备不支持BLE或未打开蓝牙功能.");
          //  [self writeToLog:@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备."];
            
            
            break;
    }
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    [self.centralManager stopScan];
  
    if (peripheral) {
        //添加保存外围设备，注意如果这里不保存外围设备（或者说peripheral没有一个强引用，无法到达连接成功（或失败）的代理方法，因为在此方法调用完就会被销毁
        if(![self.peripherals containsObject:peripheral]){
            [self.peripherals addObject:peripheral];
        }
      //  NSLog(@"开始连接外围设备...");
        [_listTable reloadData];
       // [self writeToLog:@"开始连接外围设备..."];
        //[self.centralManager connectPeripheral:peripheral options:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripherals.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (self.peripherals.count >0) {
        CBPeripheral* cbp = self.peripherals[indexPath.row];
//        CBPeripheralStateDisconnected = 0,
//        CBPeripheralStateConnecting,
//        CBPeripheralStateConnected,
        NSString* state = @"未连接";
        if (cbp.state ==0) {
            
        }
        else if (cbp.state==1){
            state = @"正在连接";
        }
        else{
            state = @"已连接";

        }
        cell.textLabel.text =[NSString stringWithFormat:@"%@",cbp.name]; //cbp.name;
      //  cell.detailTextLabel.text = valueToString(cbp.state);
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary* dict = @{@"object": _peripherals[indexPath.row]};
    _giveDeviceNameBlock(dict);
//    Tab2ViewController* tab2 = viewOnSb(@"Tab2ViewController");
//    tab2.peripheral = _peripherals[indexPath.row] ;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController pushViewController:tab2 animated:YES];
}


@end
