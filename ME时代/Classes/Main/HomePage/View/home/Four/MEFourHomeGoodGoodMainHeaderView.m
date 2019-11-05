//
//  MEFourHomeGoodGoodMainHeaderView.m
//  志愿星
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
#import "MEGroupProductDetailVC.h"
#import "MEBargainListModel.h"
#import "MEBargainDetailVC.h"
#import "MEHomeRecommendModel.h"

#import "MEJoinPrizeVC.h"
#import "MEFourHomeActivityCell.h"

#import "MEPersonalCourseListModel.h"
#import "MEPersonalCourseCell.h"
#import "MEPersionalCourseDetailVC.h"

#import "MEFiveHomeVC.h"

@interface MEFourHomeGoodGoodMainHeaderView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_arrHot;
    BOOL _isShow;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


@implementation MEFourHomeGoodGoodMainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeGoodGoodMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEFourHomeActivityCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPersonalCourseCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeCommondSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
}
#pragma mark -- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_arrHot.count <= 0) {
        if (_isShow) {
            return 1;
        }
    }
    return _arrHot.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrHot.count > 0) {
        NSDictionary *dict = _arrHot[section];
        if ([dict.allKeys containsObject:@"activity"]) {
            NSArray *activity = dict[@"activity"];
            return activity.count;
        }else if ([dict.allKeys containsObject:@"goods"]) {
            NSArray *goods = dict[@"goods"];
            return goods.count;
        }else if ([dict.allKeys containsObject:@"excellent_course"]) {
            NSArray *excellent_course = dict[@"excellent_course"];
            return excellent_course.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_arrHot.count > 0) {
        NSDictionary *dict = _arrHot[indexPath.section];
        if ([dict.allKeys containsObject:@"activity"]) {
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
                        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
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
                            MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
                            if (homevc) {
                                [homevc.navigationController pushViewController:details animated:YES];
                            }
                        }else {
                            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                                MEBargainDetailVC *details = [[MEBargainDetailVC alloc] initWithBargainId:model.ids myList:NO];
                                MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
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
                            MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
                            if (homevc) {
                                [homevc.navigationController pushViewController:details animated:YES];
                            }
                        }else {
                            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                                MEGroupProductDetailVC *details = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                                MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
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
                        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
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
                            MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
                            if (homevc) {
                                [homevc.navigationController pushViewController:details animated:YES];
                            }
                        }else {
                            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                                MEJoinPrizeVC *details = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.ids]];
                                MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
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
        }else if ([dict.allKeys containsObject:@"goods"]) {
            NSArray *goods = dict[@"goods"];
            MEHomeRecommendModel *model = goods[indexPath.row];
            METhridHomeGoodGoodMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class]) forIndexPath:indexPath];
            MEGoodModel *goodModel = [MEGoodModel mj_objectWithKeyValues:model.mj_keyValues];
            [cell setUIWithModel:goodModel];
            kMeWEAKSELF
            cell.buyBlock = ^{
                kMeSTRONGSELF
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:strongSelf];
                if (homevc) {
                    [homevc.navigationController pushViewController:details animated:YES];
                }
            };
            return cell;
        }else if ([dict.allKeys containsObject:@"excellent_course"]) {
            NSArray *excellent_course = dict[@"excellent_course"];
            MECourseListModel *model = excellent_course[indexPath.row];
            MEPersonalCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPersonalCourseCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:model];
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_arrHot.count > 0) {
        NSDictionary *dict = _arrHot[indexPath.section];
        if ([dict.allKeys containsObject:@"activity"]) {
            return kMMEFourHomeActivityCellHeight;
        }else if ([dict.allKeys containsObject:@"goods"]) {
            return kMEThridHomeGoodGoodMainCellHeight;
        }else if ([dict.allKeys containsObject:@"excellent_course"]) {
            return kMEPersonalCourseCellHeight;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _arrHot[indexPath.section];
    if ([dict.allKeys containsObject:@"activity"]) {
        NSArray *activity = dict[@"activity"];
        MEHomeRecommendModel *model = activity[indexPath.row];
        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
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
    }else if ([dict.allKeys containsObject:@"goods"]) {
        NSArray *goods = dict[@"goods"];
        MEHomeRecommendModel *model = goods[indexPath.row];
        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.ids];
        if (homevc) {
            [homevc.navigationController pushViewController:details animated:YES];
        }
    }else if ([dict.allKeys containsObject:@"excellent_course"]) {
        NSArray *excellent_course = dict[@"excellent_course"];
        MECourseListModel *model = excellent_course[indexPath.row];
        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
        MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.idField];
        if (homevc) {
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_arrHot.count > 0) {
        NSDictionary *dict = _arrHot[section];
        if ([dict.allKeys containsObject:@"activity"]) {
            NSArray *activity = dict[@"activity"];
            if (activity.count > 0) {
                return 36;
            }
        }else if ([dict.allKeys containsObject:@"goods"]) {
            NSArray *goods = dict[@"goods"];
            if (goods.count > 0) {
                return 42;
            }
        }else if ([dict.allKeys containsObject:@"learn"]) {
            return 36;
        }else if ([dict.allKeys containsObject:@"excellent_course"]) {
            NSArray *excellent_course = dict[@"excellent_course"];
            if (excellent_course.count > 0) {
                return 36;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_arrHot.count > 0) {
        METhridHomeCommondSectionView *headview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
        NSDictionary *dict = _arrHot[section];
        NSInteger index = 0;
        if ([dict.allKeys containsObject:@"activity"]) {
            NSArray *activity = dict[@"activity"];
            if (activity.count > 0) {
                index = 0;
            }
        }else if ([dict.allKeys containsObject:@"goods"]) {
            NSArray *goods = dict[@"goods"];
            if (goods.count > 0) {
                index = 1;
            }
        }else if ([dict.allKeys containsObject:@"learn"]) {
            index = 3;
        }else if ([dict.allKeys containsObject:@"excellent_course"]) {
            NSArray *excellent_course = dict[@"excellent_course"];
            if (excellent_course.count > 0) {
                index = 4;
            }
        }
        [headview setUIWithIndex:index];
        return headview;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_isShow) {
        return kMMEThridHomeCommondSectionViewHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    METhridHomeCommondSectionView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
    [footView setUIWithIndex:2];
    return footView;
}

- (void)setupUIWithArray:(NSArray *)array showFooter:(BOOL)show{
    _arrHot = [NSArray arrayWithArray:array];
    _isShow = show;
    [self.tableView reloadData];
}

@end
