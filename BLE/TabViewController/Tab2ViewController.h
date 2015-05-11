//
//  Tab2ViewController.h
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Tab2ViewController : BaseViewController

@property(weak,nonatomic) IBOutlet UILabel* log;

-(IBAction)connect2device:(id)sender;
-(IBAction)cancelConnect2Device:(id)sender;

@property(weak,nonatomic) IBOutlet UIButton* bluetoothBtn;
@property(weak,nonatomic) IBOutlet UIImageView* signalStrengthen1;
@property(weak,nonatomic) IBOutlet UIImageView* signalStrengthen2;
@property(weak,nonatomic) IBOutlet UIImageView* signalStrengthen3;


@end
