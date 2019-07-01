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
}

#pragma mark -- networking
- (void)requestNetWorkWithBargain{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.userInteractionEnabled = YES;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postBargainWithBargainId:[NSString stringWithFormat:@"%ld",(long)self.bargainId] successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)responseObject.data;
                [strongSelf showBargainSuccessViewWithMoney:kMeUnNilStr(dict[@"money"])];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postBargainDetailWithBargainId:[NSString stringWithFormat:@"%ld",(long)self.bargainId] successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                strongSelf.detailModel = [MEBargainDetailModel mj_objectWithKeyValues:responseObject.data];
            }else {
                strongSelf.detailModel = nil;
            }
             dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.detailModel = nil;
             dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [hud hideAnimated:YES];
            [strongSelf.view addSubview:strongSelf.tableView];
            [strongSelf.tableView reloadData];
        });
    });
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
                [strongSelf showBargainRuleViewWithTitle:@"1、注册、分享、邀请好友，产生都 获得不同的美事\n2、使用美豆可以在兑换区兑换产品\n3、不同产品的美豆兑换比不一样\n4、兑换流程为：进入我的美豆，点击兑换商品，开始兑换。\n1、注册、分享、邀请好友，产生都 获得不同的美事\n2、使用美豆可以在兑换区兑换产品\n3、不同产品的美豆兑换比不一样\n4、兑换流程为：进入我的美豆，点击兑换商品，开始兑换。\n1、注册、分享、邀请好友，产生都 获得不同的美事\n2、使用美豆可以在兑换区兑换产品\n3、不同产品的美豆兑换比不一样\n4、兑换流程为：进入我的美豆，点击兑换商品，开始兑换。"];
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
                
            }
                break;
            case 3://砍价成功 立即领取
            {
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:self.detailModel.product_id bargainId:self.detailModel.bargin_id];
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
    [MEBargainSuccessView ShowBargainSuccessWithTitle:[NSString stringWithFormat:@"您已砍%@元，人多力量大，快喊小伙伴来帮忙~",money] shareBlock:^{
        NSLog(@"点击了分享按钮");
    } cancelBlock:^{
    } superView:kMeCurrentWindow];
}

- (void)showBargainRuleViewWithTitle:(NSString *)title {
    [MEBargainRuleView ShowBargainRuleViewWithTitle:title cancelBlock:^{
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
