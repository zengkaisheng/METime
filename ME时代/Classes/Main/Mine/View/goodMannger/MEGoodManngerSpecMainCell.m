//
//  MEGoodManngerSpecMainCell.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEGoodManngerSpecMainCell.h"
#import "MEGoodManngerSpecBasicCell.h"
#import "MEGoodManngerSpecAddCell.h"
#import "MEGoodManngerAddSpecModel.h"
#import "MEGoodManngerGoodSpec.h"

@interface MEGoodManngerSpecMainCell ()<UITableViewDelegate,UITableViewDataSource>{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MEGoodManngerAddSpecModel *model;

@end

@implementation MEGoodManngerSpecMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGoodManngerSpecBasicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGoodManngerSpecBasicCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGoodManngerSpecAddCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGoodManngerSpecAddCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)setUiWihtModel:(MEGoodManngerAddSpecModel*)model{
    _model = model;
    [self.tableView reloadData];
}

- (IBAction)delAction:(UIButton *)sender {
    kMeCallBlock(_delBlock);
}


+ (CGFloat)getCellHeightWithModel:(MEGoodManngerAddSpecModel*)model{
    CGFloat height = 65;
    NSInteger count = [kMeUnArr(model.arrSpec) count];
    height+=(kMEGoodManngerSpecBasicCellHeight + (count *kMEGoodManngerSpecAddCellHeight));
    return height;
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return [kMeUnArr(_model.arrSpec) count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        MEGoodManngerGoodSpec *model = kMeUnArr(_model.arrSpec)[indexPath.row];
        MEGoodManngerSpecAddCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGoodManngerSpecAddCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:model];
        return cell;
    }else{
        MEGoodManngerSpecBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGoodManngerSpecBasicCell class]) forIndexPath:indexPath];
        [cell setUiWihtModel:_model];
        __weak typeof(cell) weakCell = cell;
        kMeWEAKSELF
        cell.touchImgBlock = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_tapImgBlock,weakCell);
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return kMEGoodManngerSpecAddCellHeight;
    }else{
        return kMEGoodManngerSpecBasicCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
