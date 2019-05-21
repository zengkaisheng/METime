//
//  ZLWebViewVC.h
//  我要留学
//
//  Created by Hank on 10/20/16.
//  Copyright © 2016 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import "MEBaseVC.h"
#import <WebKit/WebKit.h>
#import "FLWebViewProvider.h"

@interface ZLWebViewVC : MEBaseVC

@property (nonatomic, weak) UIView <FLWebViewProvider> *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, strong)NSString *URLString;

#pragma mark - Static Initializers

+ (ZLWebViewVC *)webBrowser;
+ (ZLWebViewVC *)webBrowserWithConfiguration:(WKWebViewConfiguration *)configuration NS_AVAILABLE_IOS(8_0);

#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadURLString:(NSString *)URLString;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler: (void (^)(id, NSError *))completionHandler;



@end
