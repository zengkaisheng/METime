//
//  MECustomerExpenseContentCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerExpenseContentCell.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MECustomerAddInfoCell.h"
#import "MEAddCustomerInfoModel.h"
#import "MEServiceCardCell.h"
#import "MECustomerExpenseDetailModel.h"
#import "MEExpenseSourceModel.h"
#import "MEDiagnoseOptionsCell.h"

#import "DatePickerView.h"

#import "MECustomerConsumeDetailVC.h"
#import "MEAddExpenseVC.h"

#import "MEAddAppointmentVC.h"
#import "MEClerkManngerVC.h"
#import "MEAppointmentCustomerListVC.h"
#import "MEProjectSettingVC.h"

@interface MECustomerExpenseContentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isHiddenHeaderV;
@property (nonatomic, assign) BOOL filesId;
@property (nonatomic, assign) NSInteger sourceCount;
@property (nonatomic, assign) NSInteger natureCount;

@end

@implementation MECustomerExpenseContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerAddInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerAddInfoCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseOptionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class])];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        MEServiceCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEServiceCardCell class]) forIndexPath:indexPath];
        MEExpenseDetailSubModel *model = self.dataSource[indexPath.row];
        [cell setUIWithExpenseModel:model];
        return cell;
    }
    
    if (self.sourceCount > 0) {
        if (indexPath.row > 2 && indexPath.row < 2+1+self.sourceCount) {
            MEDiagnoseOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class]) forIndexPath:indexPath];
            MEExpenseSourceModel *sourceModel = self.dataSource[indexPath.row];
            [cell setUIWithExpenseSourceModel:sourceModel];
            return cell;
        }
    }
    if (self.natureCount > 0) {
        if (indexPath.row > self.dataSource.count-1-2-self.natureCount && indexPath.row < self.dataSource.count-2) {
            MEDiagnoseOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class]) forIndexPath:indexPath];
            MEExpenseSourceModel *natureModel = self.dataSource[indexPath.row];
            [cell setUIWithExpenseSourceModel:natureModel];
            return cell;
        }
    }
    
    MECustomerAddInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerAddInfoCell class]) forIndexPath:indexPath];
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    [cell setUIWithCustomerModel:model];
    if (model.isTextField) {
        cell.textBlock = ^(NSString *str) {
            model.value = str;
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        MEExpenseDetailSubModel *model = self.dataSource[indexPath.row];
        if (model.type == 4 ) {
            return 82;
        }
        return kMEServiceCardCellHeight;
    }
    if (self.sourceCount > 0) {
        if (indexPath.row > 2 && indexPath.row < 2+1+self.sourceCount) {
            MEExpenseSourceModel *sourceModel = self.dataSource[indexPath.row];
            return sourceModel.cellHeight;
        }
    }
    if (self.natureCount > 0) {
        if (indexPath.row > self.dataSource.count-1-2-self.natureCount && indexPath.row < self.dataSource.count-2) {
            MEExpenseSourceModel *natureModel = self.dataSource[indexPath.row];
            return natureModel.cellHeight;
        }
    }
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isHiddenHeaderV) {
        return 0;
    }
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [headerView setUIWithSectionTitle:self.titleStr isHeader:YES];
    
    kMeWEAKSELF
    headerView.tapBlock = ^(BOOL isTap) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.indexBlock,0);
    };
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
    if ([self.titleStr isEqualToString:@"会员充值"]) {
        [footerView setUIWithSectionTitle:@"充值" isHeader:NO];
    }else {
        [footerView setUIWithSectionTitle:@"" isHeader:NO];
    }
    kMeWEAKSELF
    footerView.tapBlock = ^(BOOL isTap) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.indexBlock,1);
    };
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        if ([self.titleStr isEqualToString:@"顾客预约"] || [self.titleStr isEqualToString:@"编辑顾客预约"]) {
            [self endEditing:YES];
            MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
            
            MEAddAppointmentVC *homeVc = [MECommonTool getVCWithClassWtihClassName:[MEAddAppointmentVC class] targetResponderView:self];
            kMeWEAKSELF
            switch (indexPath.row) {
                case 0:
                {
                    if (homeVc) {
                        MEAppointmentCustomerListVC *customerList = [[MEAppointmentCustomerListVC alloc] init];
                        customerList.isFileList = YES;
                        customerList.chooseBlock = ^(NSString * _Nonnull str, NSInteger ids) {
                           kMeSTRONGSELF
                            model.value = str;
                            model.valueId = [NSString stringWithFormat:@"%@",@(ids)];
                            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };
                        [homeVc.navigationController pushViewController:customerList animated:YES];
                    }
                }
                    break;
                case 1:
                case 2:
                {//选择美容师
                    if (homeVc) {
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
                    break;
                case 3:
                    //选择预约时间
                    [self showServiceDatePickerWithIndexPath:indexPath title:@"预约时间"];
                    break;
                case 4:
                {
                    if (homeVc) {
                        MEProjectSettingVC *vc = [[MEProjectSettingVC alloc] init];
                        vc.chooseBlock = ^(NSDictionary *dic) {
                            kMeSTRONGSELF
                            model.value = kMeUnNilStr(dic[@"name"]);
                            model.valueId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                            
                            MEAddCustomerInfoModel *moneyModel = self.dataSource[indexPath.row+1];
                            moneyModel.value = [NSString stringWithFormat:@"%@",dic[@"money"]];
                            [strongSelf.tableView reloadData];
                        };
                        [homeVc.navigationController pushViewController:vc animated:YES];
                        
//                        MEAppointmentCustomerListVC *customerList = [[MEAppointmentCustomerListVC alloc] init];
//                        customerList.chooseBlock = ^(NSString * _Nonnull str, NSInteger ids) {
//                            kMeSTRONGSELF
//                            model.value = str;
//                            model.valueId = [NSString stringWithFormat:@"%@",@(ids)];
//                            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                        };
//                        [homeVc.navigationController pushViewController:customerList animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
        }else if ([self.titleStr isEqualToString:@"会员充值"]) {
            MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
            if ([model.title isEqualToString:@"充值时间"]) {
                if (!model.isHideArrow) {
                    [self showServiceDatePickerWithIndexPath:indexPath title:kMeUnNilStr(model.title)];
                }
            }
        }else {
            if (self.sourceCount > 0) {
                if (indexPath.row > 2 && indexPath.row < 2+1+self.sourceCount) {
                    for (id obj in self.dataSource) {
                        if ([obj isKindOfClass:[MEExpenseSourceModel class]]) {
                            MEExpenseSourceModel *model = (MEExpenseSourceModel *)obj;
                            model.isSelected = NO;
                        }
                    }
                    MEExpenseSourceModel *sourceModel = self.dataSource[indexPath.row];
                    sourceModel.isSelected = !sourceModel.isSelected;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            if (self.natureCount > 0) {
                if (indexPath.row > self.dataSource.count-1-2-self.natureCount && indexPath.row < self.dataSource.count-2) {
                    MEExpenseSourceModel *natureModel = self.dataSource[indexPath.row];
                    natureModel.isSelected = !natureModel.isSelected;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            id obj = self.dataSource[indexPath.row];
            if ([obj isKindOfClass:[MEAddCustomerInfoModel class]]) {
                MEAddCustomerInfoModel *model = (MEAddCustomerInfoModel *)obj;
                if ([model.title isEqualToString:@"消费时间"] || [model.title isEqualToString:@"开卡时间"] ) {
                    if (!model.isHideArrow) {
                        [self showServiceDatePickerWithIndexPath:indexPath title:kMeUnNilStr(model.title)];
                    }
                }
            }
        }
    }else if (self.type == 2) {
        MEExpenseDetailSubModel *model = self.dataSource[indexPath.row];
        
        MECustomerConsumeDetailVC *homeVc = [MECommonTool getVCWithClassWtihClassName:[MECustomerConsumeDetailVC class] targetResponderView:self];
        if (homeVc) {
            NSDictionary *info = @{@"title":self.titleStr,@"type":@(self.type),@"content":@[model]};
            MEAddExpenseVC *vc = [[MEAddExpenseVC alloc] initWithInfo:info filesId:self.filesId];
            vc.isEdit = YES;
            kMeWEAKSELF
            vc.finishBlock = ^(id object) {
                kMeSTRONGSELF
                kMeCallBlock(strongSelf.indexBlock,2);
            };
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)showServiceDatePickerWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title{
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    
    DatePickerView *datePickerView = [[DatePickerView alloc] init];
    datePickerView.title = title;
    datePickerView.isBeforeTime = YES;
    datePickerView.isShowHour = YES;
    
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
    if ([info.allKeys containsObject:@"filesId"]) {
        self.filesId = info[@"filesId"];
    }
    if ([info.allKeys containsObject:@"isHiddenHeaderV"]) {
        self.isHiddenHeaderV = info[@"isHiddenHeaderV"];
    }
    if ([info.allKeys containsObject:@"sourceCount"]) {
        self.sourceCount = [info[@"sourceCount"] integerValue];
    }
    if ([info.allKeys containsObject:@"natureCount"]) {
        self.natureCount = [info[@"natureCount"] integerValue];
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
        if ([info.allKeys containsObject:@"isHiddenHeaderV"]) {
            height = 0;
        }
        for (id Obj in list) {
            if ([Obj isKindOfClass:[MEExpenseSourceModel class]]) {
                MEExpenseSourceModel *sourceModel = (MEExpenseSourceModel *)Obj;
                height += sourceModel.cellHeight;
            }else {
                height += 52;
            }
        }
    }else if (type == 2) {
        height += 52;
        NSString *titleStr = kMeUnNilStr(info[@"title"]);
        if ([titleStr isEqualToString:@"会员充值"] ) {
            height += 82*list.count;
        }else {
            height += kMEServiceCardCellHeight*list.count;
        }
    }
    return height+20;
}

@end
