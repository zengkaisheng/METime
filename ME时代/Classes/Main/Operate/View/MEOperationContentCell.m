//
//  MEOperationContentCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOperationContentCell.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MEOperationCountCell.h"
#import "MEOperationRankCell.h"
#import "MEOperateDataModel.h"
#import "MERankingListCell.h"
#import "MEOperationClerkRankModel.h"
#import "MEOperationObjectRankModel.h"

@interface MEOperationContentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MEOperationContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOperationCountCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOperationCountCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOperationRankCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOperationRankCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERankingListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERankingListCell class])];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
    
    _tableView.layer.shadowOffset = CGSizeMake(0, 1);
    _tableView.layer.shadowOpacity = 1;
    _tableView.layer.shadowRadius = 3;
    _tableView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _tableView.layer.masksToBounds = false;
    _tableView.layer.cornerRadius = 5;
    _tableView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

#pragma mark -- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 6 || self.type == 7) {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1 || self.type == 2 || self.type == 3) {
        
        MEOperateDataSubModel *model = self.dataSource[indexPath.row];
        MEOperationCountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOperationCountCell class]) forIndexPath:indexPath];
        [cell setUpWithModel:model type:self.type];
        kMeWEAKSELF
        cell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.indexBlock,index);
        };
        return cell;
    }else if (self.type == 6) {
        MERankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERankingListCell class]) forIndexPath:indexPath];
        MEOperationClerkRankModel *model = self.dataSource[indexPath.row];
        [cell setUIWithClerkModel:model index:self.index];
        return cell;
    }else if (self.type == 7) {
        MERankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERankingListCell class]) forIndexPath:indexPath];
        MEOperationObjectRankModel *model = self.dataSource[indexPath.row];
        [cell setUIWithObjectRankModel:model index:indexPath.row + 1];
        return cell;
    }
    MEOperationRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOperationRankCell class]) forIndexPath:indexPath];
    NSArray *array = [self.dataSource copy];
    [cell setUpUIWithArry:array type:self.type index:self.index];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.indexBlock,index);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 6 || self.type == 7) {
        return 52;
    }
    return 138;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == 6 || self.type == 7) {
        return 0;
    }
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [headerView setUIWithSectionTitle:self.titleStr isHeader:YES];
    headerView.isShowLine = NO;
    if (self.type == 4 || self.type == 5) {
        headerView.isShowArrow = YES;
    }else {
        headerView.isShowArrow = NO;
    }
    kMeWEAKSELF
    headerView.tapBlock = ^(BOOL isTap) {
        kMeSTRONGSELF
        if ([strongSelf.titleStr isEqualToString:@"员工排名"]) {
            kMeCallBlock(strongSelf.indexBlock,6);
        }else if ([strongSelf.titleStr isEqualToString:@"服务项目排名"]) {
            kMeCallBlock(strongSelf.indexBlock,7);
        }
    };
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
}

- (void)setUIWithInfo:(NSDictionary *)info{
    self.titleStr = kMeUnNilStr(info[@"title"]);
    self.type = [info[@"type"] integerValue];
    NSArray *list = kMeUnArr(info[@"content"]);
    if ([info.allKeys containsObject:@"index"]) {
        self.index = [info[@"index"] integerValue];
    }
    self.dataSource = list;
    [self.tableView reloadData];
}


@end
