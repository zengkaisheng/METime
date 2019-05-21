//
//  ZLWebVC.h
//  我要留学
//
//  Created by Hank on 2016/12/12.
//  Copyright © 2016年 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEBaseVC.h"

@interface ZLWebVC : MEBaseVC


//@property (nonatomic, strong)NSString *URLString;
//URLString


- (instancetype)initWithUrl:(NSString *)urlString;

/**
 加载纯外部链接网页
 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;

/**
 加载本地网页
 
 @param string 本地HTML文件名
 */
- (void)loadWebHTMLSring:(NSString *)string;

/**
 加载外部链接POST请求(注意检查 XFWKJSPOST.html 文件是否存在 )
 
 @param string 需要POST的URL地址
 @param postData post请求块
 */
- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData;
- (instancetype)initWithUrl:(NSString *)urlString needReload:(BOOL)needReload;
@property(nonatomic,assign) BOOL isNeedShare;
@property(nonatomic,assign) BOOL isNeedH5Title;
@end
