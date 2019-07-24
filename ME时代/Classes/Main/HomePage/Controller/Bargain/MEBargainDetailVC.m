//
//  MEBargainDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainDetailVC.h"
#import "MEBargainSuccessView.h"
#import "MEBargainDetailModel.h"
#import "MEBargainDetailTopCell.h"
#import "MEBargainUsresCell.h"

#import "METhridProductDetailsVC.h"
#import "MEBargainRuleView.h"

@interface MEBargainDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger bargainId;
@property (nonatomic, assign) BOOL isMyList;
@property (nonatomic, strong) MEBargainDetailModel *detailModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEBargainDetailVC

- (instancetype)initWithBargainId:(NSInteger)bargainId  myList:(BOOL)isMyList{
    if (self = [super init]) {
        _bargainId = bargainId;
        _isMyList = isMyList;
    }
    return self;
}

- (void)dealloc {
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"砍价";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E63831"];
    
    if (self.isMyList) {
        [self requestNetWorkWithbargainDetail];
    }else {
        [self requestNetWorkWithBargain];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:kBargainReloadOrder object:nil];
}

- (void)reload {
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    if (self.isMyList) {
        [self requestNetWorkWithbargainDetail];
    }else {
        [self requestNetWorkWithBargain];
    }
}

#pragma mark -- networking
- (void)requestNetWorkWithBargain{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.userInteractionEnabled = YES;
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postBargainWithBargainId:[NSString stringWithFormat:@"%ld",(long)self.bargainId] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [hud hideAnimated:YES];
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject.data;
            if ([dict[@"type"] intValue] != 3) {
                [strongSelf showBargainSuccessViewWithMoney:kMeUnNilStr(dict[@"money"])];
            }
            [strongSelf requestNetWorkWithbargainDetail];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        [hud hideAnimated:YES];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)requestNetWorkWithbargainDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.userInteractionEnabled = YES;
    kMeWEAKSELF
    [MEPublicNetWorkTool postBargainDetailWithBargainId:[NSString stringWithFormat:@"%ld",(long)self.bargainId] successBlock:^(ZLRequestResponse *responseObject) {
        [hud hideAnimated:YES];
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.detailModel = [MEBargainDetailModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.detailModel = nil;
        }
        [strongSelf.view addSubview:strongSelf.tableView];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [hud hideAnimated:YES];
        strongSelf.detailModel = nil;
    }];
}

- (void)requestNetWorkWithAllBarginLog{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetAllBarginLogWithBargainId:[NSString stringWithFormat:@"%ld",(long)self.bargainId] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            NSArray *data = [MEBargainUserModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            strongSelf.detailModel.bargin_user = data;
        }
        
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

- (void)shareAction {
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    
    //https://test.meshidai.com/dist/newAuth.html?id=7&uid=xxx
    shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@bargaindist/newAuth.html?id=%ld&uid=%@",baseUrl,(long)_detailModel.bargin_id,kMeUnNilStr(kCurrentUser.uid)];
    NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
    
    shareTool.shareTitle = self.detailModel.title;
    shareTool.shareDescriptionBody = @"好友邀请您免费拿！";
    shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailModel.images]]];

    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession success:^(id data) {
        NSLog(@"分享成功%@",data);
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        NSLog(@"分享失败%@",error);
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        MEBargainUsresCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBargainUsresCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.detailModel];
        kMeWEAKSELF
        cell.moreBlock = ^(BOOL isShow) {
            kMeSTRONGSELF
            strongSelf.detailModel.isShowMore = isShow;
            [strongSelf requestNetWorkWithAllBarginLog];
        };
        return cell;
    }
    MEBargainDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBargainDetailTopCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.detailModel];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        switch (index) {
            case 0://规则
            {
                [strongSelf showBargainRuleViewWithTitle:kMeUnNilStr(self.detailModel.rule)];
            }
                break;
            case 1://商品详情
            {
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:self.detailModel.product_id];
                [self.navigationController pushViewController:details animated:YES];
            }
                break;
            case 2://分享
            {
                [strongSelf shareAction];
            }
                break;
            case 3://砍价成功 立即领取
            {
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc] initWithId:strongSelf.detailModel.product_id bargainId:strongSelf.detailModel.bargin_id];
                details.reducePrice = kMeUnNilStr(strongSelf.detailModel.amount_money);
                [self.navigationController pushViewController:details animated:YES];
            }
                break;
            case 4://砍价失败
            {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return [MEBargainUsresCell getCellHeightWithArray:self.detailModel.bargin_user showMore:self.detailModel.isShowMore];
    }
    return 388;
}

- (void)showBargainSuccessViewWithMoney:(NSString *)money {
    kMeWEAKSELF
    [MEBargainSuccessView showBargainSuccessWithTitle:[NSString stringWithFormat:@"您已砍%@元，人多力量大，快喊小伙伴来帮忙~",money] shareBlock:^{
        kMeSTRONGSELF
        [strongSelf shareAction];
    } cancelBlock:^{
    } superView:kMeCurrentWindow];
}

- (void)showBargainRuleViewWithTitle:(NSString *)title {
    [MEBargainRuleView showBargainRuleViewWithTitle:title cancelBlock:^{
    } superView:kMeCurrentWindow];
}

#pragma setter&&getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBargainDetailTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBargainDetailTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBargainUsresCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBargainUsresCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#E63831"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}


@end
