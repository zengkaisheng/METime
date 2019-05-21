//
//  THTTPRequestOperationManager.m
//  我要留学
//
//  Created by Hank on 10/13/16.
//  Copyright © 2016 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import "THTTPRequestOperationManager.h"
#import "ZLRequestResponse.h"
#import "MELoginVC.h"

NSString *const kServerFailure = @"网络存在异常...";
NSString *const kServerError = @"服务器无法连接";

@implementation THTTPRequestOperationManager

+ (void)showNetErrorMessage{
    MBProgressHUD *hud = [MBProgressHUD showMessage:kServerFailure toView:nil];
    [hud hideAnimated:YES afterDelay:1.0f];
}

// 检测网络连接状态
+ (BOOL)reachability{
    __block BOOL _isError = NO;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    kMeWEAKSELF
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        kMeSTRONGSELF
        switch (status){
             case AFNetworkReachabilityStatusUnknown:
                _isError = YES;
                [strongSelf showNetErrorMessage];
                break;
             case AFNetworkReachabilityStatusNotReachable:
                [strongSelf showNetErrorMessage];
                _isError = YES;
                break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 break;
             default:
                 break;
         }
     }];
    return _isError;
}

- (instancetype)init{
    if([super init]){
        _isAddCommonParameter = NO;
    }
    return self;
}

#pragma mark - POST

#pragma mark -POST请求

- (void)postWithParameter:(NSDictionary *)parameter strUrl:(NSString *)strUrl success:(RequestResponse)success
                              failure:(kMeObjBlock)failure{
    [self postWithUrlStr:strUrl parameter:parameter success:success failure:failure];
}

- (void)postWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
               success:(RequestResponse)success failure:(kMeObjBlock)failure{
    [self postWithUrlStr:urlStr parameter:parameter hudAddedToView:nil success:success failure:failure];
}

- (void)postWithUrlStr:(NSString *)urlStr
             parameter:(NSDictionary *)parameter
                  data:(NSData *)data
      showProgressView:(UIView *)view
               success:(RequestResponse)success
               failure:(kMeObjBlock)failure{
    if([THTTPRequestOperationManager reachability]){
        return;
    }
//    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    progress.dimBackground = YES;
//    progress.mode = MBProgressHUDModeAnnularDeterminate;
    NSLog(@"dicParameter = %@",parameter);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    [self customProcessingForManager:manager];
//    [self customProcessingForManager:manager];//设置相应内容类型
    [manager POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"dyFile" mimeType:@"image/png"];
    }progress:^(NSProgress *uploadProgress){
        NSLog(@"进度= %f",uploadProgress.fractionCompleted);
//        progress.progress = uploadProgress.fractionCompleted;
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObject = %@",dic);
        [self requestResponse:dic success:^(ZLRequestResponse *responseObject) {
//            progress.label.text = @"上传成功";
//            [progress hideAnimated:YES];
            kMeCallBlock(success,responseObject);
        } failure:^(id object) {
//            progress.label.text = @"上传失败";
//            [progress hideAnimated:YES];
            kMeCallBlock(failure,object);
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        progress.label.text = @"上传失败";
//        [progress hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

#pragma mark- 所有POST请求最终调此函数

- (void)postWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
        hudAddedToView:(UIView *)view success:(RequestResponse)success
               failure:(kMeObjBlock)failure
{
    if([THTTPRequestOperationManager reachability]){
        return;
    }
    if(view) [MBProgressHUD showHUDAddedTo:view animated:YES];
    NSDictionary *dicParameter = [self dicParameterWithDic:parameter];
    NSLog(@"dicParameter = %@",dicParameter);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self customProcessingForManager:manager];//设置相应内容类型
    [manager POST:urlStr parameters:dicParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject %@",responseObject);
        if(view) [MBProgressHUD hideHUDForView:view animated:YES];
        [self requestResponse:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(view) [MBProgressHUD hideHUDForView:view animated:YES];
        kMeCallBlock(failure,error);
    }];
}

#pragma mark - GET

#pragma mark- 所有Get请求最终调此函数



- (void)getWithParameter:(NSDictionary *)parameter strUrl:(NSString *)strUrl success:(RequestResponse)success
                             failure:(kMeObjBlock)failure{
    [self getWithUrlStr:strUrl parameter:parameter success:success failure:failure];
}

- (void)getWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
              success:(RequestResponse)success failure:(kMeObjBlock)failure{
    [self getWithUrlStr:urlStr parameter:parameter hudAddedToView:nil success:success failure:failure];
}

- (void)getWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
       hudAddedToView:(UIView *)view success:(RequestResponse)success
              failure:(kMeObjBlock)failure{
    if(view) [MBProgressHUD showHUDAddedTo:view animated:YES];
    NSDictionary *dicParmeter = [self dicParameterWithDic:parameter];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self customProcessingForManager:manager];//设置相应内容类型
    [manager GET:urlStr parameters:dicParmeter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if(view) [MBProgressHUD hideHUDForView:view animated:YES];
        [self requestResponse:responseObject success:success failure:failure];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if(view)  [MBProgressHUD hideHUDForView:view animated:YES];
        kMeCallBlock(failure,error);
    }];
}

- (void)orgialGetWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
       success:(kMeObjBlock)success
              failure:(kMeObjBlock)failure{
    NSDictionary *dicParmeter = [self dicParameterWithDic:parameter];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSMutableSet *types = [NSMutableSet setWithObjects:@"text/html",@"text/plain", nil];
//    [types unionSet:manager.responseSerializer.acceptableContentTypes];
//    manager.responseSerializer.acceptableContentTypes = types;
    [manager.requestSerializer setValue:@"Wap" forHTTPHeaderField:@"ClientSystem"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:dicParmeter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        kMeCallBlock(success,responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        kMeCallBlock(failure,error);
    }];
}

#pragma mark - Help

- (void)requestResponse:(id)responseObject success:(RequestResponse)success failure:(kMeObjBlock)failure{
    ZLRequestResponse *response = [[ZLRequestResponse alloc] initWithDic:responseObject];
//    kMeCallBlock(success,response);
//    if(!response.success){
//        NSLog(@"网络请求错误");
//        kMeCallBlock(failure,response);
//    }else{
//        NSLog(@"网络请求成功");
//        kMeCallBlock(success,response);
//    }
    if([response.status_code isEqualToString:kNetSuccess]){
        NSLog(@"网络请求成功");
        kMeCallBlock(success,response);
    }else if([response.status_code isEqualToString:kNetTokenInvalid]){
        NSLog(@"token 失效");
        kMeCallBlock(failure,response);
        if([MEUserInfoModel isLogin]){
             [MEUserInfoModel logout];
             [MEWxLoginVC presentLoginVCWithIsShowCancel:NO SuccessHandler:nil failHandler:nil];
        }
    }else if([response.status_code isEqualToString:kNetInvateCode]){
        NSLog(@"邀请码请求错误");
        kMeCallBlock(success,response);
    }else if([response.status_code isEqualToString:kNetError]){
        NSLog(@"网络请求错误");
        kMeCallBlock(failure,response);
    }else{
        kMeCallBlock(failure,response);
    }
}

//对请求进行自定义处理
- (void)customProcessingForManager:(AFHTTPSessionManager *)manager{
    NSMutableSet *types = [NSMutableSet setWithObjects:@"text/html",@"text/plain",@"application/json", @"text/json",@"text/javascript", nil];
    [types unionSet:manager.responseSerializer.acceptableContentTypes];
    manager.responseSerializer.acceptableContentTypes = types;
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"clientsystem"];
    [manager.requestSerializer setValue:kMEAppVersion forHTTPHeaderField:@"clientversion"];
}

- (NSDictionary *)dicParameterWithDic:(NSDictionary *)parameter{
    if (!_isAddCommonParameter) {
        return kMeUnDic(parameter);
    }
    NSMutableDictionary *dicParameter = [[NSMutableDictionary alloc] initWithDictionary:kMeUnDic(parameter)];
//    [dicParameter setObject:@"IOS" forKey:@"ClientSystem"];
//    [dicParameter setObject:kMEAppVersion forKey:@"ClientVersion"];
    return dicParameter;
}



@end
