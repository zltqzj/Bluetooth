//
//  SinoNetUtils.m
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "SinoNetUtils.h"
 #import "AppDelegate.h"
//#import "BlocksKit+UIKit"
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
        
        // Any common handler for Response
        
        //        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
        
        
        success(task, responseObject);
        
    };
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
   // [self.manager.requestSerializer setValue:self.userAgentMobile forHTTPHeaderField:@"User-Agent"];
    
    if (method == SinoRequestMethodJSONGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
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


- (NSURLSessionDataTask *)getLocatonList1WithUrl:(NSString *)url
                                         success:(void (^)(id returnData))success
                                         failure:(void (^)(NSError *error))failure {
    return [self requestWithMethod:SinoRequestMethodHTTPGET URLString:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //V2NodeList *list = [[V2NodeList alloc] initWithArray:responseObject];
        NSArray* arr = responseObject;
        
        success(arr);
    } failure:^(NSError *error) {
        failure(error);
    }];
}






/*
#pragma mark - other net request
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



/*
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    NSLog(@"File downloaded to: %@", filePath);
}];
[downloadTask resume];
*?



// 检查更新
-(void)getUpdate:(updateBlock)completonBlock{
   
//    [self requestContentWithUrl:UPDATE para:nil withSuccessBlock:^(id returnData) {
//        if ([returnData isKindOfClass:[NSDictionary class]]) {
//             NSString* verCode = [returnData objectForKey:@"verCode"];
//            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//            NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
//            
//            NSURL* url = [NSURL URLWithString:DOWNLOAD];
//            
//            if (![verCode isEqualToString:nowVersion] &&verCode ) {
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本更新" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
//                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
//                    switch (buttonIndex) {
//                        case 0:
//                            NSLog(@"暂不升级");
//                            break;
//                        case 1:
//                            NSLog(@"马上升级");
//                            
//                            [[UIApplication sharedApplication] openURL:url];
//                            break;
//                        default:
//                            break;
//                    }
//                }];
//            }
//        }
//    } withFailureBlock:^(NSError *error) {
//        
//    }];
    
 
}


/*  调用方法
 
 [dataConnector getContentsOfURLFromString:[self.urlTextField text]
 withSuccessBlock:(DataConnectorSuccessBlock)^(NSString * resultString) {
 [self.textView setText:resultString];
 
 
 }
 withFailureBlock:(DataConnectorFailureBlock)^(NSError * error) {
 [self.textView setText:[error description]];
 
 }];


 */


 




@end
