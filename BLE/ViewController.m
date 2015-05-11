//
//  ViewController.m
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "ViewController.h"
#import "Tab1ViewController.h"
#import "Tab2ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()
<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) CBCentralManager *centralManager;//中心设备管理器
@property (strong,nonatomic) NSMutableArray *peripherals;//连接的外围设备
@property (strong,nonatomic) CBPeripheral * peripheral;//外设

@end

@implementation ViewController


-(IBAction)connectDevice:(id)sender{
    Tab2ViewController* tab2 = viewOnSb(@"Tab2ViewController");
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:tab2 animated:YES];
}

-(IBAction)gotoMap:(id)sender{
    Tab1ViewController * tab1 = viewOnSb(@"Tab1ViewController");
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    [self.navigationController pushViewController:tab1 animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    _centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];

  //  _locationThread = [LocationThread sharedManager];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//中心服务器状态更新后
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"BLE已打开.");
            [_bluetoothBtn setImage:[UIImage imageNamed:@"lanya_on"] forState:UIControlStateNormal];
            _stateLabel.text = @"iOS蓝牙已打开";
            break;
            
        default:
            NSLog(@"此设备不支持BLE或未打开蓝牙功能.");
            _stateLabel.text = @"iOS蓝牙未打开";
            [_bluetoothBtn setImage:[UIImage imageNamed:@"lanya_off"] forState:UIControlStateNormal];

            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
