//
//  MyMapView.m
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "MyMapView.h"
#import "KilometerAnno.h"
@implementation MyMapView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        
    }
    return self;
}


-(void)initBasicData{
    _haveDrawCount = 0;
    _routeLineArray = [[NSMutableArray alloc] initWithCapacity:1];
    _mFlag = 0;
    _annoArray= [[NSMutableArray alloc] initWithCapacity:1];
    _customAnno = [[NSMutableArray alloc] initWithCapacity:1];
    _kmAnno = [[NSMutableArray alloc] initWithCapacity:1];
    _kmdata = [[NSMutableArray alloc] initWithCapacity:1];
}


-(void)addKMAnno// km的标识
{
    [_kmAnno enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KilometerAnno* mmp = ( KilometerAnno* )obj;
        [self removeAnnotation:mmp];
    }];
    [_kmAnno removeAllObjects];
    
    
    [_kmdata enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"DISTANCE"] intValue] >100) {
            *stop = YES;
        }
        CLLocationCoordinate2D kmenume = CLLocationCoordinate2DMake([obj[@"LATITUDE_A"] doubleValue] , [obj[@"LONGITUDE_A"] doubleValue]);
        KilometerAnno* mmp = [[KilometerAnno alloc] initWithCoordinate:kmenume content:[NSString stringWithFormat:@"%d",[obj[@"DISTANCE"] intValue]]];
        [_kmAnno addObject:mmp];
        [self addAnnotation:mmp];
       
    }];
}

-(void)setCenterLocation{
    CLLocationCoordinate2D c;
    double height;
    double width;
    
    c      = _centerGps;
    height = _r_latitude*1000;
    width  = _r_logitude*1000;
    
    if (height>width) {  // 高大，都加高的四分之一
        width  = width + height/4;
        height = height+height/4;
    }
    else{    // 宽大，都加宽的四分之一
        width  = width+ width/4;
        height = height+ width/4;
    }
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(c, height, width);
    MKCoordinateRegion adjustedRegion = [self regionThatFits:viewRegion];
    
    if (isnan(adjustedRegion.center.latitude)|| isnan(adjustedRegion.center.longitude) ) {
        // iOS 6 will result in nan.
        adjustedRegion.center.latitude = viewRegion.center.latitude;
        adjustedRegion.center.longitude = viewRegion.center.longitude;
        adjustedRegion.span.latitudeDelta = 0;
        adjustedRegion.span.longitudeDelta = 0;
    }
    [self setRegion:adjustedRegion animated:YES];
}



// 划线方法（点的个数发生变化时才划线）(重新开始一个activity要把_routeLineArray,_haveDrawCount清零。）
- (void)configureRoutes:(NSMutableArray *) _pointsToDraw
{
    
    [self removeAnnotations:_annoArray];
    [self removeAnnotations:self.annotations];
    [_annoArray removeAllObjects];
    [_kmAnno removeAllObjects];
    
    CLLocationCoordinate2D c;
    double height =0;
    double width =0;
    if (_mFlag == 0)  // 本地实时画图（测量模式）
    {
        c = _centerGps;
        height = _r_latitude;
        width = _r_logitude;
    }
    if (_mFlag == 1) //画图模式下且数据是从web端传回的时候才需要
    {
        
        c = _centerGps;
        height = _r_latitude*1000;
        width = _r_logitude*1000;
        
    }
    else if(_mFlag == 2)   // 本地非实时画图
    {
        c = _centerGps;
        height = _r_latitude;
        width = _r_logitude;
    }
    if (height > width) {  // 高大，都加高的四分之一
        width = width + height/4;
        height = height+height/4;
    }
    else{    // 宽大，都加宽的四分之一
        width = width+ width/4;
        height = height+ width/4;
    }
    if (height==0) {
        height = 10000;
        width = 10000;
    }
    NSLog(@"%f,%f,%f,%f",c.latitude,c.longitude,width,height);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(c, width, height);
   MKCoordinateRegion adjustedRegion = [self regionThatFits:viewRegion];
    
    if (isnan(adjustedRegion.center.latitude)|| isnan(adjustedRegion.center.longitude) ) {
        // iOS 6 will result in nan.
        adjustedRegion.center.latitude = viewRegion.center.latitude;
        adjustedRegion.center.longitude = viewRegion.center.longitude;
        adjustedRegion.span.latitudeDelta = 0;
        adjustedRegion.span.longitudeDelta = 0;
    }
    
    if(adjustedRegion.center.longitude == -180.00000000){
        
    }
    else
     [self setRegion:adjustedRegion animated:YES];
    
    
    [self removeAnnotations:_annoArray];
    // define minimum, maximum points
    MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
    MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
    
    // create a c array of points.
    MKMapPoint* pointArray = malloc(sizeof(MKMapPoint) * _pointsToDraw.count);
    MKMapPoint* pointArray2Draw = nil;
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    if (_pointsToDraw.count ==0) {
        
    }
    else{
        if (self.routeLine) {
            
            [self removeOverlay:self.routeLine];
            self.routeLine = nil;
            //  NSLog(@"____________________%d___________________",_routeLineArray.count);
        }
        
        int nIndex = 0;
        _lastSection = 1;
        
        for(NSInteger idx = _haveDrawCount ; idx < _pointsToDraw.count; idx++)
        {
            
            NSDictionary* d = [_pointsToDraw objectAtIndex:idx];
            
            if (_mFlag == 1)
            {
                float km = (_kmdata.count + 1)*1.0f; //计算要当前要找的那个公里数
                if([d[@"DISTANCE"] floatValue] > km)
                {
                    [_kmdata addObject:d];
                }
                if ([d[@"SECTION"] intValue] > _lastSection) {
                    NSMutableDictionary * dict_m = [[NSMutableDictionary alloc] initWithCapacity:1];
                    if (idx == 0) //表示第一个点就是暂停在开始的
                        [dict_m setDictionary:[_pointsToDraw objectAtIndex:idx]];
                    else
                        [dict_m setDictionary:[_pointsToDraw objectAtIndex:idx-1]];
                    [dict_m setObject:@"STOP" forKey:@"TYPE"];
                    
                    NSMutableDictionary * dict_n = [[NSMutableDictionary alloc] initWithCapacity:1];
                    [dict_n setDictionary:d];
                    [dict_n setObject:@"START" forKey:@"TYPE"];
                  
                    _lastSection = [dict_n[@"SECTION"] intValue];
                }
                
            }
            latitude  = [[d objectForKey:@"LATITUDE_A"] doubleValue];
            longitude = [[d objectForKey:@"LONGITUDE_A"] doubleValue];
            
            
            // create our coordinate and add it to the correct spot in the array
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);  // 原始坐标
            
            MKMapPoint point = MKMapPointForCoordinate(coordinate);
            
            // if it is the first point, just use them, since we have nothing to compare to yet.
            if (idx == 0) {
                northEastPoint = point;
                southWestPoint = point;
                
            } else {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
            }
            if (idx > 0){
                NSString* a =[[_pointsToDraw objectAtIndex:idx] objectForKey:@"SECTION"];
                NSString* b =[[_pointsToDraw objectAtIndex:idx-1] objectForKey:@"SECTION"];
                if ( ![a isEqualToString:b]) { //当前是section有变化的时候，需要添加一个不重画的overlay
                    
                    if(nIndex > 0)
                    {
                        
                        if (pointArray2Draw==nil)
                        {
                            pointArray2Draw = malloc(sizeof(MKMapPoint) * nIndex);
                            memcpy(pointArray2Draw, pointArray, sizeof(MKMapPoint) * nIndex);
                        }
                        float dis = ([[[_pointsToDraw objectAtIndex:idx-1] objectForKey:@"DISTANCE"] floatValue] - [[[_pointsToDraw objectAtIndex:idx - 1 - nIndex + 1] objectForKey:@"DISTANCE"] floatValue]);
                        float interval = ([[[_pointsToDraw objectAtIndex:idx - 1] objectForKey:@"INTERVAL"] floatValue] - [[[_pointsToDraw objectAtIndex:idx -1 - nIndex+1] objectForKey:@"INTERVAL"] floatValue]);
                        float v = dis*1000/interval;
                        self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
                        if (nil != self.routeLine) {
                            NSDictionary * d_lay = @{@"overlay":self.routeLine,@"speed":[NSString stringWithFormat:@"%f",v]};
                            [_routeLineArray addObject:d_lay];
                            if (_mFlag == 1)
                                [self addOverlay:self.routeLine level:MKOverlayLevelAboveRoads];
                            else
                                [self addOverlay:self.routeLine]; // add the overlay to the map
                            //[_routeLineArray addobject:self.routeLine];
                            
                            _haveDrawCount = idx;
                        }
                        if (pointArray2Draw)
                        {
                            free(pointArray2Draw);
                            pointArray2Draw = nil;
                        }
                        free(pointArray);
                        pointArray = malloc(sizeof(MKMapPoint) * _pointsToDraw.count);
                        nIndex = 0;
                    }
                    
                }
            }
            
            pointArray[nIndex] = point;
            nIndex ++ ;
            
            /////////////////////判断当前的idx总数是否满足max_count,则需要生成一个不重画的overlay；
            if (nIndex == MAX_POINT)
            {
                if (pointArray2Draw==nil)
                {
                    pointArray2Draw = malloc(sizeof(MKMapPoint) * nIndex);
                    memcpy(pointArray2Draw, pointArray, sizeof(MKMapPoint) * nIndex);
                }
                
                self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
                if (nil != self.routeLine) {
                    NSDictionary * d_lay = @{@"overlay":self.routeLine};
                    [_routeLineArray addObject:d_lay];
                    if (_mFlag == 1)
                        [self addOverlay:self.routeLine level:MKOverlayLevelAboveRoads];
                    else
                        [self addOverlay:self.routeLine]; // add the overlay to the map
                    //[_routeLineArray addObject:self.routeLine];
                    
                    _haveDrawCount = idx;// 为了保证点的连续，所以必须上一个的点的数据也要参与到下一段的画线中。下一个timmer触发画线的时候用到。
                    
                }
                if (pointArray2Draw)
                {
                    free(pointArray2Draw);
                    pointArray2Draw = nil;
                }
                free(pointArray);
                pointArray = malloc(sizeof(MKMapPoint) * _pointsToDraw.count);
                nIndex = 0;
                //为了保证点的连续，所以必须上一个的点的数据也要参与到下一段的画线中。当前画线的时候用到。
                pointArray[nIndex] = point;
                nIndex++;
                
            }
        }
        
        // 加起点终点坐标
        
        CLLocationCoordinate2D startLo = CLLocationCoordinate2DMake([[[_pointsToDraw objectAtIndex:0] objectForKey:@"LATITUDE_A"] doubleValue], [[[_pointsToDraw objectAtIndex:0] objectForKey:@"LONGITUDE_A"] doubleValue]);
        MapPoint* mmp1 = [[MapPoint alloc] initWithCoordinate2D:startLo  ];
        mmp1.title = @"起点";
        [self addAnnotation:mmp1];
        [_annoArray addObject:mmp1];
        
        if (_mFlag !=0) {
            CLLocationCoordinate2D lo1 = CLLocationCoordinate2DMake(latitude,longitude);
            MapPoint* mmp = [[MapPoint alloc] initWithCoordinate2D:lo1  ];
            mmp.title = @"终点";
            [ self addAnnotation:mmp];
            [_annoArray addObject:mmp];
        }
        ///////////////////以上为加起点终点坐标
        
        if (pointArray2Draw == nil && nIndex>0)
        {
            pointArray2Draw = malloc(sizeof(MKMapPoint) * nIndex);
            memcpy(pointArray2Draw, pointArray, sizeof(MKMapPoint) * nIndex);
        }
        self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
        float dis = ([[[_pointsToDraw objectAtIndex:_pointsToDraw.count - 1] objectForKey:@"DISTANCE"] floatValue] - [[[_pointsToDraw objectAtIndex:_pointsToDraw.count - 1 - nIndex + 1] objectForKey:@"DISTANCE"] floatValue]);
        float interval = ([[[_pointsToDraw objectAtIndex:_pointsToDraw.count - 1 ] objectForKey:@"INTERVAL"] floatValue] - [[[_pointsToDraw objectAtIndex:_pointsToDraw.count -1 - nIndex + 1] objectForKey:@"INTERVAL"] floatValue]);
        
        if (nil != self.routeLine) {
            if (_mFlag == 1)
                [self addOverlay:self.routeLine level:MKOverlayLevelAboveRoads];
            else
                [self addOverlay:self.routeLine]; // add the overlay to the map
            //[_routeLineArray addObject:self.routeLine];
            
            
        }
        if (pointArray2Draw)
        {
            free(pointArray2Draw);
            pointArray2Draw = nil;
        }
        free(pointArray);
        nIndex = 0;
    }
}





-(void)updateMap:(NSMutableArray*)parray{
    
    [self configureRoutes:parray];
    //[parray removeAllObjects];
}

-(void)emptyAllOnMap{
    if (self.annotations.count>0) {
        [self removeAnnotations:self.annotations];
    }
    if (self.routeLine) {
        [self removeOverlay:self.routeLine];
        self.routeLine = nil;
    }
    [self removeOverlays:self.overlays];
    [_routeLineArray removeAllObjects];
    [_annoArray removeAllObjects];
    [_customAnno removeAllObjects];
    
    _haveDrawCount = 0;
}


-(void)dealloc{
    NSLog(@"地图销毁");
}
@end
