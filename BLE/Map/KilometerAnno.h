//
//  KilometerAnno.h
//  Sport
//
//  Created by zhaojian on 14-9-5.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface KilometerAnno : NSObject<MKAnnotation>

@property(nonatomic, copy)NSString* content;

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c content:(NSString *) content;


@end
