//
//  KilometerAnotationView.m
//  Sport
//
//  Created by zhaojian on 14-9-5.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "KilometerAnotationView.h"
#define  Arror_height 5
@implementation KilometerAnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
  
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -6);
        self.frame = CGRectMake(0, 0, 22, 20);

        _kmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
        _kmLabel.backgroundColor = [UIColor clearColor];
        _kmLabel.textColor = [UIColor whiteColor];
        _kmLabel.font = [UIFont systemFontOfSize:8];
        _kmLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_kmLabel];
    }
    return self;
}


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        _kmLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-5)];
//        _kmLabel.textColor = [UIColor whiteColor];
//        _kmLabel.font = [UIFont systemFontOfSize:10];
//        
//        [self addSubview:_kmLabel];
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)getDrawPath:(CGContextRef)context rect:(CGRect)rect
{
    CGRect rrect = rect;
	CGFloat radius = 1.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
   // CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
     CGContextSetFillColorWithColor(context, RGB(0, 170, 132).CGColor);

    [self getDrawPath:context rect:self.bounds];
    CGContextFillPath(context);
    
  //  CGPathRef path = CGContextCopyPath(context);
    
  //  self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowOpacity = 1;
    
    //insert
   // self.layer.shadowPath = path;
    
}

@end
