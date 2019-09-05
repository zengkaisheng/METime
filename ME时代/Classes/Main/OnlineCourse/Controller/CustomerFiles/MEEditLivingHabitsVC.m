//
//  MEEditLivingHabitsVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEditLivingHabitsVC.h"
#import "MEDiagnoseOptionsCell.h"
#import "MEDiagnoseQuestionHeaderView.h"

#import "MELivingHabitListModel.h"
#import "MECustomerTypeListVC.h"
#import "MECustomInputView.h"

@interface MEEditLivingHabitsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, assign) NSInteger type;

@end

@implementation MEEditLivingHabitsVC

- (instancetype)initWithInfo:(NSDictionary *)info customerId:(NSInteger)customerId{
    if (self = [super init]) {
        self.title = kMeUnNilStr(info[@"title"]);
        self.type = [info[@"type"] integerValue];
        [self.dataSource addObjectsFromArray:info[@"content"]];
        self.customerId = customerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
}

//修改生活习惯
- (void)saveLivingHabitList{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (MELivingHabitListModel *model in self.dataSource) {
        
        if (model.habit.count > 0) {
            NSMutableArray *habit_arr = [[NSMutableArray alloc] init];
            for (MELivingHabitsOptionModel *habitsModel in model.habit) {
                if (habitsModel.isSelected) {
                    [habit_arr addObject:@{@"id":@(habitsModel.idField),@"content":kMeUnNilStr(habitsModel.habit)}];
                }
            }
            [array addObject:@{@"type":@(model.type),@"habit_arr":[habit_arr mutableCopy],@"classify_id":@(model.idField)}];
            [habit_arr removeAllObjects];
        }
    }
    NSString *habits = [NSString convertToJsonData:array];
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditLivingHabitWithCustomerFilesId:[NSString stringWithFormat:@"%@",@(self.customerId)] habit:habits successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"修改成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock);
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

#pragma mark -- Action
- (void)bottomBtnAction {
    kMeWEAKSELF
    [MECustomInputView showCustomInputViewWithTitle:@"添加生活习惯" content:@"" showChooseBtn:YES isInput:NO saveBlock:^(NSString * str, BOOL isShow) {
        kMeSTRONGSELF
        [MEPublicNetWorkTool postAddCustomerLivingHabitClassifyWithClassifyTitle:kMeUnNilStr(str) type:isShow?1:0 successBlock:^(ZLRequestResponse *responseObject) {
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                MELivingHabitListModel *listModel = [MELivingHabitListModel mj_objectWithKeyValues:responseObject.data];
                listModel.habit = [NSArray new];
                [strongSelf.dataSource addObject:listModel];
                [strongSelf.tableView reloadData];
                kMeCallBlock(strongSelf.finishBlock);
                MECustomerTypeListVC *vc = [[MECustomerTypeListVC alloc] initWithHabitModel:listModel];
                vc.contentBlock = ^(MELivingHabitListModel *listModel) {
                    listModel = listModel;
                    [strongSelf.tableView reloadData];
                    kMeCallBlock(strongSelf.finishBlock);
                };
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(id object) {
            
        }];
    } cancelBlock:^{
    } superView:kMeCurrentWindow];
}

- (void)saveBtnAction {
    [self saveLivingHabitList];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MELivingHabitListModel *model = self.dataSource[section];
    return model.habit.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MELivingHabitListModel *listModel = self.dataSource[indexPath.section];
    
    MEDiagnoseOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row];
    [cell setUIWithHabitsModel:habitsModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MELivingHabitListModel *listModel = self.dataSource[indexPath.section];
    MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row];
    return habitsModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    MELivingHabitListModel *listModel = self.dataSource[section];
    [headerView setUIWithSectionTitle:[NSString stringWithFormat:@"%ld、%@",(long)section+1,kMeUnNilStr(listModel.classify_title)] isAdd:NO];
    kMeWEAKSELF
    headerView.tapBlock = ^(BOOL isTap) {
        kMeSTRONGSELF
        MECustomerTypeListVC *vc = [[MECustomerTypeListVC alloc] initWithHabitModel:listModel];
        vc.contentBlock = ^(MELivingHabitListModel *listModel) {
            listModel = listModel;
            [strongSelf.tableView reloadData];
            kMeCallBlock(strongSelf.finishBlock);
        };
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MELivingHabitListModel *listModel = self.dataSource[indexPath.section];
    MELivingHabitsOptionModel *habitsModel = listModel.habit[indexPath.row];
    if (listModel.type == 1) {
        for (MELivingHabitsOptionModel *habitsModel in listModel.habit) {
            habitsModel.isSelected = NO;
        }
    }
    if (habitsModel.habit_type == 1) {//输入
        habitsModel.isSelected = YES;
//        kMeWEAKSELF
        [MECustomInputView showCustomInputViewWithTitle:@"" content:@"" showChooseBtn:NO isInput:NO saveBlock:^(NSString * str, BOOL isShow) {
//            kMeSTRONGSELF
            habitsModel.habit = [NSString stringWithFormat:@"%@  %@",habitsModel.habit,str];
            [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } cancelBlock:^{
        } superView:kMeCurrentWindow];
    }else {
        habitsModel.isSelected = !habitsModel.isSelected;
    }
    [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseOptionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class])];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn setBackgroundColor:kMEPink];
        _bottomBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        _bottomBtn.layer.cornerRadius = 20.0;
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UIButton *)saveBtn{
    if(!_saveBtn){
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:kMEPink];
        _saveBtn.cornerRadius = 12;
        _saveBtn.clipsToBounds = YES;
        _saveBtn.frame = CGRectMake(0, 0, 65, 25);
        _saveBtn.titleLabel.font = kMeFont(15);
        [_saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

@end
