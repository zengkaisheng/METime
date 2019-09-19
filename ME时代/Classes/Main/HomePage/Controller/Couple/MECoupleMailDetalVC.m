//
//  MECoupleMailDetalVC.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECoupleMailDetalVC.h"
#import "MECoupleMailHeaderVIew.h"
#import "MECoupleDetailModle.h"
#import "ZLWebViewVC.h"
#import "MECoupleModel.h"
#import "MECoupleMailDetalImageCell.h"
#import "MECouponInfo.h"
#import "MEPinduoduoCoupleModel.h"
#import "MEPinduoduoCoupleInfoModel.h"
#import "MEAddTbView.h"

#import "MEShareCouponVC.h"

#define MECoupleMailDetalVCbottomViewHeight 50

@interface MECoupleMailDetalVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_detailId;
    MECoupleModel *_detailModel;
    MECouponInfo *_couponInfoModel;
    MEPinduoduoCoupleModel *_pinduoduomodel;
    MEPinduoduoCoupleInfoModel *_pinduoduoDetailmodel;
    NSString *_Tpwd;
    NSString *_shareTpwd;
    NSString *_couponId;
    NSString *_couponurl;
    NSDictionary *_goods_promotion_url;
    NSDictionary *_sharegoods_promotion_url;
    CGFloat _min_ratio;
    NSString *_coupon_amount;
    NSString *_coupon_click_url;
    BOOL _isBuy;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic,strong) MECoupleMailHeaderVIew *headerView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *btnShare;
@property (nonatomic,strong) UIButton *btnBuy;
@property (strong, nonatomic) MEAddTbView *addTbVIew;

@end

@implementation MECoupleMailDetalVC

- (instancetype)initWithPinduoudoModel:(MEPinduoduoCoupleModel *)model{
    if(self = [super init]){
        _pinduoduomodel = model;
    }
    return self;
}

- (instancetype)initWithModel:(MECoupleModel *)model{
    if(self = [super init]){
        _detailModel = model;
        _detailId = model.num_iid;
        _coupon_click_url = model.coupon_click_url;
    }
    return self;
}

- (instancetype)initWithProductrId:(NSString *)ProductrId couponId:(NSString *)couponId couponurl:(NSString *)couponurl Model:(MECoupleModel *)model{
    if(self = [super init]){
        _detailId = ProductrId;
        _couponId = couponId;
        _couponurl = couponurl;
        _min_ratio = model.min_ratio;
        _coupon_amount = model.coupon_amount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    if(_pinduoduomodel){
        [self requestPinduoduoNetWork];
    }else{
        if(_detailModel){
            [self.view addSubview:self.tableView];
            [self.view addSubview:self.bottomView];
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView setUIWithModel:_detailModel];
            [self.tableView reloadData];
            if (kMeUnNilStr(_detailModel.coupon_end_time).length<=0||![self compareWithendTime:_detailModel.coupon_end_time]) {
                [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else {
                [self requestCoupleDetailNetWork];
            }
        }else{
            [self requestNetWork];
        }
    }
}
#pragma mark ---- 判断优惠券是否有效方法
- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

-(BOOL)downSecondHandle:(NSString *)aTimeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *endTimeStr = [self getTimeFromTimestamp:aTimeString];
    NSDate *endDate = [self timeWithTimeIntervalString:kMeUnNilStr(endTimeStr)]; //结束时间
    
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    NSDate *startDate = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"现在的时间 === %@",dateString);
    NSTimeInterval timeInterval = [endDate_tomorrow timeIntervalSinceDate:startDate];
    int timeout = timeInterval;
    return timeout>0?YES:NO;
}
//淘宝优惠券有效期判断方法
- (BOOL)compareWithendTime:(NSString *)endTime {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [dateFormatter dateFromString:kMeUnNilStr(endTime)];//结束时间
    
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    NSDate *startDate = [NSDate date];
    NSString* dateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"现在的时间 === %@",dateString);
    NSTimeInterval timeInterval = [endDate_tomorrow timeIntervalSinceDate:startDate];
    int timeout = timeInterval;
    return timeout>0?YES:NO;
}

#pragma mark ---- 将时间戳转换成时间
- (NSString *)getTimeFromTimestamp:(NSString *)time{
    //将对象类型的时间转换为NSDate类型
//    double time =1504667976;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    
    return timeStr;
}

- (void)requestCoupleDetailNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postCoupleDetailWithProductrId:_detailId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            NSArray *arr= responseObject.data[@"tbk_item_info_get_response"][@"results"][@"n_tbk_item"];
            if([arr isKindOfClass:[NSArray class]] && arr.count){
                MECoupleModel *model = [MECoupleModel mj_objectWithKeyValues:arr[0]];
                strongSelf->_detailModel.nick = kMeUnNilStr(model.nick);
                strongSelf->_detailModel.num_iid = kMeUnNilStr(model.num_iid);
                strongSelf->_detailModel.seller_id = kMeUnNilStr(model.seller_id);
                strongSelf->_detailModel.user_type = kMeUnNilStr(model.user_type);
                strongSelf->_detailModel.small_images = model.small_images;
//                strongSelf->_detailModel.min_ratio = strongSelf->_min_ratio;
//                strongSelf->_detailModel.coupon_amount = strongSelf->_coupon_amount;
//                strongSelf->_detailModel.coupon_click_url = strongSelf->_coupon_click_url;
            }else{
                strongSelf->_detailModel = [MECoupleModel new];
            }
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

- (void)requestPinduoduoNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postPinDuoduoGoodsDetailWithGoodsId:kMeUnNilStr(_pinduoduomodel.goods_id) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSArray *arr =  responseObject.data[@"goods_detail_response"][@"goods_details"];
         if(kMeUnArr(arr).count){
             strongSelf->_pinduoduoDetailmodel = [MEPinduoduoCoupleInfoModel mj_objectWithKeyValues:arr[0]];
             if (kMeUnNilStr(strongSelf->_pinduoduoDetailmodel.coupon_end_time).length<=0||![self downSecondHandle:strongSelf->_pinduoduoDetailmodel.coupon_end_time]) {
                 [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:self.view];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [strongSelf.navigationController popViewControllerAnimated:YES];
                 });
             }else {
                 strongSelf->_pinduoduoDetailmodel.min_ratio = strongSelf->_pinduoduomodel.min_ratio;
                 [strongSelf.view addSubview:strongSelf.tableView];
                 [strongSelf.view addSubview:strongSelf.bottomView];
                 strongSelf.tableView.tableHeaderView = strongSelf.headerView;
                 [strongSelf.headerView setPinduoduoUIWithModel:strongSelf->_pinduoduoDetailmodel];
                 [strongSelf.tableView reloadData];
             }
         }else{
            [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:self.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [strongSelf.navigationController popViewControllerAnimated:YES];
             });
         }
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        kMeSTRONGSELF
        [MEPublicNetWorkTool postCoupleDetailWithProductrId:strongSelf->_detailId successBlock:^(ZLRequestResponse *responseObject) {
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                NSArray *arr= responseObject.data[@"tbk_item_info_get_response"][@"results"][@"n_tbk_item"];
                if([arr isKindOfClass:[NSArray class]] && arr.count){
                    strongSelf->_detailModel = [MECoupleModel mj_objectWithKeyValues:arr[0]];
                    strongSelf->_detailModel.min_ratio = strongSelf->_min_ratio;
                    strongSelf->_detailModel.coupon_amount = strongSelf->_coupon_amount;
                }else{
                    strongSelf->_detailModel = [MECoupleModel new];
                }
                dispatch_semaphore_signal(semaphore);
            }else{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        kMeSTRONGSELF
        [MEPublicNetWorkTool postCoupleTbkCouponGetWithActivity_id:kMeUnNilStr(strongSelf->_couponId) item_id:kMeUnNilStr(strongSelf->_detailId) successBlock:^(ZLRequestResponse *responseObject) {
            strongSelf->_couponInfoModel = [MECouponInfo mj_objectWithKeyValues:responseObject.data[@"tbk_coupon_get_response"][@"data"]];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view];
            if (strongSelf->_couponInfoModel) {
                [strongSelf->_detailModel resetModelWithModel:strongSelf->_couponInfoModel];
                strongSelf->_detailModel.coupon_click_url = [NSString stringWithFormat:@"https:%@",strongSelf->_couponurl];
                [strongSelf.view addSubview:strongSelf.tableView];
                [strongSelf.view addSubview:strongSelf.bottomView];
                strongSelf.tableView.tableHeaderView = strongSelf.headerView;
                [strongSelf.headerView setUIWithModel:strongSelf->_detailModel];
                [strongSelf.tableView reloadData];
            }else {
                [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:strongSelf.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        });
    });
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_pinduoduomodel){
        return _pinduoduoDetailmodel.goods_gallery_urls.count;
    }else{
         return _detailModel.small_images.string.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_pinduoduomodel){
        MECoupleMailDetalImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECoupleMailDetalImageCell class]) forIndexPath:indexPath];
        kSDLoadImg(cell.imageView, kMeUnNilStr(_pinduoduoDetailmodel.goods_gallery_urls[indexPath.row]));
        return cell;
    }else{
        MECoupleMailDetalImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECoupleMailDetalImageCell class]) forIndexPath:indexPath];
        kSDLoadImg(cell.imageView, kMeUnNilStr(_detailModel.small_images.string[indexPath.row]));
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *viewGary = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    viewGary.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 22.5, 160, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 0, 80, 44)];
    lbl.text = @"宝贝详情";
    lbl.font = kMeFont(12);
    lbl.textColor = [UIColor colorWithHexString:@"333333"];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.backgroundColor = [UIColor whiteColor];
    [view addSubview:viewLine];
    [view addSubview:lbl];
    [view addSubview:viewGary];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)buyAction:(UIButton *)btn{
    if (btn != nil) {
        _isBuy = YES;
    }
    if([MEUserInfoModel isLogin]){
        if(_pinduoduomodel){
            if(_goods_promotion_url){
                if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
                    //                [self openAddTbView];
                    [self obtainTaoBaoAuthorizeWithBuyAction:YES];
                }else{
                    [self openTb];
                }
            }else{
                NSString *goodId = [NSString stringWithFormat:@"[%@]",kMeUnNilStr(_pinduoduomodel.goods_id)];
                kMeWEAKSELF
                [MEPublicNetWorkTool postPromotionUrlGenerateWithUid:kMeUnNilStr(kCurrentUser.uid) goods_id_list:goodId SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    NSArray *arr = responseObject.data[@"goods_promotion_url_generate_response"][@"goods_promotion_url_list"];
                    if(arr && arr.count){
                        strongSelf->_goods_promotion_url = arr[0];
                    }
                    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
                        //                [self openAddTbView];
                        [strongSelf obtainTaoBaoAuthorizeWithBuyAction:YES];
                    }else{
                        [strongSelf openTb];
                    }
                } failure:^(id object) {
                    
                }];
            }
        }else{
            if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
//                [self openAddTbView];
                [self obtainTaoBaoAuthorizeWithBuyAction:YES];
            }else{
                if(kMeUnNilStr(_Tpwd).length){
                    [self openTb];
                }else{
                    kMeWEAKSELF
                    NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
                    NSString *str = [kMeUnNilStr(_detailModel.coupon_click_url) stringByAppendingString:rid];
                    [MEPublicNetWorkTool postTaobaokeGetTpwdWithTitle:kMeUnNilStr(_detailModel.title) url:str logo:kMeUnNilStr(_detailModel.pict_url) successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        strongSelf->_Tpwd = kMeUnNilStr(responseObject.data[@"tbk_tpwd_create_response"][@"data"][@"model"]);
                        [strongSelf openTb];
                    } failure:^(id object) {
                        
                    }];
                }
            }
        }
    }else{
        kMeWEAKSELF
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf buyAction:nil];
        } failHandler:nil];
    }
}

- (void)shareAction:(UIButton *)btn{
    if([MEUserInfoModel isLogin]){
        if(_pinduoduomodel){
            NSString *typeStr;
            //统计点击数
            switch (self.recordType) {
                case 1://首页
                    typeStr = @"24";
                    break;
                case 2://优选
                    typeStr = @"10";
                    break;
                case 3://动态
                    typeStr = @"32";
                    break;
                case 4://推送
                    typeStr = @"44";
                    break;
                case 5://搜索
                    typeStr = @"56";
                    break;
                default:
                    break;
            }
            NSDictionary *params = @{@"goods_id":kMeUnNilStr(_pinduoduomodel.goods_id),@"goods_name":kMeUnNilStr(_pinduoduomodel.goods_name),@"uid":kMeUnNilStr(kCurrentUser.uid)};
            [self saveClickRecordsWithType:typeStr params:params];

            //拼多多
            if(_sharegoods_promotion_url){

                MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithPDDModel:_pinduoduoDetailmodel codeword:_sharegoods_promotion_url[@"we_app_web_view_short_url"]];
                [self.navigationController pushViewController:shareVC animated:YES];
            }else{
                NSString *goodId = [NSString stringWithFormat:@"[%@]",kMeUnNilStr(_pinduoduomodel.goods_id)];
                kMeWEAKSELF
                [MEPublicNetWorkTool postPromotionUrlGenerateWithUid:kMeUnNilStr(kCurrentUser.uid) goods_id_list:goodId SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    NSArray *arr = responseObject.data[@"goods_promotion_url_generate_response"][@"goods_promotion_url_list"];
                    if(arr && arr.count){
                        strongSelf->_sharegoods_promotion_url = arr[0];
                    }
                    
                    MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithPDDModel:strongSelf->_pinduoduoDetailmodel codeword:strongSelf->_sharegoods_promotion_url[@"we_app_web_view_short_url"]];
                    [strongSelf.navigationController pushViewController:shareVC animated:YES];
                    
                } failure:^(id object) {
                    
                }];
            }
        }else{
            if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
//                [self openAddTbView];
                [self obtainTaoBaoAuthorizeWithBuyAction:NO];
            }else{
                NSString *tbTypeStr;
                //统计点击数
                switch (self.recordType) {
                    case 1://首页
                        tbTypeStr = @"6";
                        break;
                    case 3://动态
                        tbTypeStr = @"28";
                        break;
                    case 4://推送
                        tbTypeStr = @"40";
                        break;
                    case 5://搜索
                        tbTypeStr = @"52";
                        break;
                    default:
                        break;
                }
                NSDictionary *params = @{@"num_iid":kMeUnNilStr(_detailModel.num_iid),@"item_title":kMeUnNilStr(_detailModel.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
                [self saveClickRecordsWithType:tbTypeStr params:params];

                //淘宝
                if(kMeUnNilStr(_Tpwd).length){
//                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                    pasteboard.string = kMeUnNilStr(_Tpwd);
//                    [MEShowViewTool showMessage:@"分享口令复制成功,请发给朋友" view:self.view];
                    MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithTBModel:_detailModel codeword:_Tpwd];
                    [self.navigationController pushViewController:shareVC animated:YES];
                }else{
                    kMeWEAKSELF
                    NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
                    NSString *str = [kMeUnNilStr(_detailModel.coupon_click_url) stringByAppendingString:rid];
                    [MEPublicNetWorkTool postTaobaokeGetTpwdWithTitle:kMeUnNilStr(_detailModel.title) url:str logo:kMeUnNilStr(_detailModel.pict_url) successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        strongSelf->_Tpwd = kMeUnNilStr(responseObject.data[@"tbk_tpwd_create_response"][@"data"][@"model"]);
//                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                        pasteboard.string = kMeUnNilStr(strongSelf->_Tpwd);
//                        [MEShowViewTool showMessage:@"分享口令复制成功,请发给朋友" view:strongSelf.view];
                        MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithTBModel:strongSelf->_detailModel codeword:strongSelf->_Tpwd];
                        [strongSelf.navigationController pushViewController:shareVC animated:YES];
                    } failure:^(id object) {
                        
                    }];
                }
            }
        }
    }else{
        kMeWEAKSELF
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf shareAction:nil];
        } failHandler:nil];
    }
}

//获取淘宝授权
- (void)obtainTaoBaoAuthorizeWithBuyAction:(BOOL)isBuy {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
    webVC.showProgress = YES;
    webVC.title = @"获取淘宝授权";
    [webVC loadURL:[NSURL URLWithString:str]];
    kMeWEAKSELF
    webVC.authorizeBlock = ^{
        kMeSTRONGSELF
        if (isBuy) {
            [strongSelf buyAction:nil];
        }else {
            [strongSelf shareAction:nil];
        }
    };
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)openAddTbView{
    kMeWEAKSELF
    [MEPublicNetWorkTool postShareTaobaokeGetInviterUrlWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSString *strApi = kMeUnNilStr(responseObject.data[@"url"]);
        NSURL *url = [NSURL URLWithString:strApi];
        [[UIApplication sharedApplication] openURL:url];
        strongSelf.addTbVIew.url = strApi;
        [strongSelf.addTbVIew show];
    } failure:^(id object) {
        
    }];
}

- (void)openTb{
    if(_pinduoduomodel){
        NSString *typeStr;
        //统计点击数
        if (_isBuy) {//购买
            switch (self.recordType) {
                case 1://首页
                    typeStr = @"23";
                    break;
                case 2://优选
                    typeStr = @"9";
                    break;
                case 3://动态
                    typeStr = @"31";
                    break;
                case 4://推送
                    typeStr = @"43";
                    break;
                case 5://搜索
                    typeStr = @"55";
                    break;
                default:
                    break;
            }
        }else {//领券
            switch (self.recordType) {
                case 1://首页
                    typeStr = @"22";
                    break;
                case 2://优选
                    typeStr = @"8";
                    break;
                case 3://动态
                    typeStr = @"30";
                    break;
                case 4://推送
                    typeStr = @"42";
                    break;
                case 5://搜索
                    typeStr = @"54";
                    break;
                default:
                    break;
            }
        }
        
        NSDictionary *params = @{@"goods_id":kMeUnNilStr(_pinduoduomodel.goods_id),@"goods_name":kMeUnNilStr(_pinduoduomodel.goods_name),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:typeStr params:params];
        
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"pinduoduo://"]]) {
            NSString *str = kMeUnNilStr(_goods_promotion_url[@"we_app_web_view_url"]);
            NSString *newUrl = [str stringByReplacingOccurrencesOfString:@"https://mobile.yangkeduo.com/" withString:@"pinduoduo://com.xunmeng.pinduoduo/"];
            NSURL *url = [NSURL URLWithString:newUrl];
            [[UIApplication sharedApplication] openURL:url];
        }else {
            NSURL *newurl = [NSURL URLWithString:kMeUnNilStr(_goods_promotion_url[@"short_url"])];
            [[UIApplication sharedApplication] openURL:newurl];
        }
    }else{
        
        NSString *tbTypeStr;
        //统计点击数
        if (!_isBuy) {//领券
            switch (self.recordType) {
                case 1://首页
                    tbTypeStr = @"4";
                    break;
                case 3://动态
                    tbTypeStr = @"26";
                    break;
                case 4://推送
                    tbTypeStr = @"38";
                    break;
                case 5://搜索
                    tbTypeStr = @"50";
                    break;
                default:
                    break;
            }
        }else {//购买
            switch (self.recordType) {
                case 1://首页
                    tbTypeStr = @"5";
                    break;
                case 3://动态
                    tbTypeStr = @"27";
                    break;
                case 4://推送
                    tbTypeStr = @"39";
                    break;
                case 5://搜索
                    tbTypeStr = @"51";
                    break;
                default:
                    break;
            }
        }
        NSDictionary *params = @{@"num_iid":kMeUnNilStr(_detailModel.num_iid),@"item_title":kMeUnNilStr(_detailModel.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:tbTypeStr params:params];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = kMeUnNilStr(_Tpwd);
        NSURL *url = [NSURL URLWithString:@"taobao://"];
        // 判断当前系统是否有安装淘宝客户端
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            NSString *str = [kMeUnNilStr(_detailModel.coupon_click_url) stringByAppendingString:rid];
            //kMeUnNilStr(_detailModel.coupon_click_url)
            NSURL *url = [NSURL URLWithString:str];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-MECoupleMailDetalVCbottomViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailDetalImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECoupleMailDetalImageCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = SCREEN_WIDTH;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MECoupleMailHeaderVIew *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MECoupleMailHeaderVIew" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MECoupleMailHeaderVIewHeight);
        kMeWEAKSELF
        _headerView.getCoupleBlock = ^{
            kMeSTRONGSELF
            strongSelf->_isBuy = NO;
            [strongSelf buyAction:nil];
//            ZLWebViewVC *vc = [[ZLWebViewVC alloc]init];
//            [vc loadURL:[NSURL URLWithString:kMeUnNilStr(strongSelf->_detailModel.Quan_link)]];
//            vc.title = @"优惠卷";
//            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-MECoupleMailDetalVCbottomViewHeight, SCREEN_WIDTH, MECoupleMailDetalVCbottomViewHeight)];
        _bottomView.backgroundColor =[UIColor colorWithHexString:@"F70054"];
        [_bottomView addSubview:self.btnShare];
        [_bottomView addSubview:self.btnBuy];
    }
    return _bottomView;
}

- (UIButton *)btnBuy{
    if(!_btnBuy){
        _btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBuy.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, MECoupleMailDetalVCbottomViewHeight);
        [_btnBuy addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnBuy.backgroundColor =[UIColor colorWithHexString:@"F70054"];
        [_btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_btnBuy setTitle:@"立即购买" forState:UIControlStateNormal];
        if(_pinduoduomodel){
            if (self.isDynamic) {
                NSString *str = [NSString stringWithFormat:@"立即购买最低%.2f佣金",_pinduoduomodel.min_ratio];
                [_btnBuy setTitle:str forState:UIControlStateNormal];
            }else {
                NSString *str = [NSString stringWithFormat:@"立即购买最低%@佣金",[MECommonTool changeformatterWithFen:@(_pinduoduomodel.min_ratio)]];
                [_btnBuy setTitle:str forState:UIControlStateNormal];
            }
        }else{
            NSString *str = [NSString stringWithFormat:@"立即购买最低%.2f佣金",_detailModel.min_ratio];
            [_btnBuy setTitle:str forState:UIControlStateNormal];
        }
        _btnBuy.titleLabel.font = kMeFont(15);
    }
    return _btnBuy;
}

- (UIButton *)btnShare{
    if(!_btnShare){
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, MECoupleMailDetalVCbottomViewHeight);
        [_btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnShare.backgroundColor = [UIColor colorWithHexString:@"FC8F0C"];
        [_btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnShare.hidden = ![WXApi isWXAppInstalled];
        if(_pinduoduomodel){
            if (self.isDynamic) {
                NSString *str = [NSString stringWithFormat:@"分享购买最低%.2f佣金",_pinduoduomodel.min_ratio];
                [_btnShare setTitle:str forState:UIControlStateNormal];
            }else {
                NSString *str = [NSString stringWithFormat:@"分享购买最低%@佣金",[MECommonTool changeformatterWithFen:@(_pinduoduomodel.min_ratio)]];
                [_btnShare setTitle:str forState:UIControlStateNormal];
            }
        }else{
//            [_btnShare setTitle:@"马上分享" forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"分享购买最低%.2f佣金",_detailModel.min_ratio];
            [_btnShare setTitle:str forState:UIControlStateNormal];
        }
        _btnShare.titleLabel.font = kMeFont(15);
    }
    return _btnShare;
}

- (MEAddTbView *)addTbVIew{
    if(!_addTbVIew){
        _addTbVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEAddTbView" owner:nil options:nil] lastObject];
        _addTbVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        kMeWEAKSELF
        _addTbVIew.finishBlock = ^(BOOL sucess) {
//            kMeSTRONGSELF
            if(sucess){
                
            }
        };
    }
    return _addTbVIew;
}

@end
