//
//  Tab2ViewController.h
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab2ViewController : UIViewController

@property(weak,nonatomic) IBOutlet UILabel* log;

-(IBAction)connect2device:(id)sender;
-(IBAction)cancelConnect2Device:(id)sender;

@end
