//
//  MECustomerServiceContentCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceContentCell.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MECustomerAddInfoCell.h"
#import "MEAddCustomerInfoModel.h"
#import "MEServiceCardCell.h"
#import "MECustomerServiceDetailModel.h"

#import "DatePickerView.h"
#import "MEAddServiceVC.h"
#import "MEClerkManngerVC.h"

#import "MECustomerServiceDetailVC.h"
#import "MECustomerServiceLogsVC.h"

@interface MECustomerServiceContentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isHiddenHeaderV;
@property (nonatomic, assign) BOOL isLogs;

@end

@implementation MECustomerServiceContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerAddInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerAddInfoCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEServiceCardCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEServiceCardCell class])];
    
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
    if (self.isLogs) {
        return self.dataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isLogs) {
        NSArray *logs = self.dataSource[section];
        return logs.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        MEServiceCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEServiceCardCell class]) forIndexPath:indexPath];
        MEServiceDetailSubModel *model = self.dataSource[indexPath.row];
        [cell setUIWithServiceModel:model index:indexPath.row];
        return cell;
    }
    MECustomerAddInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerAddInfoCell class]) forIndexPath:indexPath];
    if (self.isLogs) {
        NSArray *logs = self.dataSource[indexPath.section];
        MEAddCustomerInfoModel *model = logs[indexPath.row];
        [cell setUIWithCustomerModel:model];
    }else {
        MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
        [cell setUIWithCustomerModel:model];
        if (model.isTextField) {
            cell.textBlock = ^(NSString *str) {
                model.value = str;
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        return kMEServiceCardCellHeight;
    }
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isAdd) {
        if (section != 0) {
            return 0;
        }
    }
    if (self.isLogs) {
        return 0;
    }
    if (self.isHiddenHeaderV) {
        return 0;
    }
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [headerView setUIWithSectionTitle:self.titleStr isHeader:YES];
    
    if (self.isAdd) {
        headerView.isShowArrow = NO;
    }else {
        kMeWEAKSELF
        headerView.tapBlock = ^(BOOL isTap) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.indexBlock,0);
        };
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.type == 1) {
        return 0;
    }
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [footerView setUIWithSectionTitle:@"" isHeader:NO];
    kMeWEAKSELF
    footerView.tapBlock = ^(BOOL isTap) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.indexBlock,1);
    };
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAdd) {
        MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
        if (indexPath.row == 1) {
            if ([model.title isEqualToString:@"开卡时间"]) {
                if (!model.isHideArrow) {
                    [self showServiceDatePickerWithIndexPath:indexPath title:kMeUnNilStr(model.title)];
                }
            }else if ([model.title isEqualToString:@"服务时间"]) {
                [self showServiceDatePickerWithIndexPath:indexPath title:kMeUnNilStr(model.title)];
            }
        }else if (indexPath.row == 2){
            if ([model.title isEqualToString:@"剩余时间"]) {
                if (!model.isHideArrow) {
                    [self showServiceDatePickerWithIndexPath:indexPath title:kMeUnNilStr(model.title)];
                }
            }else if ([model.title isEqualToString:@"服务人员"]) {
                MEAddServiceVC *homeVc = [MECommonTool getVCWithClassWtihClassName:[MEAddServiceVC class] targetResponderView:self];
                if (homeVc) {
                    kMeWEAKSELF
                    MEClerkManngerVC *clerkVC = [[MEClerkManngerVC alloc] init];
                    clerkVC.isChoose = YES;
                    clerkVC.chooseBlock = ^(NSString *name, NSString *memberId) {
                        kMeSTRONGSELF
                        model.value = name;
                        model.valueId = memberId;
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                    [homeVc.navigationController pushViewController:clerkVC animated:YES];
                }
            }
        }
    }else {
        if (self.type == 2) {
            MEServiceDetailSubModel *model = self.dataSource[indexPath.row];
            MECustomerServiceDetailVC *homeVc = [MECommonTool getVCWithClassWtihClassName:[MECustomerServiceDetailVC class] targetResponderView:self];
            if (homeVc) {
                MECustomerServiceLogsVC *vc = [[MECustomerServiceLogsVC alloc] initWithFilesId:model.idField];
                [homeVc.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)showServiceDatePickerWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title{
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    
    DatePickerView *datePickerView = [[DatePickerView alloc] init];
    datePickerView.title = title;
    datePickerView.isBeforeTime = YES;
    if ([title isEqualToString:@"服务时间"]) {
        datePickerView.isShowHour = YES;
    }else {
        datePickerView.isShowHour = NO;
    }
    
    kMeWEAKSELF
    datePickerView.selectBlock = ^(NSString *selectDate) {
        kMeSTRONGSELF
        if ([selectDate length] > 0) {
            NSString *tempDate = [selectDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            //            NSLog(@"选择的日期是：%@",tempDate);
            model.value = tempDate;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    [datePickerView show];
    [kMeCurrentWindow endEditing:YES];
}

- (void)setUIWithInfo:(NSDictionary *)info{
    self.titleStr = kMeUnNilStr(info[@"title"]);
    self.type = [info[@"type"] integerValue];
    if ([info.allKeys containsObject:@"isAdd"]) {
        self.isAdd = [info[@"isAdd"] boolValue];
    }
    if ([info.allKeys containsObject:@"isLogs"]) {
        self.isLogs = [info[@"isLogs"] boolValue];
    }
    if ([info.allKeys containsObject:@"isHiddenHeaderV"]) {
        self.isHiddenHeaderV = [info[@"isHiddenHeaderV"] boolValue];
    }
    
    NSArray *list = kMeUnArr(info[@"content"]);
    self.dataSource = list;
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithInfo:(NSDictionary *)info {
    CGFloat height = 49.0;
    NSInteger type = [info[@"type"] integerValue];
    NSArray *list = kMeUnArr(info[@"content"]);
    
    if (type == 1) {
        if ([info.allKeys containsObject:@"isLogs"]) {
            height  = 0;
            for (NSArray *logs in list) {
                height += 52*logs.count;
            }
        }else if ([info.allKeys containsObject:@"isHiddenHeaderV"]) {
            height = 0;
            height += 52*list.count;
        }else {
            height += 52*list.count;
        }
    }else if (type == 2) {
        height += 52;
        height += kMEServiceCardCellHeight*list.count;
    }
    return height+20;
}

@end
