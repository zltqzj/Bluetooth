//
//  ViewController.h
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationThread.h"
#import "BaseViewController.h"
@interface ViewController : BaseViewController

@property(strong,nonatomic) LocationThread* locationThread; // 多线程对象
@property(weak,nonatomic) IBOutlet UIButton* bluetoothBtn;
@property(weak,nonatomic) IBOutlet UILabel* stateLabel;

-(IBAction)connectDevice:(id)sender;
-(IBAction)gotoMap:(id)sender;

@end

