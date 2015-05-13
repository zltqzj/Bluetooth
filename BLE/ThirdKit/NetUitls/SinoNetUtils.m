//
//  SinoNetUtils.m
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "SinoNetUtils.h"
#import "AFNetworking.h"
// 网络请求的方式
typedef NS_ENUM(NSInteger, SinoRequestMethod) {
    SinoRequestMethodJSONGET    = 1,
    SinoRequestMethodHTTPPOST   = 2,
    SinoRequestMethodHTTPGET    = 3,
    SinoRequestMethodHTTPGETPC  = 4
};

@interface SinoNetUtils ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation SinoNetUtils
 
#pragma mark - base method

+ (instancetype)manager {
    static SinoNetUtils *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SinoNetUtils alloc] init];
    });
    return manager;
}

- (NSURLSessionDataTask *)requestWithMethod:(SinoRequestMethod)method
                                  URLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSError *error))failure  {
    if (_manager ==nil) {
        self.manager = [[AFHTTPSessionManager alloc] init ];
    }
    // stateBar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
        success(task, responseObject);
        
    };
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
   // [self.manager.requestSerializer setValue:self.userAgentMobile forHTTPHeaderField:@"User-Agent"];
    
    if (method == SinoRequestMethodJSONGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
         self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
           // SinoLog(@"Error: \n%@", [error description]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == SinoRequestMethodHTTPGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == SinoRequestMethodHTTPPOST) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

        task = [self.manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == SinoRequestMethodHTTPGETPC) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
      //  [self.manager.requestSerializer setValue:self.userAgentPC forHTTPHeaderField:@"User-Agent"];
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    return task;
}

#pragma mark - 以上为可重用部分


#pragma mark - 网络请求的方法
- (NSURLSessionDataTask *)getLocatonList1WithUrl:(NSString *)url
                                         success:(void (^)(id returnData))success
                                         failure:(void (^)(NSError *error))failure {
    return [self requestWithMethod:SinoRequestMethodJSONGET URLString:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //V2NodeList *list = [[V2NodeList alloc] initWithArray:responseObject];
        NSArray* arr = responseObject;
        
        success(arr);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
