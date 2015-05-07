//
//  FileManager.h
//  Sport
//
//  Created by ZKR on 6/14/14.
//  Copyright (c) 2014 ZKR. All rights reserved.


//  创建    _file_manager = [FileManager sharedManager];


#import <Foundation/Foundation.h>

@interface FileManager : NSFileManager


-(NSMutableArray*)searchPointFromSegmentFile;

-(NSString*)getSegmentfileName;

// 从文件名为_name的文件中搜索point 返回为数组，现只用于搜索point.rtf
-(NSMutableArray*)searchPointFromFile:(NSString*)_name;

// 获取沙盒目录中document+_name
-(NSString*)fileName:(NSString*)_name;

// 获取沙盒目录中document+_name+sub_path
-(NSString*)fileName_ex:(NSString*)_name Sub_Path:(NSString *)sub_path;

// 创建沙盒目录中document+_name+sub_path
-(NSString*)createSubPath:(NSString*)parentPath subPath:(NSString*)subPath;

// 单例方法得到线程的对象
+ (id)sharedManager ;

@end
