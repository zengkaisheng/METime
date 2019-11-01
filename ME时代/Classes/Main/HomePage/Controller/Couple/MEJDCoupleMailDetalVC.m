//
//  MEJDCoupleMailDetalVC.m
//  志愿星
//
//  Created by hank on 2019/2/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEJDCoupleMailDetalVC.h"
#import "MEJDCoupleModel.h"
#import "MECoupleMailHeaderVIew.h"
#import "MECoupleMailDetalImageCell.h"
#import "MEShareCouponVC.h"

#define MEJDCoupleMailDetalVCbottomViewHeight 50

@interface MEJDCoupleMailDetalVC ()<UITableViewDelegate,UITableViewDataSource>{
     MEJDCoupleModel *_detailModel;
    NSString *_Tpwd;
    NSString *_shareTpwd;
    BOOL _isBuy;
}
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic,strong) MECoupleMailHeaderVIew *headerView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *btnShare;
@property (nonatomic,strong) UIButton *btnBuy;

@end

@implementation MEJDCoupleMailDetalVC


- (instancetype)initWithModel:(MEJDCoupleModel *)model{
    if(self = [super init]){
        _detailModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setJDUIWithModel:_detailModel];
    [self.tableView reloadData];
    
    CouponContentInfo *couponInfoModel = [CouponContentInfo new];
    if(kMeUnArr(_detailModel.couponInfo.couponList).count>0){
        couponInfoModel = _detailModel.couponInfo.couponList[0];
    }
    if (kMeUnNilStr(couponInfoModel.useEndTime).length<=0||![self downSecondHandle:[NSString stringWithFormat:@"%@",@([couponInfoModel.useEndTime doubleValue]/1000)]]) {
        [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

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
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    
    return timeStr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _detailModel.imageInfo.imageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailDetalImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECoupleMailDetalImageCell class]) forIndexPath:indexPath];
    ImageContentInfo *couponInfoModel = _detailModel.imageInfo.imageList[indexPath.row];
    kSDLoadImg(cell.imageView, kMeUnNilStr(couponInfoModel.url));
    return cell;
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
        if(kMeUnNilStr(_Tpwd).length){
            [self openTb];
        }else{
            CouponContentInfo *couponInfoModel = [CouponContentInfo new];
            if(kMeUnArr(_detailModel.couponInfo.couponList).count>0){
                couponInfoModel = _detailModel.couponInfo.couponList[0];
            }
            kMeWEAKSELF
            [MEPublicNetWorkTool postJDPromotionUrlGenerateWithUid:kCurrentUser.uid materialUrl:kMeUnNilStr(_detailModel.materialUrl) couponUrl:kMeUnNilStr(couponInfoModel.link) successBlock:^(ZLRequestResponse *responseObject) {
                if(responseObject.data[@"msg"]){
                    [MEShowViewTool showMessage:kMeUnNilStr(responseObject.data[@"msg"]) view:kMeCurrentWindow];
                }else{
                    kMeSTRONGSELF
                    strongSelf->_Tpwd = responseObject.data[@"shortURL"];
                    [strongSelf openTb];
                }
            } failure:^(id object) {
                
            }];
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
        NSString *typeStr;
        //统计点击数
        switch (self.recordType) {
            case 1://首页
                typeStr = @"20";
                break;
            case 3://动态
                typeStr = @"36";
                break;
            case 4://推送
                typeStr = @"48";
                break;
            case 5://搜索
                typeStr = @"60";
                break;
            default:
                break;
        }
        NSDictionary *params = @{@"skuId":kMeUnNilStr(_detailModel.skuId),@"skuName":kMeUnNilStr(_detailModel.skuName),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:typeStr params:params];

        if(_shareTpwd){
//            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
//            shareTool.sharWebpageUrl =kMeUnNilStr(_shareTpwd);
//            shareTool.shareTitle = kMeUnNilStr(_detailModel.skuName);
//            shareTool.shareDescriptionBody = kMeUnNilStr(_detailModel.skuName);
//            shareTool.shareImage = _headerView.imgPic.image;
//            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
//                NSLog(@"分享成功%@",data);
//            } failure:^(NSError *error) {
//
//            }];
            MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithJDModel:_detailModel codeword:kMeUnNilStr(_shareTpwd)];
            [self.navigationController pushViewController:shareVC animated:YES];
        }else{
            CouponContentInfo *couponInfoModel = [CouponContentInfo new];
            if(kMeUnArr(_detailModel.couponInfo.couponList).count>0){
                couponInfoModel = _detailModel.couponInfo.couponList[0];
            }
            kMeWEAKSELF
            [MEPublicNetWorkTool postJDPromotionUrlGenerateWithUid:kCurrentUser.uid materialUrl:kMeUnNilStr(_detailModel.materialUrl) couponUrl:kMeUnNilStr(couponInfoModel.link) successBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                strongSelf->_shareTpwd = responseObject.data[@"shortURL"];
//                MEShareTool *shareTool = [MEShareTool me_instanceForTarget:strongSelf];
//                shareTool.sharWebpageUrl = strongSelf->_shareTpwd;
//                shareTool.shareTitle = kMeUnNilStr(strongSelf->_detailModel.skuName);
//                shareTool.shareDescriptionBody = kMeUnNilStr(strongSelf->_detailModel.skuName);
//                shareTool.shareImage = strongSelf->_headerView.imgPic.image;
//                [shareTool showShareView:kShareWebPageContentType success:^(id data) {
//                    NSLog(@"分享成功%@",data);
//                } failure:^(NSError *error) {
//
//                }];
                MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithJDModel:strongSelf->_detailModel codeword:kMeUnNilStr(strongSelf->_shareTpwd)];
                [strongSelf.navigationController pushViewController:shareVC animated:YES];
            } failure:^(id object) {
                
            }];
        }
    }else{
        kMeWEAKSELF
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf shareAction:nil];
        } failHandler:nil];
    }
}

 - (void)openTb{
     //统计点击数
     NSString *typeStr;
     if (_isBuy) {//购买
         switch (self.recordType) {
             case 1://首页
                 typeStr = @"19";
                 break;
             case 3://动态
                 typeStr = @"35";
                 break;
             case 4://推送
                 typeStr = @"47";
                 break;
             case 5://搜索
                 typeStr = @"59";
                 break;
             default:
                 break;
         }
     }else {//领券
         switch (self.recordType) {
             case 1://首页
                 typeStr = @"18";
                 break;
             case 3://动态
                 typeStr = @"34";
                 break;
             case 4://推送
                 typeStr = @"46";
                 break;
             case 5://搜索
                 typeStr = @"58";
                 break;
             default:
                 break;
         }
     }
     NSDictionary *params = @{@"skuId":kMeUnNilStr(_detailModel.skuId),@"skuName":kMeUnNilStr(_detailModel.skuName),@"uid":kMeUnNilStr(kCurrentUser.uid)};
     [self saveClickRecordsWithType:typeStr params:params];

//     NSString *url = [[NSString stringWithFormat:@"openapp.jdmobile://virtual?params={\"category\":\"jump\",\"des\":\"productDetail\",\"skuId\":\"%@\",\"sourceType\":\"JSHOP_SOURCE_TYPE\",\"sourceValue\":\"JSHOP_SOURCE_VALUE\"}",kMeUnNilStr(_detailModel.skuId)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString *url = [[NSString stringWithFormat:@"openapp.jdmobile://virtual?params={\"category\":\"jump\",\"des\":\"m\",\"url\":\"%@\"}",kMeUnNilStr(_Tpwd)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSURL * requestURL = [NSURL URLWithString:url];
     if ([[UIApplication sharedApplication] canOpenURL:requestURL]) {
         [[UIApplication sharedApplication] openURL:requestURL];
     } else {
         NSURL *newurl = [NSURL URLWithString:kMeUnNilStr(_Tpwd)];
         [[UIApplication sharedApplication] openURL:newurl];
     }
 }

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-MEJDCoupleMailDetalVCbottomViewHeight) style:UITableViewStylePlain];
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
        };
    }
    return _headerView;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-MEJDCoupleMailDetalVCbottomViewHeight, SCREEN_WIDTH, MEJDCoupleMailDetalVCbottomViewHeight)];
        _bottomView.backgroundColor =[UIColor colorWithHexString:@"F70054"];
        [_bottomView addSubview:self.btnShare];
        [_bottomView addSubview:self.btnBuy];
    }
    return _bottomView;
}

- (UIButton *)btnBuy{
    if(!_btnBuy){
        _btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBuy.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, MEJDCoupleMailDetalVCbottomViewHeight);
        [_btnBuy addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnBuy.backgroundColor =[UIColor colorWithHexString:@"F70054"];
        [_btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_btnBuy setTitle:@"立即购买" forState:UIControlStateNormal];
        if (self.isDynamic) {
            NSString *str = [NSString stringWithFormat:@"立即购买最低%.2f佣金",_detailModel.min_ratio];
            [_btnBuy setTitle:str forState:UIControlStateNormal];
        }else {
            CouponContentInfo *couponInfoModel = [CouponContentInfo new];
            if(kMeUnArr(_detailModel.couponInfo.couponList).count>0){
                couponInfoModel = _detailModel.couponInfo.couponList[0];
            }
            ////卷后价
            CGFloat oPrice = [kMeUnNilStr(_detailModel.priceInfo.price) floatValue];
            CGFloat dPrice = [kMeUnNilStr(couponInfoModel.discount) floatValue];
            CGFloat price =  oPrice- dPrice;
            if(price<0){
                price = 0;
            }
            NSString *str = [NSString stringWithFormat:@"立即购买最低%.2f佣金",price*_detailModel.commissionInfo.commissionShare/100* _detailModel.percent];
            [_btnBuy setTitle:str forState:UIControlStateNormal];
        }
        _btnBuy.titleLabel.font = kMeFont(15);
    }
    return _btnBuy;
}

- (UIButton *)btnShare{
    if(!_btnShare){
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, MEJDCoupleMailDetalVCbottomViewHeight);
        [_btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnShare.backgroundColor = [UIColor colorWithHexString:@"FC8F0C"];
        [_btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.isDynamic) {
            NSString *str = [NSString stringWithFormat:@"分享购买最低%.2f佣金",_detailModel.min_ratio];
            [_btnShare setTitle:str forState:UIControlStateNormal];
        }else {
            CouponContentInfo *couponInfoModel = [CouponContentInfo new];
            if(kMeUnArr(_detailModel.couponInfo.couponList).count>0){
                couponInfoModel = _detailModel.couponInfo.couponList[0];
            }
            ////卷后价
            CGFloat oPrice = [kMeUnNilStr(_detailModel.priceInfo.price) floatValue];
            CGFloat dPrice = [kMeUnNilStr(couponInfoModel.discount) floatValue];
            CGFloat price =  oPrice- dPrice;
            if(price<0){
                price = 0;
            }
            NSString *str = [NSString stringWithFormat:@"分享购买最低%.2f佣金",price*_detailModel.commissionInfo.commissionShare/100* _detailModel.percent];
            [_btnShare setTitle:str forState:UIControlStateNormal];
        }
        _btnShare.titleLabel.font = kMeFont(15);
        _btnShare.hidden = ![WXApi isWXAppInstalled];
    }
    return _btnShare;
}


@end
