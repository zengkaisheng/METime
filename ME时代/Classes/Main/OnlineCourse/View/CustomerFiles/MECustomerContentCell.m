//
//  MECustomerContentCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerContentCell.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MECustomerAddInfoCell.h"
#import "MEDiagnoseOptionsCell.h"
#import "MEAddCustomerInfoModel.h"
#import "MELivingHabitListModel.h"
#import "MECustomerClassifyListModel.h"

#import "DatePickerView.h"
#import "DataPickerView.h"

#import "MECustomerDetailVC.h"
#import "MECustomerTypeListVC.h"

@interface MECustomerContentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isAdd;

@end


@implementation MECustomerContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerAddInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerAddInfoCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseOptionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class])];
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseReportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseReportCell class])];
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEReportSuggestsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEReportSuggestsCell class])];
    
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
    if (self.type == 2) {
        return self.datas.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 2) {
        MELivingHabitListModel *model = self.datas[section];
        return model.habit.count+1;
    }
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        MELivingHabitListModel *listModel = self.datas[indexPath.section];
        
        if (indexPath.row == 0) {
            MECustomerAddInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerAddInfoCell class]) forIndexPath:indexPath];
            MEAddCustomerInfoModel *model = [self creatModelWithTitle:kMeUnNilStr(listModel.classify_title) andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
            model.isLastItem = YES;
            [cell setUIWithCustomerModel:model];
            return cell;
        }
        MEDiagnoseOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class]) forIndexPath:indexPath];
        MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row-1];
        [cell setUIWithHabitsModel:habitsModel];
        return cell;
    }
    MECustomerAddInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerAddInfoCell class]) forIndexPath:indexPath];
    MEAddCustomerInfoModel *model = self.datas[indexPath.row];
    [cell setUIWithCustomerModel:model];
    cell.textBlock = ^(NSString *str) {
        model.value = str;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        if (indexPath.row == 0) {
            return 44;
        }
        MELivingHabitListModel *listModel = self.datas[indexPath.section];
        MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row-1];
        return habitsModel.cellHeight;
    }
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == 2) {
        if (section != 0) {
            return 1;
        }
    }
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [headerView setUIWithSectionTitle:self.titleStr isAdd:self.isAdd];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [footerView setUIWithTitle:@"" font:0.0 isHiddenBtn:YES];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        MEAddCustomerInfoModel *model = self.datas[indexPath.row];
        if (self.isAdd) {
            if (indexPath.row == 1) {
                [self showDataPickWithIndexPath:indexPath];
            }else if (indexPath.row == 2) {
                [self showDatePickerWithIndexPath:indexPath];
            }else if (indexPath.row == 12) {
                [self showDataPickWithIndexPath:indexPath];
            }else if (indexPath.row == 17) {
                [kMeCurrentWindow endEditing:YES];
                MECustomerDetailVC *homeVC = (MECustomerDetailVC *)[MECommonTool getVCWithClassWtihClassName:[MECustomerDetailVC class] targetResponderView:self];
                if (homeVC) {
                    kMeWEAKSELF
                    MECustomerTypeListVC *vc = [[MECustomerTypeListVC alloc] init];
                    vc.contentBlock = ^(id object) {
                        kMeSTRONGSELF
                        if ([object isKindOfClass:[MECustomerClassifyListModel class]]) {
                            MECustomerClassifyListModel *classifyModel = (MECustomerClassifyListModel *)object;
                            model.valueId = [NSString stringWithFormat:@"%@",@(classifyModel.idField)];
                            model.value = classifyModel.classify_name;
                            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    };
                    [homeVC.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
    if (self.type == 2) {
        MELivingHabitListModel *listModel = self.datas[indexPath.section];
        if (listModel.type == 1) {
            for (MELivingHabitsOptionModel *habitsModel in listModel.habit) {
                habitsModel.isSelected = NO;
            }
            MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row-1];
            habitsModel.isSelected = YES;
        }else if (listModel.type == 0) {
            MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row-1];
            habitsModel.isSelected = !habitsModel.isSelected;
        }
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)showDatePickerWithIndexPath:(NSIndexPath *)indexPath {
    MEAddCustomerInfoModel *model = self.datas[indexPath.row];
    
    DatePickerView *datePickerView = [[DatePickerView alloc] init];
    datePickerView.title = @"选择日期";
    datePickerView.isBeforeTime = YES;
    kMeWEAKSELF
    datePickerView.selectBlock = ^(NSString *selectDate) {
        kMeSTRONGSELF
        if ([selectDate length] > 0) {
            NSString *tempDate = [selectDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            NSLog(@"选择的日期是：%@",tempDate);
            model.value = tempDate;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    
    [kMeCurrentWindow endEditing:YES];
}

- (void)showDataPickWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [NSArray new];
    NSString *title;
    if (indexPath.row == 1) {
        array = @[@{@"name":@"男",@"value":@"1"},@{@"name":@"女",@"value":@"2"}];
        title = @"请选择性别";
    }else if (indexPath.row == 12) {
        array = @[@{@"name":@"已婚",@"value":@"1"},@{@"name":@"未婚",@"value":@"0"}];
        title = @"请选择婚否";
    }
    kMeWEAKSELF
    [kMeCurrentWindow endEditing:YES];
    
    MEAddCustomerInfoModel *model = self.datas[indexPath.row];
    
    DataPickerView *dataPicker = [[DataPickerView alloc] init];
    dataPicker.pickerHeight = 52 * (array.count + 2);
    dataPicker.title = title;
    dataPicker.dataSource = array;
    dataPicker.selectedData = model.value;
    dataPicker.selectBlock = ^(NSString *selectData, NSString *selectId) {
        kMeSTRONGSELF
        NSLog(@"value:%@,id:%@",selectData,selectId);
        model.value = selectData;
        model.valueId = selectId;
        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder andMaxInputWords:(NSInteger)maxInputWords andIsTextField:(BOOL)isTextField andIsMustInput:(BOOL)isMustInput andToastStr:(NSString *)toastStr{
    
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = @" ";
    model.placeHolder = placeHolder;
    model.maxInputWord = maxInputWords;
    model.isTextField = isTextField;
    model.isMustInput = isMustInput;
    model.toastStr = toastStr;
    model.isEdit = YES;
    model.isHideArrow = YES;
    return model;
}

//建议
- (void)setUIWithArray:(NSArray *)array {
    self.datas = [array copy];
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithArray:(NSArray *)array {
    CGFloat height = 49.0;
//    for (int i = 0; i < array.count; i++) {
//        NSString *str = [NSString stringWithFormat:@"%d、%@",i+1,array[i]];
//        height += [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
//    }
    return height+20;
}

- (void)setUIWithInfo:(NSDictionary *)info isAdd:(BOOL)isAdd {
    self.titleStr = info[@"title"];
    self.type = [info[@"type"] integerValue];
    NSArray *list = info[@"content"];
    self.isAdd = isAdd;
    self.datas = list;
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithInfo:(NSDictionary *)info {
    CGFloat height = 49.0;
    if ([info[@"type"] integerValue] == 1) {
        NSArray *list = info[@"content"];
        height += 22+52*list.count;
    }else if ([info[@"type"] integerValue] == 2) {
        NSArray *habitList = info[@"content"];
        for (MELivingHabitListModel *listModel in habitList) {
            height += 44+10;
            for (MELivingHabitsOptionModel *habitsModel in listModel.habit) {
                height += habitsModel.cellHeight;
            }
        }
        height += 20;
    }
    
    return height;
}

@end
