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
    }
    return self;
}

- (instancetype)initWithProductrId:(NSString *)ProductrId couponId:(NSString *)couponId couponurl:(NSString *)couponurl{
    if(self = [super init]){
        _detailId = ProductrId;
        _couponId = couponId;
        _couponurl = couponurl;
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
        }else{
            [self requestNetWork];
        }
    }
}

- (void)requestPinduoduoNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postPinDuoduoGoodsDetailWithGoodsId:kMeUnNilStr(_pinduoduomodel.goods_id) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSArray *arr =  responseObject.data[@"goods_detail_response"][@"goods_details"];
         if(kMeUnArr(arr).count){
             strongSelf->_pinduoduoDetailmodel =[MEPinduoduoCoupleInfoModel mj_objectWithKeyValues:arr[0]];
             [strongSelf.view addSubview:strongSelf.tableView];
             [strongSelf.view addSubview:strongSelf.bottomView];
             strongSelf.tableView.tableHeaderView = strongSelf.headerView;
             [strongSelf.headerView setPinduoduoUIWithModel:strongSelf->_pinduoduoDetailmodel];
             [strongSelf.tableView reloadData];
         }else{
            [strongSelf.navigationController popViewControllerAnimated:YES];
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
            [strongSelf->_detailModel resetModelWithModel:strongSelf->_couponInfoModel];
            strongSelf->_detailModel.coupon_click_url = [NSString stringWithFormat:@"https:%@",strongSelf->_couponurl];
            [strongSelf.view addSubview:strongSelf.tableView];
            [strongSelf.view addSubview:strongSelf.bottomView];
            strongSelf.tableView.tableHeaderView = strongSelf.headerView;
            [strongSelf.headerView setUIWithModel:strongSelf->_detailModel];
            [strongSelf.tableView reloadData];
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
    if([MEUserInfoModel isLogin]){
        if(_pinduoduomodel){
            if(_goods_promotion_url){
                [self openTb];
            }else{
                NSString *goodId = [NSString stringWithFormat:@"[%@]",kMeUnNilStr(_pinduoduomodel.goods_id)];
                kMeWEAKSELF
                [MEPublicNetWorkTool postPromotionUrlGenerateWithUid:kMeUnNilStr(kCurrentUser.uid) goods_id_list:goodId SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    NSArray *arr = responseObject.data[@"goods_promotion_url_generate_response"][@"goods_promotion_url_list"];
                    if(arr && arr.count){
                        strongSelf->_goods_promotion_url = arr[0];
                    }
                    [strongSelf openTb];
                } failure:^(id object) {
                    
                }];
            }
        }else{
            if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
                [self openAddTbView];
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
            //拼多多
            if(_sharegoods_promotion_url){
                MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
                shareTool.sharWebpageUrl = _sharegoods_promotion_url[@"we_app_web_view_short_url"];
                shareTool.shareTitle = kMeUnNilStr(_pinduoduomodel.goods_name);
                shareTool.shareDescriptionBody = kMeUnNilStr(_pinduoduomodel.goods_name);;
                shareTool.shareImage = _headerView.imgPic.image;
                [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                    NSLog(@"分享成功%@",data);
                } failure:^(NSError *error) {
                    
                }];
            }else{
                NSString *goodId = [NSString stringWithFormat:@"[%@]",kMeUnNilStr(_pinduoduomodel.goods_id)];
                kMeWEAKSELF
                [MEPublicNetWorkTool postPromotionUrlGenerateWithUid:kMeUnNilStr(kCurrentUser.uid) goods_id_list:goodId SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    NSArray *arr = responseObject.data[@"goods_promotion_url_generate_response"][@"goods_promotion_url_list"];
                    if(arr && arr.count){
                        strongSelf->_sharegoods_promotion_url = arr[0];
                    }
                    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:strongSelf];
                    shareTool.sharWebpageUrl = strongSelf->_sharegoods_promotion_url[@"we_app_web_view_short_url"];
                    shareTool.shareTitle = kMeUnNilStr(strongSelf->_pinduoduomodel.goods_name);
                    shareTool.shareDescriptionBody = kMeUnNilStr(strongSelf->_pinduoduomodel.goods_name);;
                    shareTool.shareImage = strongSelf->_headerView.imgPic.image;
                    [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                        NSLog(@"分享成功%@",data);
                    } failure:^(NSError *error) {
                        
                    }];
                    
                } failure:^(id object) {
                    
                }];
            }
        }else{
            if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
                [self openAddTbView];
            }else{
                //淘宝
                if(kMeUnNilStr(_Tpwd).length){
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = kMeUnNilStr(_Tpwd);
                    [MEShowViewTool showMessage:@"分享口令复制成功,请发给朋友" view:self.view];
                }else{
                    kMeWEAKSELF
                    NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
                    NSString *str = [kMeUnNilStr(_detailModel.coupon_click_url) stringByAppendingString:rid];
                    [MEPublicNetWorkTool postTaobaokeGetTpwdWithTitle:kMeUnNilStr(_detailModel.title) url:str logo:kMeUnNilStr(_detailModel.pict_url) successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        strongSelf->_Tpwd = kMeUnNilStr(responseObject.data[@"tbk_tpwd_create_response"][@"data"][@"model"]);
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = kMeUnNilStr(strongSelf->_Tpwd);
                        [MEShowViewTool showMessage:@"分享口令复制成功,请发给朋友" view:strongSelf.view];
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
        [_btnBuy setTitle:@"立即购买" forState:UIControlStateNormal];
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
            NSString *str = [NSString stringWithFormat:@"分享购买最低%@佣金",[MECommonTool changeformatterWithFen:@(_pinduoduomodel.min_ratio)]];
            [_btnShare setTitle:str forState:UIControlStateNormal];
        }else{
            [_btnShare setTitle:@"马上分享" forState:UIControlStateNormal];
        }
        _btnShare.titleLabel.font = kMeFont(15);
    }
    return _btnShare;
}

- (MEAddTbView *)addTbVIew{
    if(!_addTbVIew){
        _addTbVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEAddTbView" owner:nil options:nil] lastObject];
        _addTbVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        kMeWEAKSELF
        _addTbVIew.finishBlock = ^(BOOL sucess) {
            kMeSTRONGSELF
            if(sucess){
                
            }
        };
    }
    return _addTbVIew;
}

@end
