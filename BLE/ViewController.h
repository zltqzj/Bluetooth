//
//  ViewController.h
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationThread.h"
@interface ViewController : UIViewController

@property(strong,nonatomic) LocationThread* locationThread; // 多线程对象

@end

