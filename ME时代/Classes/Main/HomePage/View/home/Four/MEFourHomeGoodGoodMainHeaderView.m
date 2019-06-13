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
    METhridHomeGoodGoodMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class]) forIndexPath:indexPath];
    MEGoodModel *model = _arrHot[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.buyBlock = ^{
        kMeSTRONGSELF
        MEGoodModel *model = strongSelf->_arrHot[indexPath.row];
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
        if (homevc) {
            [homevc.navigationController pushViewController:details animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEThridHomeGoodGoodMainCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodModel *model = _arrHot[indexPath.row];
    METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if (homevc) {
        [homevc.navigationController pushViewController:details animated:YES];
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
