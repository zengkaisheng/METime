//
//  ZLWebViewVC.m
//  我要留学
//
//  Created by Hank on 10/20/16.
//  Copyright © 2016 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import "ZLWebViewVC.h"
#import "UIWebView+FLUIWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MERelationIdModel.h"

#import "METhridProductDetailsVC.h"
#import "MECoupleModel.h"
#import "MECoupleMailDetalVC.h"
#import "MEPinduoduoCoupleModel.h"
#import "MEJDCoupleModel.h"
#import "MEJDCoupleMailDetalVC.h"
#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"

@interface ZLWebViewVC ()<UIWebViewDelegate>

@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ZLWebViewVC

- (void)popBackAction:(UIButton *)btn{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIButton *)btnRight{
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 70, 25);
    [btnRight setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
    [btnRight setTitle:@"返回" forState:UIControlStateNormal];
    btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 26);
    btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [btnRight setTitleColor:[UIColor colorWithHexString:@"e3e3e3"] forState:UIControlStateNormal];
    btnRight.titleLabel.font = kMeFont(15);
    [btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(popBackAction:) forControlEvents:UIControlEventTouchUpInside];
    return btnRight;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.webView setDelegateViews:nil];
    [self.progressView removeFromSuperview];
    [self.webView removeFromSuperview];
}

#pragma mark - Static Initializers

+ (ZLWebViewVC *)webBrowser {
    ZLWebViewVC *webBrowserVC = [ZLWebViewVC webBrowserWithConfiguration:nil];
    return webBrowserVC;
}

+ (ZLWebViewVC *)webBrowserWithConfiguration:(WKWebViewConfiguration *)configuration {
    ZLWebViewVC *webBrowserVC = [[ZLWebViewVC alloc] initWithConfiguration:configuration];
    return webBrowserVC;
}

#pragma mark - Initializers

- (id)init {
    return [self initWithConfiguration:nil];
}

- (id)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if(self) {
        self.uiWebView = [[UIWebView alloc] init];
        self.uiWebView.delegate = self;
        self.showProgress = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = self.uiWebView;
    [self.uiWebView setFrame: CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight)];
    [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.uiWebView setMultipleTouchEnabled:YES];
    [self.uiWebView setAutoresizesSubviews:YES];
    [self.uiWebView setScalesPageToFit:YES];
    [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.uiWebView];

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-self.progressView.frame.size.height, self.view.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [[self webView] setDelegateViews: self];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.showProgress && !self.progressView.superview) {
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
    self.progressView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.progressView.hidden = YES;
}

#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL {
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self loadRequest:request];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self loadURL:URL];
}

-(void)loadRequest:(NSURLRequest *)request{
    [self.uiWebView loadRequest:request];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler: (void (^)(id, NSError *))completionHandler{
    if (self.webView) {
        [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}


#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}
#pragma mark - UIWebView Delegate Methods

- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType{
    if(webView == self.uiWebView) {
        self.uiWebViewCurrentURL = request.URL;
        self.uiWebViewIsLoading = YES;
        [self fakeProgressViewStartLoading];
    }
    return YES;
}
- (void) webViewDidStartLoad: (UIWebView *) webView{

}
- (void) webView: (UIWebView *) webView didFailLoadWithError: (NSError *) error{
    if(!self.uiWebView.isLoading) {
        self.uiWebViewIsLoading = NO;
        [self fakeProgressBarStopLoading];
    }
}
- (void) webViewDidFinishLoad: (UIWebView *) webView{
    //注意：加弱引用是防止网络很差时，webview未加载结束，pop当前控制器崩溃，具体原因还不知道。

    kMeWEAKSELF
    if(webView == weakSelf.uiWebView) {
        if(!weakSelf.uiWebView.isLoading) {
            weakSelf.uiWebViewIsLoading = NO;
            [weakSelf fakeProgressBarStopLoading];
        }
        self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

        kMeWEAKSELF
        //淘宝授权
        self.jsContext[@"onRelationIdSuccess"] = ^(){
            NSArray<JSValue *> *args = [JSContext currentArguments];
            NSString *session = args[0].toString;
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@"正在授权..."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:YES];
                });
            });
            
            [MEPublicNetWorkTool postTaobaokePublisherInfoSaveWithSession:session successBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                MERelationIdModel *relation_idmodel = [MERelationIdModel mj_objectWithKeyValues:responseObject.data];
                NSString *relation_id = kMeUnNilStr(relation_idmodel.relation_id);
                if(kMeUnNilStr(relation_id).length == 0 || [relation_id isEqualToString:@"0"]){
//              [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"加入失败,请先授权"];
//              [strongSelf hideWithBlock:strongSelf.finishBlock isSucess:YES];
                }else{
                    kCurrentUser.relation_id = kMeUnNilStr(relation_id);
                    [kCurrentUser save];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        if (strongSelf.authorizeBlock) {
                            strongSelf.authorizeBlock();
                        }
                    });
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(id object) {
            }];
        };
        //跳转商品详情
        self.jsContext[@"openProductDetail"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    NSString *product_id = kMeUnNilStr(info[@"product_id"]);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:[product_id integerValue]];
                        [strongSelf.navigationController pushViewController:dvc animated:YES];
                    });
                }
            }
        };
        //跳转淘宝优惠券详情
        self.jsContext[@"openTbCouponDetail"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MECoupleModel *TBmodel = [MECoupleModel mj_objectWithKeyValues:info];
                        TBmodel.min_ratio = [kMeUnNilStr(info[@"min_ratio"]) floatValue];
                        TBmodel.num_iid = kMeUnNilStr(info[@"tbk_num_iids"]);
                        TBmodel.coupon_id = kMeUnNilStr(info[@"tbk_coupon_id"]);
                        TBmodel.coupon_share_url = kMeUnNilStr(info[@"tbk_coupon_share_url"]);
                        
                        if([kMeUnNilStr(info[@"tbk_coupon_id"]) length] > 0){
                            MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc] initWithProductrId:[NSString stringWithFormat:@"%@",kMeUnNilStr(info[@"tbk_num_iids"])] couponId:kMeUnNilStr(info[@"tbk_coupon_id"]) couponurl:kMeUnNilStr(info[@"tbk_coupon_share_url"]) Model:TBmodel];
//                            dvc.recordType = 1;
                            [strongSelf.navigationController pushViewController:dvc animated:YES];
                        }else{
                            TBmodel.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(info[@"tbk_coupon_share_url"])];//;
                            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:TBmodel];
//                            vc.recordType = 1;
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                        }
                    });
                }
            }
        };
        //跳转拼多多优惠券详情
        self.jsContext[@"openPddCouponDetail"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MEPinduoduoCoupleModel *PDDModel = [[MEPinduoduoCoupleModel alloc] init];
                        PDDModel.goods_id = [NSString stringWithFormat:@"%@",kMeUnNilStr(info[@"ddk_goods_id"])];
                        CGFloat min_ratio = [kMeUnNilStr(info[@"min_ratio"]) floatValue];
                        PDDModel.min_ratio = min_ratio;
                        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc] initWithPinduoudoModel:PDDModel];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    });
                }
            }
        };
        //跳转京东优惠券详情
        self.jsContext[@"openJdCouponDetail"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MEJDCoupleModel *JDModel = [[MEJDCoupleModel alloc] init];
                        JDModel.materialUrl = kMeUnNilStr(info[@"jd_material_url"]);
                        
                        CouponContentInfo *couponInfoModel = [CouponContentInfo new];
                        couponInfoModel.link = kMeUnNilStr(info[@"jd_link"]);
                        couponInfoModel.discount = [NSString stringWithFormat:@"%@",kMeUnNilStr(info[@"discount"])];
                        couponInfoModel.useStartTime = [NSString stringWithFormat:@"%@",kMeUnNilStr(info[@"useStartTime"])];
                        couponInfoModel.useEndTime = [NSString stringWithFormat:@"%@",kMeUnNilStr(info[@"useEndTime"])];
                        
                        CouponInfo *couponInfo = [CouponInfo new];
                        couponInfo.couponList = @[couponInfoModel];
                        
                        JDModel.couponInfo = couponInfo;
                        
                        ImageInfo *imgInfo = [ImageInfo new];
                        NSArray *imageList = [NSJSONSerialization JSONObjectWithData:[kMeUnNilStr(info[@"imageList"]) dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:nil];
                        imgInfo.imageList = imageList;
                        JDModel.imageInfo = imgInfo;
                        
                        JDModel.skuName = kMeUnNilStr(info[@"skuName"]);
                        
                        PriceInfo *priceInfo = [PriceInfo new];
                        priceInfo.price = [NSString stringWithFormat:@"%@",kMeUnNilStr(info[@"price"])];
                        JDModel.priceInfo = priceInfo;
                        JDModel.min_ratio = [kMeUnNilStr(info[@"min_ratio"]) floatValue];
                        
                        MEJDCoupleMailDetalVC *vc = [[MEJDCoupleMailDetalVC alloc]initWithModel:JDModel];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    });
                }
            }
        };
        //打开分享链接
        self.jsContext[@"openNativeShareLink"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(info[@"shareImage"])]]];
                        [strongSelf shareWithUrl:kMeUnNilStr(info[@"sharWebpageUrl"]) title:kMeUnNilStr(info[@"shareTitle"]) image:image description:kMeUnNilStr(info[@"shareDescriptionBody"]) type:UMSocialPlatformType_WechatSession];
                    });
                }
            }
        };
        //打开分享文本
        self.jsContext[@"openNativeShareText"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf shareWithUrl:MEIPShare title:@"一款自买省钱分享赚钱的购物神器！" image:kMeGetAssetImage(@"icon-wgvilogo") description:kMeUnNilStr(info[@"shareContent"]) type:UMSocialPlatformType_WechatTimeLine];
                    });
                }
            }
        };
        //打开淘宝活动
        self.jsContext[@"openTbActivity"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf openTbActivityWithActivityUrl:kMeUnNilStr(info[@"TBActivityUrl"])];
                    });
                }
            }
        };
        //打开砍价活动详情
        self.jsContext[@"openBargainDetail"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if([MEUserInfoModel isLogin]){
                            MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:[kMeUnNilStr(info[@"bargain_id"]) integerValue] myList:NO];
                            [strongSelf.navigationController pushViewController:bargainVC animated:YES];
                        }else {
                            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                                MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:[kMeUnNilStr(info[@"bargain_id"]) integerValue] myList:NO];
                                [strongSelf.navigationController pushViewController:bargainVC animated:YES];
                            } failHandler:^(id object) {
                                
                            }];
                        }
                    });
                }
            }
        };
        //打开拼团活动详情
        self.jsContext[@"openGroupInfo"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if([MEUserInfoModel isLogin]){
                            MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:[kMeUnNilStr(info[@"product_id"]) integerValue]];
                            [strongSelf.navigationController pushViewController:groupVC animated:YES];
                        }else {
                            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                                MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:[kMeUnNilStr(info[@"product_id"]) integerValue]];
                                [strongSelf.navigationController pushViewController:groupVC animated:YES];
                            } failHandler:^(id object) {
                            }];
                        }
                    });
                }
            }
        };
        //打开签到活动详情
        self.jsContext[@"openPrizeDetails"] = ^(){
            kMeSTRONGSELF
            NSArray<JSValue *> *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *session = args[0].toString;
                NSDictionary *info = [NSString dictionaryWithJsonString:session];
                NSLog(@"info:%@",info);
                if ([info.allKeys count] > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if([MEUserInfoModel isLogin]){
                            MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:kMeUnNilStr(info[@"activity_id"])];
                            [strongSelf.navigationController pushViewController:prizeVC animated:YES];
                        }else {
                            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                                MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:kMeUnNilStr(info[@"activity_id"])];
                                [strongSelf.navigationController pushViewController:prizeVC animated:YES];
                            } failHandler:^(id object) {
                            }];
                        }
                    });
                }
            }
        };
    }
}

- (void)shareWithUrl:(NSString *)shareUrl title:(NSString *)title image:(UIImage *)image description:(NSString *)description type:(UMSocialPlatformType)type {
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    shareTool.sharWebpageUrl = shareUrl;
    NSLog(@"%@",MEIPShare);
    shareTool.shareTitle = title;
    shareTool.shareDescriptionBody = description;
    shareTool.shareImage = image;
    
    [shareTool shareWebPageToPlatformType:type success:^(id data) {
        NSLog(@"分享成功%@",data);
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        NSLog(@"分享失败%@",error);
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}
//淘宝活动
- (void)openTbActivityWithActivityUrl:(NSString *)activityUrl{
    kMeWEAKSELF
    if([MEUserInfoModel isLogin]){
        [weakSelf checkRelationIdWithUrl:activityUrl];
    }else {
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf openTbActivityWithActivityUrl:activityUrl];
        } failHandler:nil];
    }
}

- (void)checkRelationIdWithUrl:(NSString *)url {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
        [self obtainTaoBaoAuthorizeWithUrl:url];
    }else{
        NSString *str;
        if (url.length > 0) {
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            str = [url stringByAppendingString:rid];
        }
        [self loadURLString:url];
    }
}
//获取淘宝授权
- (void)obtainTaoBaoAuthorizeWithUrl:(NSString *)url {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    [self loadURLString:str];
    kMeWEAKSELF
    self.authorizeBlock = ^{
        [weakSelf checkRelationIdWithUrl:url];
    };
}

@end
