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
@property(weak,nonatomic) IBOutlet UIButton* closeBtn;
@property(weak,nonatomic) IBOutlet UILabel* stateLabel;
@property(strong,nonatomic) IBOutlet UIImageView* blueBGImageview;
@property(strong,nonatomic) IBOutlet UIImageView* centerBGImageview;


@property(weak,nonatomic) IBOutlet UIImageView* signalStrengthen1;
@property(weak,nonatomic) IBOutlet UIImageView* signalStrengthen2;
@property(weak,nonatomic) IBOutlet UIImageView* signalStrengthen3;

//bt_open.png
@property(weak,nonatomic) IBOutlet UILabel* distanceLabel;
@property(weak,nonatomic) IBOutlet UILabel* rssiLabel;
@property(weak,nonatomic) IBOutlet UILabel* periName;
@property(weak,nonatomic) IBOutlet UITextView* log;
@property (strong,nonatomic) CBPeripheral * peripheral;//外设

-(IBAction)connectDevice:(id)sender;
-(IBAction)gotoMap:(id)sender;

@end

