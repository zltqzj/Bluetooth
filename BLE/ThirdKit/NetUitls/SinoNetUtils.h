//
//  SinoNetUtils.h
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>



// 还未自定义错误原因
typedef NS_ENUM(NSInteger, V2ErrorType) {
    
    V2ErrorTypeNoOnceAndNext          = 700,
    V2ErrorTypeLoginFailure           = 701,
    V2ErrorTypeRequestFailure         = 702,
    V2ErrorTypeGetFeedURLFailure      = 703,
    V2ErrorTypeGetTopicListFailure    = 704,
    V2ErrorTypeGetNotificationFailure = 705,
    V2ErrorTypeGetFavUrlFailure       = 706,
    V2ErrorTypeGetMemberReplyFailure  = 707,
    V2ErrorTypeGetTopicTokenFailure   = 708,
    V2ErrorTypeGetCheckInURLFailure   = 709,
    
};


@interface SinoNetUtils : NSObject

+ (instancetype)manager;// 网络请求单例



#pragma mark - 以上为可重用部分

#pragma mark - 网络请求的方法
- (NSURLSessionDataTask *)getLocatonList1WithUrl:(NSString *)url
                                         success:(void (^)(id returnData))success
                                         failure:(void (^)(NSError *error))failure ;



@end
