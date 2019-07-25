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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrHot.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeRecommendModel *model = _arrHot[indexPath.row];
    switch (model.type) {
        case 1:
        {
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
        {
            MEBargainLisCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBargainLisCell class]) forIndexPath:indexPath];
            MEBargainListModel *bargainModel = [MEBargainListModel mj_objectWithKeyValues:model.mj_keyValues];
            bargainModel.product_price = model.money;
            [cell setHomeUIWithModel:bargainModel];
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
        {
            MEGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGroupListCell class]) forIndexPath:indexPath];
            MEGroupListModel *groupModel = [MEGroupListModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setHomeUIWithModel:groupModel];
            kMeWEAKSELF
            cell.groupBlock = ^{
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
        {
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
        case 5:
        {
            METhridHomeGoodGoodMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class]) forIndexPath:indexPath];
            MEGoodModel *goodModel = [MEGoodModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setUIWithModel:goodModel];
            kMeWEAKSELF
            cell.buyBlock = ^{
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
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEThridHomeGoodGoodMainCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeRecommendModel *model = _arrHot[indexPath.row];
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
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.ids];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kMMEThridHomeCommondSectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    METhridHomeCommondSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
    return headview;
}

- (void)setupUIWithArray:(NSArray *)array {
    _arrHot = [NSArray arrayWithArray:array];
    [self.tableView reloadData];
}

@end
