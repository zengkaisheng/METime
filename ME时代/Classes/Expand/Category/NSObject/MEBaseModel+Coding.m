//
//  MEBaseModel+Coding.m
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel+Coding.h"

static NSString *const kDataKey = @"MEObjCodingKey";

@implementation MEBaseModel (Coding)

+ (NSCache *)shareCache{
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
            [cache removeAllObjects];
        }];
    });
    
    return cache;
}

- (void)writeObjectForKey:(NSString *)key path:(TCodingPath)path{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kDataKey];
    [archiver finishEncoding];
    NSString *fileName = [[self class] pathWithKey:key path:path];
    [[[self class] shareCache] removeObjectForKey:fileName];
    [data writeToFile:fileName atomically:YES];
}

- (void)writeObjectForKey:(NSString *)key{
    [self writeObjectForKey:key path:TCodingPathDocument];
}

+ (id)getObjctForKey:(NSString *)key{
    return  [self getObjctForKey:key path:TCodingPathDocument];
}

+ (id)getObjctForKey:(NSString *)key path:(TCodingPath)path{
    NSString *fileName = [[self class] pathWithKey:key path:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        
        NSData *data = nil;
        NSData *cache = [[self shareCache] objectForKey:fileName];
        if (cache) {
            data = cache;
        }else{
            data = [[NSData alloc] initWithContentsOfFile:fileName];
            if(data)  [[self shareCache] setObject:data forKey:fileName];
        }
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        //解档出数据模型Model
        MEBaseModel *model = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        
        return model;
    }
    
    return nil;
}

+ (void)removeCodingForKey:(NSString *)key{
    [self removeCodingForKey:key path:TCodingPathDocument];
}

+ (void)removeCodingForKey:(NSString *)key path:(TCodingPath)path{
    NSString *fileName = [[self class] pathWithKey:key path:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:fileName]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:fileName error:&error];
        if(error) {NSLog(@"%@",error.description);}
    }
}

#pragma mark - private

+ (NSString *)pathWithKey:(NSString *)key path:(TCodingPath)path{
    NSString *fileName = [NSString stringWithFormat:@"%@%@",NSStringFromClass([self class]),key] ;
    return (path == TCodingPathCach) ? kMeFilePathAtCachWithName(fileName) : kMeFilePathAtDocumentWithName(fileName);
}
@end
