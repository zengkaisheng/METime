//
//  MEFiveHomeHeaderView.m
//  志愿星
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveHomeHeaderView.h"
#import "METhridHomeModel.h"
#import "MEFiveHomeVC.h"
#import "METhridProductDetailsVC.h"
#import "MEServiceDetailsVC.h"
#import "MENewCoupleHomeVC.h"
#import "MECoupleMailVC.h"
#import "ZLWebViewVC.h"
#import "MEFourCoupleVC.h"
#import "MEPrizeListVC.h"
#import "MESpecialSaleVC.h"
#import "MEBargainListVC.h"
#import "MEGroupListVC.h"
#import "MECommonQuestionVC.h"
#import "MELianTongListVC.h"

#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"
#import "MEHomeOptionsModel.h"
#import "MEPersonalCourseVC.h"

#import "MENewSginUpVC.h"
#import "MERegisteVolunteerVC.h"
#import "MEPublicServiceCourseVC.h"
#import "MEActivityRecruitVC.h"
#import "MENewAvtivityVC.h"
#import "MEPublicShowHomeVC.h"
#import "MECommunityServiceHomeVC.h"
#import "MEPublicServiceEyesightVC.h"

@interface MEFiveHomeHeaderView ()<SDCycleScrollViewDelegate,JXCategoryViewDelegate>
{
    METhridHomeModel *_model;
    NSArray *_optionsArray;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSdHeight;
@property (weak, nonatomic) IBOutlet UIView *optionsView;

@end

@implementation MEFiveHomeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _sdView.delegate = self;
    _consSdHeight.constant = kFiveSdHeight*kMeFrameScaleX();
    self.userInteractionEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor =  [UIColor whiteColor];
    lineView.indicatorLineViewHeight = 1;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = @[@""];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleColor =  [UIColor whiteColor];
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)setUIWithModel:(METhridHomeModel *)model materArray:(NSArray *)materArray optionsArray:(NSArray *)options{
    if (materArray.count <= 0) {
        _categoryViewConsHeight.constant = 0.0;
        _categoryView.hidden = YES;
    }else {
        _categoryView.hidden = NO;
        _categoryViewConsHeight.constant = 39.0;
        
        NSMutableArray *titleArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < materArray.count; i++) {
            NSDictionary *dic = materArray[i];
            NSString *title = dic[@"title"];
            [titleArray addObject:title];
        }
        self.categoryView.titles = [titleArray copy];
    }
    
    _model = model;
    _optionsArray = options;
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [kMeUnArr(model.top_banner) enumerateObjectsUsingBlock:^(METhridHomeAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.imageURLStringsGroup = arrImage;
    _sdView.autoScrollTimeInterval = 4;
    _sdView.backgroundColor = [UIColor clearColor];
    
    for (UIView *view in self.optionsView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat itemW = 0.0;
    NSInteger lineCount = 0;
    NSInteger count = options.count;
    NSInteger line = 0;
    if (options.count <= 5) {
        lineCount = options.count;
        line = 1;
    }else {
        lineCount = ceil(options.count/2.0);
        line = 2;
    }
    itemW = SCREEN_WIDTH/lineCount;
    CGFloat itemH = 92;
    
    for (int i = 0; i < count; i++) {
        MEHomeOptionsModel *model = _optionsArray[i];
        UIButton *btn = [self createBtnWithModel:model frame:CGRectMake(itemW*(i%lineCount), (itemH-5)*(i/lineCount), itemW, itemH)];
        [self.optionsView addSubview:btn];
    }
}

#pragma mark -- JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectIndexBlock,index);
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    kMeCallBlock(_selectIndexBlock,index);
}

#pragma mark -- SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    kMeCallBlock(_scrollToIndexBlock,index);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    METhridHomeAdModel *model = kMeUnArr(_model.top_banner)[index];
    MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
    
    if (model.is_need_login == 1) {
        if(![MEUserInfoModel isLogin]){
            kMeWEAKSELF
            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                kMeSTRONGSELF
                if (strongSelf.reloadBlock) {
                    strongSelf.reloadBlock();
                }
            } failHandler:nil];
            return;
        }
    }
    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
        case 1:
        {
            if(homeVC){
                METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [homeVC.navigationController pushViewController:dvc animated:YES];
            }
        }
            break;
        case 2:
        {
            if(homeVC){
                MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
                [homeVC.navigationController pushViewController:dvc animated:YES];
            }
        }
            break;
        case 3:
        {
            if(homeVC){
                ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
                webVC.showProgress = YES;
                webVC.title = kMeUnNilStr(model.ad_name);
                [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
                [homeVC.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 4:
        {
            NSURL *URL = [NSURL URLWithString:kMeUnNilStr(model.ad_url)];
            [[UIApplication sharedApplication] openURL:URL];
        }
            break;
        case 5:
        {
            if(homeVC){
                MEBaseVC *vc = [[MEBaseVC alloc] init];
                vc.title = @"详情";
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
                CGFloat width = [UIScreen mainScreen].bounds.size.width-15;
                NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
                [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(model.content)] baseURL:nil];
                [vc.view addSubview:webView];
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 8:
        {
            [self toTaoBaoActivityWithUrl:kMeUnNilStr(model.ad_url)];
        }
            break;
        case 12://秒杀商品
        {
            if (homeVC) {
                METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [homeVC.navigationController pushViewController:dvc animated:YES];
            }
        }
            break;
        case 13:
        {//跳拼多多推荐商品列表
            if (homeVC) {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:model.ad_id];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 14:
        {//跳砍价活动详情
            if([MEUserInfoModel isLogin]){
                MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                [homeVC.navigationController pushViewController:bargainVC animated:YES];
            }else {
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                    [homeVC.navigationController pushViewController:bargainVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 15:
        {//跳拼团活动详情
            if([MEUserInfoModel isLogin]){
                MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                [homeVC.navigationController pushViewController:groupVC animated:YES];
            }else {
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    [homeVC.navigationController pushViewController:groupVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 16:
        {//跳签到活动详情
            if([MEUserInfoModel isLogin]){
                MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
                [homeVC.navigationController pushViewController:prizeVC animated:YES];
            }else {
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
                    [homeVC.navigationController pushViewController:prizeVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 17:
        {//跳常见问题
            if (homeVC) {
                MECommonQuestionVC *questionVC = [[MECommonQuestionVC alloc] init];
                [homeVC.navigationController pushViewController:questionVC animated:YES];
            }
        }
            break;
        case 20:
        {//联通兑换专区
            if (homeVC) {
                MELianTongListVC *liantongVC = [[MELianTongListVC alloc] init];
                [homeVC.navigationController pushViewController:liantongVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
//618活动
- (void)toTaoBaoActivityWithUrl:(NSString *)url{
    kMeWEAKSELF
    if([MEUserInfoModel isLogin]){
        [weakSelf checkRelationIdWithUrl:url];
    }else {
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toTaoBaoActivityWithUrl:url];
        } failHandler:nil];
    }
}
//获取淘宝授权
- (void)obtainTaoBaoAuthorizeWithUrl:(NSString *)url {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
    webVC.showProgress = YES;
    webVC.title = @"获取淘宝授权";
    [webVC loadURL:[NSURL URLWithString:str]];
    kMeWEAKSELF
    webVC.authorizeBlock = ^{
        [weakSelf checkRelationIdWithUrl:url];
    };
    MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
    if (homeVC) {
        [homeVC.navigationController pushViewController:webVC animated:YES];
    }
}
//验证RelationId
- (void)checkRelationIdWithUrl:(NSString *)url {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
        [self obtainTaoBaoAuthorizeWithUrl:url];
    }else{
        if (url.length > 0) {
            MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            NSString *str = [url stringByAppendingString:rid];
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = @"活动主会场";
            [webVC loadURL:[NSURL URLWithString:str]];
            [homeVC.navigationController pushViewController:webVC animated:YES];
        }
    }
}
#pragma mark -- Helper
- (UIButton *)createBtnWithModel:(MEHomeOptionsModel *)model frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:kMeUnNilStr(model.title) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitleColor:kME333333 forState:UIControlStateNormal];
    btn.frame = frame;
    btn.tag = model.type;
    btn.titleEdgeInsets = UIEdgeInsetsMake(30, 0, -30, 0);
    [btn addTarget:self action:@selector(optionsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake((frame.size.width-42)/2, 21, 42, 42);
    kSDLoadImg(imageV, kMeUnNilStr(model.logo));
    [btn addSubview:imageV];
    [btn sendSubviewToBack:imageV];
    
    return btn;
}

- (void)saveClickRecordsWithType:(NSString *)type params:(NSDictionary *)params {
    NSDate *date = [[NSDate alloc] init];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [tempDic setObject:[date getNowDateFormatterString] forKey:@"created_at"];
    NSString *paramsStr = [NSString convertToJsonData:tempDic];
    
    NSMutableArray *records = [[NSMutableArray alloc] init];
    if ([kMeUserDefaults objectForKey:kMEGetClickRecord]) {
        [records addObjectsFromArray:(NSArray *)[kMeUserDefaults objectForKey:kMEGetClickRecord]];
    }
    
    [records addObject:@{@"type":type,@"parameter":paramsStr}];
    [kMeUserDefaults setObject:records forKey:kMEGetClickRecord];
    [kMeUserDefaults synchronize];
}
#pragma mark --- Action
- (void)optionsBtnAction:(UIButton *)sender {
    //    NSLog(@"tag:%ld",sender.tag);
    NSString *name = @"";
    switch (sender.tag) {
        case 5:
            name = @"chaozhitehui";
            break;
        case 1:
            name = @"taobao";
            break;
        case 2:
            name = @"pingduoduo";
            break;
        case 3:
            name = @"jingdong";
            break;
        case 4:
            name = @"pingpai";
            break;
        case 6:
            name = @"ju";
            break;
        case 7:
            name = @"largecoupon";
            break;
        case 8:
            name = @"singnin";
            break;
        case 9:
            name = @"bargain";
            break;
        case 10:
            name = @"group";
            break;
        default:
            break;
    }
    NSDictionary *params = @{@"name":name};
    [self saveClickRecordsWithType:@"2" params:params];
    
    MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
    if(homeVC){
        switch (sender.tag) {
            case 5:
            {//超值特惠
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTeHuiType];
                vc.titleStr = @"超值特惠专场";
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {//淘宝
                MENewCoupleHomeVC *vc= [[MENewCoupleHomeVC alloc]initWithIsTbK:YES];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {//拼多多
                MEFourCoupleVC *vc = [[MEFourCoupleVC alloc] initWithIsJD:NO];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {//京东
                MEFourCoupleVC *vc = [[MEFourCoupleVC alloc] initWithIsJD:YES];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {//品牌特卖
                MESpecialSaleVC *vc = [[MESpecialSaleVC alloc] init];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:
            {//聚划算
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchJuHSType];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 7:
            {//大额优惠券
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchBigJuanType];
                vc.recordType = 1;
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 8:
            {//每日签到
                if([MEUserInfoModel isLogin]){
                    MEPrizeListVC *prizeVC = [[MEPrizeListVC alloc] init];
                    [homeVC.navigationController pushViewController:prizeVC animated:YES];
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEPrizeListVC *prizeVC = [[MEPrizeListVC alloc] init];
                        [homeVC.navigationController pushViewController:prizeVC animated:YES];
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 9:
            {//砍价
                if([MEUserInfoModel isLogin]){
                    MEBargainListVC *bargainVC = [[MEBargainListVC alloc] init];
                    [homeVC.navigationController pushViewController:bargainVC animated:YES];
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEBargainListVC *bargainVC = [[MEBargainListVC alloc] init];
                        [homeVC.navigationController pushViewController:bargainVC animated:YES];
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 10:
            {//拼团
                if([MEUserInfoModel isLogin]){
                    MEGroupListVC *groupVC = [[MEGroupListVC alloc] init];
                    [homeVC.navigationController pushViewController:groupVC animated:YES];
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEGroupListVC *groupVC = [[MEGroupListVC alloc] init];
                        [homeVC.navigationController pushViewController:groupVC animated:YES];
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 11:
            {//联通兑换
                MELianTongListVC *liantongVC = [[MELianTongListVC alloc] init];
                [homeVC.navigationController pushViewController:liantongVC animated:YES];
            }
                break;
            case 12:
            {//课程
                MEPersonalCourseVC *courseVC = [[MEPersonalCourseVC alloc] init];
                courseVC.isHideTabBar = YES;
                [homeVC.navigationController pushViewController:courseVC animated:YES];
            }
                break;
            case 13:
            {//商品详情  model.product_id
                __block NSInteger productId = 0;
                [_optionsArray enumerateObjectsUsingBlock:^(MEHomeOptionsModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (model.type == sender.tag) {
                        productId = model.ids;
                        *stop = YES;
                    }
                }];
                if (productId != 0) {
                    METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:productId];
                    [homeVC.navigationController pushViewController:dvc animated:YES];
                }
            }
                break;
            case 14:
            {//志愿签到
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        MENewSginUpVC *svc = [[MENewSginUpVC alloc] init];
                        [homeVC.navigationController pushViewController:svc animated:YES];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else{
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            MENewSginUpVC *svc = [[MENewSginUpVC alloc] init];
                            [homeVC.navigationController pushViewController:svc animated:YES];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:nil];
                }
            }
                break;
            case 15:
            {//公益课堂
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        MEPublicServiceCourseVC *vc = [[MEPublicServiceCourseVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            MEPublicServiceCourseVC *vc = [[MEPublicServiceCourseVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 16:
            {//志愿者注册
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        [MECommonTool showMessage:@"您已经是志愿者" view:kMeCurrentWindow];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            [MECommonTool showMessage:@"您已经是志愿者" view:kMeCurrentWindow];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 17:
            {//活动招募
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        MEActivityRecruitVC *vc = [[MEActivityRecruitVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            MEActivityRecruitVC *vc = [[MEActivityRecruitVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 18:
            {//精选好物
                MENewAvtivityVC *vc = [[MENewAvtivityVC alloc] initWithType:@"goods"];
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 19:
            {//公益秀
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        MEPublicShowHomeVC *vc = [[MEPublicShowHomeVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            MEPublicShowHomeVC *vc = [[MEPublicShowHomeVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 20:
            {//社区服务
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        MECommunityServiceHomeVC *vc = [[MECommunityServiceHomeVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            MECommunityServiceHomeVC *vc = [[MECommunityServiceHomeVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 21:
            {//福利领取
                MELianTongListVC *liantongVC = [[MELianTongListVC alloc] init];
                [homeVC.navigationController pushViewController:liantongVC animated:YES];
            }
                break;
            case 22:
            {//福利活动
                MENewAvtivityVC *vc = [[MENewAvtivityVC alloc] init];
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 23:
            {//视力预约
                if([MEUserInfoModel isLogin]){
                    if (kCurrentUser.is_volunteer == 1) {
                        MEPublicServiceEyesightVC *vc = [[MEPublicServiceEyesightVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }else {
                        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                        [homeVC.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        if (kCurrentUser.is_volunteer == 1) {
                            MEPublicServiceEyesightVC *vc = [[MEPublicServiceEyesightVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }else {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [homeVC.navigationController pushViewController:vc animated:YES];
                        }
                    } failHandler:^(id object) {
                        
                    }];
                }
            }
                break;
            case 24:
            {//爱心榜
                
            }
                break;
            case 25:
            {//志愿保障
                
            }
                break;
            default:
                break;
        }
    }
}

+ (CGFloat)getViewHeightWithOptionsArray:(NSArray *)options materArray:(NSArray *)materArray{
    CGFloat height = kMEFiveHomeHeaderViewHeight - kFiveSdHeight - 39.0;
    if (materArray.count > 0) {
        height += 39.0;
    }
    height += (kFiveSdHeight*kMeFrameScaleX());
    height -= 184;
    NSInteger line = 0;
    if (options.count <= 5) {
        line = 1;
    }else {
        line = 2;
    }
    height+=92*line;
    return height;
}

@end
