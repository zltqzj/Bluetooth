//
//  ViewController.m
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationThread = [LocationThread sharedManager];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
