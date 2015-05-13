//
//  NetUtils.h
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"


typedef void (^updateBlock)(void); // 检查更新

// ASI
typedef void (^DataConnectorSuccessBlock)(NSString * returnData);
typedef void (^DataConnectorFailureBlock)(NSString  * returnData);

// AF
typedef void (^AFCompletionBlock)(id returnData);
typedef void (^AFFailedBlcok)(NSError* error);

// af download
typedef void (^AFDownLoadCompletionBlock)(NSString* localURL);
typedef void (^ADownLoadFailedBlcok)(NSError* error);


@interface NetUtils : NSObject


@property(nonatomic,weak) AFHTTPRequestOperationManager* manager;



// af
-(void)requestContentWithUrl:(NSString*)urlString para:(NSDictionary*)dict  withSuccessBlock:(AFCompletionBlock) successBlock
            withFailureBlock:(AFFailedBlcok) failureBlock;
//AF： get方法
-(void)GetContentWithUrl:(NSString*)urlString   withSuccessBlock:(AFCompletionBlock) successBlock
        withFailureBlock:(AFFailedBlcok) failureBlock;

// af download方法
-(void)downLoadByaf:(NSString*)url withSuccessBlock:(AFDownLoadCompletionBlock)successBlock withFailureBlock:(ADownLoadFailedBlcok)failureBlock;

// af 上传图片
-(void)uploadImage:(NSString*)url dict:(NSDictionary*)dict imageData:(NSData*)imageData fileName:(NSString*)fileName type:(NSString*)type;

// af 新的上传图片的方法
-(void)upload:(NSString*)url  dict:(NSDictionary*)dict absolutelyURL:(NSString*)abolutelyURL fileName:(NSString*)fileName type:(NSString*)type;
- (void)uploadPic:(NSString *)filePath url:(NSString*)url1 dict:(NSDictionary*)dict fileName:(NSString*)fileName;
-(void)uploadImage1:(NSString *)url dict:(NSDictionary *)dict imageData:(NSData *)imageData fileName:(NSString *)fileName type:(NSString *)type abURL:(NSString*)abURL list:(NSMutableArray*)list;

// 下载图片
-(void)downLoadByafWithURL:(NSString*)url withSuccessBlock:(AFDownLoadCompletionBlock)successBlock withFailureBlock:(ADownLoadFailedBlcok)failureBlock  localPath:(NSString*)path;

-(void)getUpdate:(updateBlock)completonBlock;  // 检查更新

-(void)whatNew ; // 更新的内容

- (void)uploaddevicefile:(NSString *)filePath url:(NSString*)url1 dict:(NSDictionary*)dict;
+ (instancetype)manager ;

@end