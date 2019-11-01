//
//  MENewAvtivityVC.m
//  志愿星
//
//  Created by gao lei on 2019/11/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewAvtivityVC.h"
#import "METhridHomeGoodGoodMainCell.h"
#import "MEFourHomeActivityCell.h"
#import "MEHomeRecommendModel.h"
#import "MEAdModel.h"
#import "MEGoodModel.h"
#import "METhridProductDetailsVC.h"

#import "MEBargainListModel.h"
#import "MEBargainDetailVC.h"

#import "MEGroupListModel.h"
#import "MEGroupProductDetailVC.h"

#import "MEJoinPrizeVC.h"
#import "MENewOnlineCourseHeaderView.h"

#import "MEHomeAddRedeemcodeVC.h"
#import "MECoupleMailDetalVC.h"
#import "ZLWebViewVC.h"
#import "MEServiceDetailsVC.h"
#import "MECoupleMailVC.h"

#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"
#import "MEHomeOptionsModel.h"
#import "MEHomeRecommendModel.h"
#import "MECommonQuestionVC.h"
#import "MELianTongListVC.h"
#import "MEPersionalCourseDetailVC.h"

#import "MEFiveHomeNavView.h"
#import "MEFiveHomeHeaderView.h"
#import "MEFiveHomeVolunteerHeaderView.h"
#import "MEFiveHomeEntranceCell.h"
#import "MEFiveHomeCouponView.h"
#import "MEFiveCategoryView.h"
#import "MECourseDetailVC.h"

#import "MERegisteVolunteerVC.h"
#import "MECommunityServiceHomeVC.h"
#import "MEPublicShowHomeVC.h"
#import "MEActivityRecruitVC.h"

@interface MENewAvtivityVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) MEAdModel *bannerModel;
@property (nonatomic, strong) MENewOnlineCourseHeaderView *headerNewView;

@end

@implementation MENewAvtivityVC

- (instancetype)initWithType:(NSString *)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.type isEqualToString:@"goods"]) {
        self.title = @"精选好物";
    }else {
        self.title = @"福利活动";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerNewView;
    [self.headerNewView setUIWithArray:@[]];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"type":kMeUnNilStr(self.type)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSDictionary *dict = (NSDictionary *)data;
    NSArray *list = dict[@"data_list"][@"data"];
    
    self.bannerModel = [MEAdModel mj_objectWithKeyValues:dict[@"top_banner"]];
    self.tableView.tableHeaderView = self.headerNewView;
    [self.headerNewView setActivityUIWithModel:self.bannerModel];
    if (kMeUnNilStr(self.bannerModel.color_start).length > 0) {
        self.tableView.backgroundColor = [UIColor colorWithHexString:kMeUnNilStr(self.bannerModel.color_start)];
    }
    [self.refresh.arrData addObjectsFromArray:[MEHomeRecommendModel mj_objectArrayWithKeyValuesArray:kMeUnArr(list)]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeRecommendModel *model = self.refresh.arrData[indexPath.row];
    switch (model.type) {
        case 1:
        {//商品
            METhridHomeGoodGoodMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class]) forIndexPath:indexPath];
            MEGoodModel *goodModel = [MEGoodModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setUIWithModel:goodModel];
            kMeWEAKSELF
            cell.buyBlock = ^{
                kMeSTRONGSELF
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [strongSelf.navigationController pushViewController:details animated:YES];
            };
            return cell;
        }
            break;
        case 2:
        {//砍价
            MEFourHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFourHomeActivityCell class]) forIndexPath:indexPath];
            MEBargainListModel *bargainModel = [MEBargainListModel mj_objectWithKeyValues:model.mj_keyValues];
            bargainModel.product_price = model.money;
            [cell setUIWithBargainModel:bargainModel];
            kMeWEAKSELF
            cell.tapBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                if([MEUserInfoModel isLogin]){
                    MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                   [strongSelf.navigationController pushViewController:details animated:YES];
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                        [strongSelf.navigationController pushViewController:details animated:YES];
                    } failHandler:^(id object) {
                    }];
                }
            };
            return cell;
        }
            break;
        case 3:
        {//拼团
            MEFourHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFourHomeActivityCell class]) forIndexPath:indexPath];
            MEGroupListModel *groupModel = [MEGroupListModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setUIWithGroupModel:groupModel];
            kMeWEAKSELF
            cell.tapBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                if([MEUserInfoModel isLogin]){
                    MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    [strongSelf.navigationController pushViewController:details animated:YES];
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                        [strongSelf.navigationController pushViewController:details animated:YES];
                    } failHandler:^(id object) {
                    }];
                }
            };
            return cell;
        }
            break;
        case 4:
        {//秒杀
            MEFourHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFourHomeActivityCell class]) forIndexPath:indexPath];
            MEGoodModel *goodModel = [MEGoodModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setUIWithGoodModel:goodModel];
            kMeWEAKSELF
            cell.tapBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [strongSelf.navigationController pushViewController:details animated:YES];
            };
            return cell;
        }
            break;
        case 5:
        {//签到
            MEFourHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFourHomeActivityCell class]) forIndexPath:indexPath];
            MEGoodModel *goodModel = [MEGoodModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setUIWithGoodModel:goodModel];
            kMeWEAKSELF
            cell.tapBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                if([MEUserInfoModel isLogin]){
                    MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                    [strongSelf.navigationController pushViewController:details animated:YES];
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                        [strongSelf.navigationController pushViewController:details animated:YES];
                    } failHandler:^(id object) {
                    }];
                }
            };
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"goods"]) {
        return kMEThridHomeGoodGoodMainCellHeight;
    }
    return kMEThridHomeGoodGoodMainCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeRecommendModel *model = self.refresh.arrData[indexPath.row];
    switch (model.type) {
        case 1:
        {//商品
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:details animated:YES];
        }
            break;
        case 2:
        {//砍价
            if([MEUserInfoModel isLogin]){
                MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                [self.navigationController pushViewController:details animated:YES];
            }else {
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                    [self.navigationController pushViewController:details animated:YES];
                } failHandler:^(id object) {
                }];
            }
        }
            break;
        case 3:
        {//拼团
            if([MEUserInfoModel isLogin]){
                MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                [self.navigationController pushViewController:details animated:YES];
            }else {
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    [self.navigationController pushViewController:details animated:YES];
                } failHandler:^(id object) {
                }];
            }
        }
            break;
        case 4:
        {//秒杀
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:details animated:YES];
        }
            break;
        case 5:
        {//签到
            if([MEUserInfoModel isLogin]){
                MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                [self.navigationController pushViewController:details animated:YES];
            }else {
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                    [self.navigationController pushViewController:details animated:YES];
                } failHandler:^(id object) {
                }];
            }
        }
        default:
            break;
    }
}

//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
    
    if (model.is_need_login == 1) {
        if(![MEUserInfoModel isLogin]){
            kMeWEAKSELF
            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                kMeSTRONGSELF
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            } failHandler:^(id object) {
                return;
            }];
            return;
        }
    }
    
//    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
//    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标(跳活动)10 跳拼多多 11 跳京东 12 跳秒杀商品 13 跳拼多多推荐商品列表 14 跳砍价活动 15 跳拼团活动 16 跳签到活动 17 跳常见问题 18 跳视频详情页面 19 跳音频详情页面 20 联通兑换商品列表 21 跳C端视频详情页面 22 跳C端音频详情页面 23 跳公益课程 24 跳志愿者注册 25 跳活动招募 26 跳精选好物 27 跳公益活动 28 跳社区服务 29 跳福利领取 30 跳福利活动 31 跳视力预约 32 跳爱心榜 33 跳志愿保障
        case 1:
        {
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 2:
        {
            MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 3:
        {
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = kMeUnNilStr(model.ad_name);
            [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
            [self.navigationController pushViewController:webVC animated:YES];
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
            MEBaseVC *vc = [[MEBaseVC alloc] init];
            vc.title = @"详情";
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            CGFloat width = [UIScreen mainScreen].bounds.size.width-15;
            NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
            [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(model.content)] baseURL:nil];
            [vc.view addSubview:webView];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 8:
        {
//            [self toTaoBaoActivityWithUrl:kMeUnNilStr(model.ad_url)];
        }
            break;
        case 12://秒杀商品
        {
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 13:
        {//跳拼多多推荐商品列表
            MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:@""];
            vc.recordType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {//跳砍价活动详情
            if([MEUserInfoModel isLogin]){
                MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                [self.navigationController pushViewController:bargainVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                    [strongSelf.navigationController pushViewController:bargainVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 15:
        {//跳拼团活动详情
            if([MEUserInfoModel isLogin]){
                MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                [self.navigationController pushViewController:groupVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    [strongSelf.navigationController pushViewController:groupVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 16:
        {//跳签到活动详情
            if([MEUserInfoModel isLogin]){
                MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
                [self.navigationController pushViewController:prizeVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
                    [strongSelf.navigationController pushViewController:prizeVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 17:
        {//跳常见问题
            MECommonQuestionVC *questionVC = [[MECommonQuestionVC alloc] init];
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        case 18:
        {
            MECourseDetailVC *dvc = [[MECourseDetailVC alloc] initWithId:model.video_id type:0];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 19:
        {
            MECourseDetailVC *dvc = [[MECourseDetailVC alloc] initWithId:model.audio_id type:1];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 20:
        {//联通兑换专区
            MELianTongListVC *liantongVC = [[MELianTongListVC alloc] init];
            [self.navigationController pushViewController:liantongVC animated:YES];
        }
            break;
        case 21:
        {//C端视频
            MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.video_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 22:
        {//C端音频
            MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.audio_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 23:
        {//跳公益课程
            NSLog(@"跳公益课程");
            //            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 24:
        {//跳志愿者注册
            if (kCurrentUser.is_volunteer == 1) {
                [MECommonTool showMessage:@"您已经是志愿者" view:kMeCurrentWindow];
            }else {
                MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 25:
        {//跳活动招募
            MEActivityRecruitVC *vc = [[MEActivityRecruitVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 26:
        {//跳精选好物
            MENewAvtivityVC *vc = [[MENewAvtivityVC alloc] initWithType:@"goods"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 27:
        {//跳公益秀
            MEPublicShowHomeVC *vc = [[MEPublicShowHomeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 28:
        {//跳社区服务
            MECommunityServiceHomeVC *vc = [[MECommunityServiceHomeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 29:
        {//跳福利领取
            MELianTongListVC *liantongVC = [[MELianTongListVC alloc] init];
            [self.navigationController pushViewController:liantongVC animated:YES];
        }
            break;
        case 30:
        {//跳福利活动
            MENewAvtivityVC *vc = [[MENewAvtivityVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 31:
        {//跳视力预约
            //            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 32:
        {//跳爱心榜
            //            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 33:
        {//跳志愿保障
            //            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeGoodGoodMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEFourHomeActivityCell class])];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([self.type isEqualToString:@"goods"]) {
            _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        }else {
            _tableView.backgroundColor = [UIColor whiteColor];
        }
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonHomeGetRecommendGoodsAndActivity)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        _refresh.isActivity = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无活动数据";
        }];
    }
    return _refresh;
}

- (MENewOnlineCourseHeaderView *)headerNewView {
    if(!_headerNewView){
        _headerNewView = [[[NSBundle mainBundle]loadNibNamed:@"MENewOnlineCourseHeaderView" owner:nil options:nil] lastObject];
        _headerNewView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 271);
        kMeWEAKSELF
        _headerNewView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (index < 100) {
                [strongSelf cycleScrollViewDidSelectItemWithModel:strongSelf.bannerModel];
            }
        };
    }
    return _headerNewView;
}

@end
