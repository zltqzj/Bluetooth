//
//  FileManager.m
//  Sport
//
//  Created by ZKR on 6/14/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//  创建    _file_manager = [FileManager sharedManager];


#import "FileManager.h"

@implementation FileManager


// 单例方法得到线程的对象
+ (id)sharedManager {
    static FileManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

// 从文件名为_name的文件中搜索point 返回为数组，现只用于搜索point.rtf
-(NSMutableArray*)searchPointFromFile:(NSString*)_name{
 
    //NSMutableArray* point_array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self fileName:_name]];
   
       NSMutableArray* point_array = [self loadMarkersFromFilePath:[self fileName:_name]];
    return point_array;
}

- (NSMutableArray *)loadMarkersFromFilePath:(NSString *)filePath {
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *vdUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    markers = [vdUnarchiver decodeObjectForKey:@"kSaveKeyMarkerLines"];
    [vdUnarchiver finishDecoding];
    vdUnarchiver  =nil;
    data = nil;
    return markers;
}

// 获取沙盒目录中document+_name
-(NSString*)fileName:(NSString*)_name{
    NSString *Path = PATH_OF_DOCUMENT;
    NSString *filename = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_name]];
    return filename;
}

// 获取沙盒目录中document+_name+sub_path
-(NSString*)createSubPath:(NSString*)parentPath subPath:(NSString*)subPath{
    NSString *Path = PATH_OF_DOCUMENT;
    
    NSString *testDirectory = [Path stringByAppendingPathComponent:parentPath];
    if ([self fileExistsAtPath:testDirectory] == NO)
    {
        // 创建目录
        [self createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    Path = testDirectory;
    
    testDirectory = [Path stringByAppendingPathComponent:subPath];
    if ([self fileExistsAtPath:testDirectory] == NO)
    {
        // 创建目录
        [self createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    Path = testDirectory;
    return Path;
}

// 创建沙盒目录中document+_name+sub_path
-(NSString*)fileName_ex:(NSString*)_name Sub_Path:(NSString *)sub_path{
    NSString *Path = PATH_OF_DOCUMENT;
    
    if([sub_path isEqualToString:@""] == NO)
    {
        NSString *testDirectory = [Path stringByAppendingPathComponent:sub_path];
        if ([self fileExistsAtPath:testDirectory] == NO)
        {
            // 创建目录
            [self createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        Path = testDirectory;
    }
    NSString *filename = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_name]];
    return filename;
}


-(NSMutableArray*)searchPointFromSegmentFile{
    
    NSData *data = [NSData dataWithContentsOfFile:[self getSegmentfileName]];
    if (data == nil)
        return nil;
    NSMutableArray* point_array = [NSKeyedUnarchiver unarchiveObjectWithData:data  ];
    return point_array;
}

-(NSString*)getSegmentfileName{
    NSString *Path =PATH_OF_DOCUMENT;
    NSString *filename = [Path stringByAppendingPathComponent:@"segment.rtf"];
    return filename;
}




@end
