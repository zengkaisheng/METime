//
//  MEGroupListVC.m
//  志愿星
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupListVC.h"
#import "MEBargainHeaderView.h"
#import "MEGroupListCell.h"
#import "MEGroupListModel.h"
#import "MEAdModel.h"
#import "MEGroupProductDetailVC.h"

#import "METhridProductDetailsVC.h"
#import "MEServiceDetailsVC.h"
#import "ZLWebViewVC.h"
#import "MECoupleMailVC.h"

#import "MEBargainDetailVC.h"
#import "MEJoinPrizeVC.h"
#import "MECommonQuestionVC.h"
#import "MELianTongListVC.h"

@interface MEGroupListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) MEBargainHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, strong) NSDictionary *bannerInfo;
@property (nonatomic, strong) NSArray *banners;

@end

@implementation MEGroupListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.title = @"拼团";
    self.bannerInfo = [NSDictionary dictionary];
    self.banners = [NSArray array];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithDictionary:self.bannerInfo];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSDictionary *info = (NSDictionary *)data;
    MENetListModel *nlModel = [MENetListModel mj_objectWithKeyValues:info];
    self.banners = [MEAdModel mj_objectArrayWithKeyValuesArray:kMeUnArr(info[@"top_banner"])];
    self.bannerInfo = @{@"today_group_total":[NSString stringWithFormat:@"%ld",[info[@"today_group_total"] integerValue]],@"top_banner":self.banners,@"type":@"2"};
    [self.headerView setUIWithDictionary:self.bannerInfo];
    [self.refresh.arrData addObjectsFromArray:[MEGroupListModel mj_objectArrayWithKeyValuesArray:nlModel.data]];
}
#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGroupListCell class]) forIndexPath:indexPath];
    MEGroupListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.groupBlock = ^{
        kMeSTRONGSELF
        MEGroupProductDetailVC *vc = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEGroupListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGroupListModel *model = self.refresh.arrData[indexPath.row];
    MEGroupProductDetailVC *vc = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
        case 1:
        {
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc] initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 2:
        {
            MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc] initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 3:
        {
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
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
            [self toTaoBaoActivityWithUrl:kMeUnNilStr(model.ad_url)];
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
            MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:model.ad_id];
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
        case 20:
        {//联通兑换专区
            MELianTongListVC *liantongVC = [[MELianTongListVC alloc] init];
            [self.navigationController pushViewController:liantongVC animated:YES];
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
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)checkRelationIdWithUrl:(NSString *)url {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
        //        [self openAddTbView];
        [self obtainTaoBaoAuthorizeWithUrl:url];
    }else{
        if (url.length > 0) {
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            NSString *str = [url stringByAppendingString:rid];
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = @"活动主会场";
            [webVC loadURL:[NSURL URLWithString:str]];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}
#pragma setter&&getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGroupListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGroupListCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEf5f4f4;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetGroupList)];
        _refresh.delegate = self;
        _refresh.isBargain = YES;
        //        _refresh.showFailView = NO;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
//            failView.backgroundColor = [UIColor whiteColor];
//            failView.lblOfNodata.text = @"没有拼团商品";
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lookForward"]];
            imgView.frame = CGRectMake(0, 0, failView.frame.size.width, failView.frame.size.height);
            [failView addSubview:imgView];
        }];
    }
    return _refresh;
}
- (MEBargainHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEBargainHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MEBargainHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            MEAdModel *model = strongSelf.banners[index];
            [strongSelf cycleScrollViewDidSelectItemWithModel:model];
        };
    }
    return _headerView;
}

@end
