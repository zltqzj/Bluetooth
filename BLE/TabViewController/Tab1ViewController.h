//
//  Tab1ViewController.h
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMapView.h"
#import "BaseViewController.h"

@interface Tab1ViewController : BaseViewController<MKMapViewDelegate>

@property(weak,nonatomic) IBOutlet UITableView* listTable;// 暂时不用了
@property(weak,nonatomic) IBOutlet MyMapView* mapView;

@end
