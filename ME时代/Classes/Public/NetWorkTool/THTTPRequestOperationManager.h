//
//  THTTPRequestOperationManager.h
//  我要留学
//
//  Created by Hank on 10/13/16.
//  Copyright © 2016 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZLRequestResponse;
@class MENetListModel;
typedef void(^RequestResponse)(ZLRequestResponse *responseObject);
typedef void(^MERequestNetListModelBlock)(MENetListModel *responseObject);

#define THTTPManager [THTTPRequestOperationManager new]

@interface THTTPRequestOperationManager : NSObject

//是否添加公共参数
@property (nonatomic, assign) BOOL isAddCommonParameter;

/**
 *  检测网络状态
 *
 *  @return 网络是否错误 YES error
 */
+ (BOOL)reachability;

/**
 *  post请求
 *
 */
- (void)postWithParameter:(NSDictionary *)parameter strUrl:(NSString *)strUrl success:(RequestResponse)success
                              failure:(kMeObjBlock)failure;
/**
 *  post请求 加HUD
 *
 */
- (void)postWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
        hudAddedToView:(UIView *)view success:(RequestResponse)success
               failure:(kMeObjBlock)failure;
/**
 *  get请求
 *
 */
- (void)getWithParameter:(NSDictionary *)parameter strUrl:(NSString *)strUrl success:(RequestResponse)success
                             failure:(kMeObjBlock)failure;
/**
 *  get请求 加HUD
 *
 */
- (void)getWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
       hudAddedToView:(UIView *)view success:(RequestResponse)success
              failure:(kMeObjBlock)failure;

- (void)postWithUrlStr:(NSString *)urlStr
             parameter:(NSDictionary *)parameter
                  data:(NSData *)data
      showProgressView:(UIView *)view
               success:(RequestResponse)success
               failure:(kMeObjBlock)failure;

//原生的get
- (void)orgialGetWithUrlStr:(NSString *)urlStr parameter:(NSDictionary *)parameter
                    success:(kMeObjBlock)success
                    failure:(kMeObjBlock)failure;
@end
