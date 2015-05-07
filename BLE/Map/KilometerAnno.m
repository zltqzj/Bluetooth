//
//  KilometerAnno.m
//  Sport
//
//  Created by zhaojian on 14-9-5.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "KilometerAnno.h"

@implementation KilometerAnno

-(id) initWithCoordinate:(CLLocationCoordinate2D) c content:(NSString *) content
{
    self = [super init];
    if(self){
        _coordinate = c;
        _content = content;
        
    }
    return self;
    
   
    
}
@end
