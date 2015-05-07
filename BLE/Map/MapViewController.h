//
//  MapViewController.h
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//  /Users/zkr/Library/Developer/CoreSimulator/Devices/2D7A8BC5-17AF-4F8E-AB4F-FADDF397A568/data/Containers/Data/Application/4ECC90A1-22B7-4881-95E0-D6E6168FDE28/Documents/181263_display.rtf

#import <UIKit/UIKit.h>
#import "MyMapView.h"
@interface MapViewController : UIViewController<MKMapViewDelegate>

@property(weak,nonatomic) IBOutlet MyMapView* mapView;

@end
