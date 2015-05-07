//
//  Tab2ViewController.m
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "Tab2ViewController.h"

@interface Tab2ViewController ()

@end

@implementation Tab2ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SETTING_NAVGATION_STYLE
    self.title = @"蓝牙";
    [self.tabBarController.tabBar setHidden:NO];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
