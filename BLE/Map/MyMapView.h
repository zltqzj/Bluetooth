//
//  MyMapView.h
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import "CSqlite.h"
@interface MyMapView : MKMapView
{
    CSqlite *m_sqlite;
}


@property (nonatomic,assign) MKMapRect routeRect;

@property (nonatomic, retain) MKPolyline* routeLine; // 划线
@property(strong,nonatomic) NSMutableArray* routeLineArray;// 图层数组，数组内容为“线”

@property (nonatomic, retain) MKPolylineView* routeLineView; // 划线视图
@property(assign,nonatomic)NSInteger mFlag;//记录当前的map是测量模式NO 还是显示模式:YES

@property(strong,nonatomic) NSMutableArray* annoArray;// 标注数组(起点终点)
@property(strong,nonatomic) NSMutableArray* customAnno;// 自定义的标注的数组
@property(strong,nonatomic) NSMutableArray* kmdata;// 自定义的标注的数组
@property(strong,nonatomic) NSMutableArray* kmAnno;// 自定义的公里标注的数组
@property(assign,nonatomic) int lastSection;//记录上一个点的
@property(assign,nonatomic) int haveDrawCount;// 循环里，记录已经画过的点的个数
@property(assign,nonatomic) CLLocationCoordinate2D centerGps;// 中心点
@property(assign,nonatomic) double r_latitude;
@property(assign,nonatomic) double r_logitude;

-(void)initBasicData;


-(void)updateMap:(NSMutableArray*)parray;// 画图算法

-(void)setCenterLocation;// 设置中心点

-(void)addKMAnno;// km的标识

@end
