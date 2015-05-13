//
//  NetUtils.m
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "NetUtils.h"
#import "AppDelegate.h"
//#import "BlocksKit+UIKit"
@implementation NetUtils


+ (instancetype)manager {
    static NetUtils *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetUtils alloc] init];
    });
    return manager;
}

// af post方法
-(void)requestContentWithUrl:(NSString*)urlString para:(NSDictionary*)dict withSuccessBlock:(AFCompletionBlock)successBlock withFailureBlock:(AFFailedBlcok)failureBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    _manager = manager;
    
    NSString* base64 = [NSString stringWithFormat:@"%@%@",@"TuliPS14port20",CURRENT_USER_EMAIL];
    
    [_manager.requestSerializer setValue:base64 forHTTPHeaderField:@"Authorization"];
    
    NSString* url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    //  NSLog(@"%@",url);
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
        // NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        NSLog(@"Error: %@", error);
        failureBlock(error);
    }];
    
    
}

//AF： get方法
-(void)GetContentWithUrl:(NSString*)urlString   withSuccessBlock:(AFCompletionBlock) successBlock
        withFailureBlock:(AFFailedBlcok) failureBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    _manager = manager;
    
    NSString* url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}

// af download GIF 方法
-(void)downLoadByaf:(NSString*)url withSuccessBlock:(AFDownLoadCompletionBlock)successBlock withFailureBlock:(ADownLoadFailedBlcok)failureBlock  {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSString* base64 = [NSString stringWithFormat:@"%@%@",@"TuliPS14port20",CURRENT_USER_EMAIL];
    
    [_manager.requestSerializer setValue:base64 forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            failureBlock(error);
        }
        NSLog(@"%@",[response suggestedFilename]);
        NSLog(@"File downloaded to: %@", filePath.path); // 绝对路径
        successBlock([response suggestedFilename]);
    }];
    [downloadTask resume];
}

// 上传图片
-(void)uploadImage:(NSString*)url dict:(NSDictionary*)dict imageData:(NSData*)imageData fileName:(NSString*)fileName type:(NSString*)type{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData  appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:type];
        NSLog(@"%@",formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}



-(void)uploadImage1:(NSString *)url dict:(NSDictionary *)dict imageData:(NSData *)imageData fileName:(NSString *)fileName type:(NSString *)type abURL:(NSString*)abURL  list:(NSMutableArray*)list{
    
    
    
    
    
}







// 下载图片
//-(void)downLoadByafWithURL:(NSString *)url withSuccessBlock:(AFDownLoadCompletionBlock)successBlock withFailureBlock:(ADownLoadFailedBlcok)failureBlock localPath:(NSString *)path{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSURL *URL = [NSURL URLWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSString* base64 = [NSString stringWithFormat:@"%@%@",@"TuliPS14port20",CURRENT_USER_EMAIL];
//    base64 = [NSString encodeBase64String:base64];
//    [_manager.requestSerializer setValue:base64 forHTTPHeaderField:@"Authorization"];
//
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        // NSLog(@"%@",[documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);
//        // successBlock([documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        if (error) {
//            failureBlock(error);
//        }
//        NSLog(@"%@",[response suggestedFilename]);
//        NSLog(@"File downloaded to: %@", filePath.path); // 绝对路径
//        successBlock([response suggestedFilename]);
//    }];
//    [downloadTask resume];
//}

/*
 URI: http://www.tulipsport.com/m/uploadactivitypicshander
 
 POST参数
 1）图片文件
 2）aid
 
 类似头像上传的接口
 
 
 返回:
 {"msg": "","success": true,"filename":"http://img.tulipsport.com/activityimgs/932_20140828184335088568_mid.jpg"}
 
 图像URL:
 返回中型的图片：http://img.tulipsport.com/activityimgs/932_20140828184335088568_mid.jpg（宽600）
 
 注意：
 http://img.tulipsport.com/activityimgs/932_20140828184335088568.jpg（原图）
 http://img.tulipsport.com/activityimgs/932_20140828184335088568_min.jpg（最小型图片,宽200）
 */

@end