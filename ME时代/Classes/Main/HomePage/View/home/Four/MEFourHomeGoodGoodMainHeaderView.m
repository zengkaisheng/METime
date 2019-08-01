//
//  MEFourHomeGoodGoodMainHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeGoodGoodMainHeaderView.h"
#import "MEGoodModel.h"
#import "METhridHomeGoodGoodMainCell.h"
#import "METhridHomeCommondSectionView.h"

#import "MEFourHomeVC.h"
#import "METhridProductDetailsVC.h"

#import "MEGroupListModel.h"
#import "MEGroupListCell.h"
#import "MEGroupProductDetailVC.h"
#import "MEBargainListModel.h"
#import "MEBargainLisCell.h"
#import "MEBargainDetailVC.h"
#import "MEHomeRecommendModel.h"

#import "MEJoinPrizeVC.h"
#import "MEFourHomeActivityCell.h"

@interface MEFourHomeGoodGoodMainHeaderView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_arrHot;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


@implementation MEFourHomeGoodGoodMainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeGoodGoodMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEFourHomeActivityCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGroupListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGroupListCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBargainLisCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBargainLisCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeCommondSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
}
#pragma mark -- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrHot.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = _arrHot[section];
    if (section == 0) {
        NSArray *activity = dict[@"activity"];
        return activity.count;
    }
    NSArray *goods = dict[@"goods"];
    return goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _arrHot[indexPath.section];
    if (indexPath.section == 0) {
        NSArray *activity = dict[@"activity"];
        MEHomeRecommendModel *model = activity[indexPath.row];
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
                    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                    if (homevc) {
                        [homevc.navigationController pushViewController:details animated:YES];
                    }
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
                        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                        if (homevc) {
                            [homevc.navigationController pushViewController:details animated:YES];
                        }
                    }else {
                        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                            MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                            MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                            if (homevc) {
                                [homevc.navigationController pushViewController:details animated:YES];
                            }
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
                        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                        if (homevc) {
                            [homevc.navigationController pushViewController:details animated:YES];
                        }
                    }else {
                        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                            MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                            MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                            if (homevc) {
                                [homevc.navigationController pushViewController:details animated:YES];
                            }
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
                    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                    if (homevc) {
                        [homevc.navigationController pushViewController:details animated:YES];
                    }
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
                        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                        if (homevc) {
                            [homevc.navigationController pushViewController:details animated:YES];
                        }
                    }else {
                        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                            MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                            MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
                            if (homevc) {
                                [homevc.navigationController pushViewController:details animated:YES];
                            }
                        } failHandler:^(id object) {
                        }];
                    }
                };
                return cell;
            }
            default:
                break;
        }
    }
    NSArray *goods = dict[@"goods"];
    MEHomeRecommendModel *model = goods[indexPath.row];
    METhridHomeGoodGoodMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class]) forIndexPath:indexPath];
    MEGoodModel *goodModel = [MEGoodModel mj_objectWithKeyValues:model.mj_keyValues];
    [cell setUIWithModel:goodModel];
    kMeWEAKSELF
    cell.buyBlock = ^{
        kMeSTRONGSELF
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:strongSelf];
        if (homevc) {
            [homevc.navigationController pushViewController:details animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kMMEFourHomeActivityCellHeight;
    }
    return kMEThridHomeGoodGoodMainCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _arrHot[indexPath.section];
    if (indexPath.section == 0) {
        NSArray *activity = dict[@"activity"];
        MEHomeRecommendModel *model = activity[indexPath.row];
        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
        switch (model.type) {
            case 1:
            {
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.ids];
                if (homevc) {
                    [homevc.navigationController pushViewController:details animated:YES];
                }
            }
                break;
            case 2:
            {
                if([MEUserInfoModel isLogin]){
                    MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                    if (homevc) {
                        [homevc.navigationController pushViewController:details animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                        if (homevc) {
                            [homevc.navigationController pushViewController:details animated:YES];
                        }
                    } failHandler:^(id object) {
                    }];
                }
            }
                break;
            case 3:
            {
                if([MEUserInfoModel isLogin]){
                    MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    if (homevc) {
                        [homevc.navigationController pushViewController:details animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                        if (homevc) {
                            [homevc.navigationController pushViewController:details animated:YES];
                        }
                    } failHandler:^(id object) {
                    }];
                }
            }
                break;
            case 4:
            {
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                if (homevc) {
                    [homevc.navigationController pushViewController:details animated:YES];
                }
            }
                break;
            case 5:
            {
                if([MEUserInfoModel isLogin]){
                    MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                    if (homevc) {
                        [homevc.navigationController pushViewController:details animated:YES];
                    }
                }else {
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                        MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                        if (homevc) {
                            [homevc.navigationController pushViewController:details animated:YES];
                        }
                    } failHandler:^(id object) {
                    }];
                }
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        NSArray *goods = dict[@"goods"];
        MEHomeRecommendModel *model = goods[indexPath.row];
        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.ids];
        if (homevc) {
            [homevc.navigationController pushViewController:details animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dict = _arrHot[section];
    if (section == 0) {
        NSArray *activity = dict[@"activity"];
        if (activity.count > 0) {
            return 35;
        }
    }else if (section == 1) {
        NSArray *goods = dict[@"goods"];
        if (goods.count > 0) {
            return 42;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    METhridHomeCommondSectionView *headview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
    [headview setUIWithIndex:section];
    return headview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return kMMEThridHomeCommondSectionViewHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    METhridHomeCommondSectionView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
    [footView setUIWithIndex:2];
    return footView;
}

- (void)setupUIWithArray:(NSArray *)array {
    _arrHot = [NSArray arrayWithArray:array];
    [self.tableView reloadData];
}

@end
