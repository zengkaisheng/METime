//
//  MEGetCaseCell.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGetCaseCell.h"
#import "MEGetCaseContentCell.h"
#import "MEGetCaseModel.h"

@interface MEGetCaseCell ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrData;
    BOOL _isDataDeal;
}
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTableHeight;

    
@end

@implementation MEGetCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGetCaseContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGetCaseContentCell class])];
//    _tableView.rowHeight = kMEGetCaseContentCellHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [UIView new];
    // Initialization code
}

- (void)setUIWithModel:(MEGetCaseModel *)model{
    _isDataDeal = NO;
    _lblNo.text = kMeUnNilStr(model.order_sn);
    _lblStatus.text = kMeUnNilStr(model.order_goods_status_name);
    _arrData = kMeUnArr(model.goods);
    CGFloat height = 0;
    for (MEGetCaseContentModel *model in _arrData) {
        height += [MEGetCaseContentCell getCellHeightWithModel:model];
    }
    _consTableHeight.constant = height;
    [self.tableView reloadData];
}

- (void)setUIDataDealWIthModel:(MEGetCaseModel *)model{
    _isDataDeal = YES;
    _lblNo.text = kMeUnNilStr(model.order_sn);
    _lblStatus.hidden = YES;
    _arrData = kMeUnArr(model.goods);
    _consTableHeight.constant = kMEGetCaseContentCellHeight * kMeUnArr(_arrData).count;
    [self.tableView reloadData];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kMeUnArr(_arrData).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGetCaseContentCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGetCaseContentCell class]) forIndexPath:indexPath];
    if(_isDataDeal){
         MEGetCaseContentModel *model = kMeUnArr(_arrData)[indexPath.row];
        [cell setUIDataDealWIthModel:model];
    }else{
        MEGetCaseContentModel *model = kMeUnArr(_arrData)[indexPath.row];
        [cell setUIWIthModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isDataDeal){
        return kMEGetCaseContentCellHeight;
    }
    MEGetCaseContentModel *model = kMeUnArr(_arrData)[indexPath.row];
    return [MEGetCaseContentCell getCellHeightWithModel:model];
}

+ (CGFloat)getCellDataDealHeightWithModel:(MEGetCaseModel *)model{
    CGFloat height = 56;
    NSArray *arrdata =  kMeUnArr(model.goods);
    height += kMEGetCaseContentCellHeight * arrdata.count;
    return height;
}

+ (CGFloat)getCellHeightWithModel:(MEGetCaseModel *)model{
    CGFloat height = 56;
    NSArray *arrdata =  kMeUnArr(model.goods);
    for (MEGetCaseContentModel *model in arrdata) {
        height += [MEGetCaseContentCell getCellHeightWithModel:model];
    }
    return height;
}


@end
