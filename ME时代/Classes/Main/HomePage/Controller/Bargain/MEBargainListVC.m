//
//  MEBargainListVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainListVC.h"
#import "MEBargainHeaderView.h"
#import "MEBargainLisCell.h"
#import "MEBargainListModel.h"
#import "MEMyBargainListModel.h"
#import "MEAdModel.h"

#import "METhridProductDetailsVC.h"
#import "MEServiceDetailsVC.h"
#import "ZLWebViewVC.h"
#import "MECoupleMailVC.h"
#import "MEBargainDetailVC.h"
#import "MEBargainRuleView.h"

#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"

@interface MEBargainListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) MEBargainHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, strong) NSDictionary *bannerInfo;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, copy) NSString *bargin_rule;

@end

@implementation MEBargainListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.title = @"砍价";
    self.bargin_rule = @"";
    self.isToday = YES;
    self.bannerInfo = [NSDictionary dictionary];
    self.banners = [NSArray array];
    
    [self.view addSubview:self.bottomView];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithDictionary:self.bannerInfo];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self showHud];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:kBargainReloadOrder object:nil];
}

- (void)dealloc {
    kNSNotificationCenterDealloc
}

- (void)reload {
    [self showHud];
    [self.refresh reload];
}

- (void)showHud {
    self.hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    self.hud.userInteractionEnabled = YES;
    [self.hud hideAnimated:YES afterDelay:2.0];
}

- (void)hideHUD {
    [self.hud hideAnimated:YES];
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if (self.isToday) {
        return @{@"token":kMeUnNilStr(kCurrentUser.token),@"tool":@"1"};
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSDictionary *info = (NSDictionary *)data;
    MENetListModel *nlModel = [MENetListModel mj_objectWithKeyValues:info];
    if (self.isToday) {
        self.banners = [MEAdModel mj_objectArrayWithKeyValuesArray:info[@"top_banner"]];
        self.bannerInfo = @{@"today_finish_bargin_total":[NSString stringWithFormat:@"%ld",(long)[info[@"today_finish_bargin_total"] integerValue]],@"top_banner":self.banners,@"type":@"1"};
        if (self.banners.count > 0) {
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView setUIWithDictionary:self.bannerInfo];
        }else {
            self.headerView = nil;
            self.tableView.tableHeaderView = [UIView new];
        }
        [self.refresh.arrData addObjectsFromArray:[MEBargainListModel mj_objectArrayWithKeyValuesArray:nlModel.data]];
    }else {
        self.bargin_rule = kMeUnNilStr(info[@"bargin_rule"]);
        [self.refresh.arrData addObjectsFromArray:[MEMyBargainListModel mj_objectArrayWithKeyValuesArray:nlModel.data]];
    }
    [self hideHUD];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBargainLisCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBargainLisCell class]) forIndexPath:indexPath];
    if (self.isToday) {
        MEBargainListModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithModel:model];
        kMeWEAKSELF
        cell.tapBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf postBargainWithBargainId:model.idField  myList:NO];
        };
    }else {
        MEMyBargainListModel *model = self.refresh.arrData[indexPath.row];
        [cell setMyBargainUIWithModel:model];
        kMeWEAKSELF
        cell.tapBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (index == 1) {
                UIButton *btn = [[UIButton alloc] init];
                btn.tag = 100;
                [strongSelf bottomBtnAction:btn];
            }else {
                [strongSelf postBargainWithBargainId:model.bargin_id  myList:YES];
            }
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEBargainLisCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isToday) {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isToday) {
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *fstr = [NSString stringWithFormat:@"我的砍价(%ld个)",(long)self.refresh.arrData.count];
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    NSUInteger secondLoc = [[faString string] rangeOfString:@"("].location;
    
    NSRange range = NSMakeRange(secondLoc, fstr.length - secondLoc);
    [faString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:range];
    [faString addAttribute:NSForegroundColorAttributeName value:kME666666 range:range];
    CGFloat width = [fstr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 100, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, width, 44)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textColor = kME333333;
    titleLbl.attributedText = faString;
    [headerView addSubview:titleLbl];
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake(SCREEN_WIDTH - 90, 0, 90, 44);
    [ruleBtn setTitle:@"使用规则" forState:UIControlStateNormal];
    [ruleBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    [ruleBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [ruleBtn setImage:[UIImage imageNamed:@"icon_rule"] forState:UIControlStateNormal];
    [ruleBtn setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:3];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:ruleBtn];
    
    UIView *line = [self createLineView];
    line.frame = CGRectMake(0, 43, SCREEN_WIDTH, 1);
    [headerView addSubview:line];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isToday) {
        MEBargainListModel *model = self.refresh.arrData[indexPath.row];
        [self postBargainWithBargainId:model.idField  myList:NO];
    }else {
        MEMyBargainListModel *model = self.refresh.arrData[indexPath.row];
        [self postBargainWithBargainId:model.bargin_id  myList:YES];
    }
}

#pragma Action
- (void)postBargainWithBargainId:(NSInteger)bargainId  myList:(BOOL)isMyList{
    MEBargainDetailVC *vc = [[MEBargainDetailVC alloc] initWithBargainId:bargainId  myList:isMyList];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ruleBtnAction {
    [MEBargainRuleView showBargainRuleViewWithTitle:self.bargin_rule cancelBlock:^{
    } superView:kMeCurrentWindow];
}

- (void)bottomBtnAction:(UIButton *)sender {
    UIButton *bargainBtn = (UIButton *)sender;
    
    for (id obj in self.bottomView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == bargainBtn.tag) {
                if (btn.selected == YES) {
                    return;
                }else {
                    btn.selected = YES;
                }
            }else {
                btn.selected = NO;
            }
        }
    }
    if (bargainBtn.tag == 100) {
        self.isToday = YES;
        self.tableView.tableHeaderView = self.headerView;
        self.refresh.url = kGetApiWithUrl(MEIPcommonGetBarginGoodsList);
    }else {
        self.isToday = NO;
        self.refresh.url = kGetApiWithUrl(MEIPcommonGetMyBarginList);
        self.tableView.tableHeaderView = [UIView new];
    }
    [self.refresh.arrData removeAllObjects];
    [self.tableView reloadData];
    [self showHud];
    [self.refresh reload];
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
            [webView loadHTMLString:model.content baseURL:nil];
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
        case 13:
        {//跳拼多多推荐商品列表
            MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:model.ad_id];
            vc.recordType = self.recordType;
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

- (UIButton *)createButtonWithDictionary:(NSDictionary *)dic tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
    [btn setTitleColor:kME666666 forState:UIControlStateNormal];
    [btn setTitleColor:kME333333 forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setImage:[UIImage imageNamed:dic[@"image_normal"]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:dic[@"image_selected"]] forState:UIControlStateSelected];
    [btn setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:6];
    btn.tag = tag;
    [btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)createLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    return line;
}

#pragma setter&&getter
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIView *topLine = [self createLineView];
        topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        [_bottomView addSubview:topLine];
        
        NSArray *btns = @[@{@"title":@"今日砍价推荐",@"image_normal":@"icon_bargain_normal",@"image_selected":@"icon_bargain_selected"},
                          @{@"title":@"我的砍价",@"image_normal":@"icon_myBargain_normal",@"image_selected":@"icon_myBargain_selected"}];
        CGFloat itemW = SCREEN_WIDTH / btns.count;
        for (int i = 0; i < btns.count; i++) {
            NSDictionary *btnInfo = btns[i];
            UIButton *btn = [self createButtonWithDictionary:btnInfo tag:100+i];
            btn.frame = CGRectMake(i *itemW, 0, itemW, 48);
            [_bottomView addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
            }
            if (i != btns.count - 1) {
                UIView *line = [self createLineView];
                line.frame = CGRectMake(CGRectGetMaxX(btn.frame)-1, 15, 1, 18);
                [_bottomView addSubview:line];
            }
        }
    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight - 49) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBargainLisCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBargainLisCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetBarginGoodsList)];
        _refresh.delegate = self;
        _refresh.isBargain = YES;
//        _refresh.showFailView = NO;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lookForward"]];
            imgView.frame = CGRectMake(0, 0, failView.frame.size.width, failView.frame.size.height);
            [failView addSubview:imgView];
//            failView.backgroundColor = [UIColor whiteColor];
//            failView.lblOfNodata.text = @"没有砍价商品";
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
