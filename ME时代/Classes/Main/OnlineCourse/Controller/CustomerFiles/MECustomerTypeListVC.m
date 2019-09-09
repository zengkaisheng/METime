//
//  MECustomerTypeListVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerTypeListVC.h"
#import "MECustomerClassifyListModel.h"
#import "MECustomerTypeCell.h"
#import "MECustomInputView.h"
#import "MELivingHabitListModel.h"
#import "MEDiagnoseQuestionHeaderView.h"

@interface MECustomerTypeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MELivingHabitListModel *model;
@property (nonatomic, assign) BOOL isHabit;
@property (nonatomic, assign) BOOL isChooseMore;

@end

@implementation MECustomerTypeListVC

- (instancetype)initWithHabitModel:(MELivingHabitListModel *)model {
    if (self = [super init]) {
        self.isHabit = YES;
        self.model = model;
        [self.dataSource addObjectsFromArray:model.habit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isHabit) {
        self.title = @"生活习惯信息";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        [self.footerView addSubview:self.chooseBtn];
        self.addBtn.frame = CGRectMake(80, 15, SCREEN_WIDTH-90, 40);
    }else {
        self.title = @"顾客分类";
        [self getCustomerClassifyListWithNetworking];
    }
    
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
}

#pragma mark ---- Networking
//顾客分类
- (void)getCustomerClassifyListWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerClassifyListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.dataSource = [MECustomerClassifyListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//删除顾客分类
- (void)deleteCustomerClassifyWithClassifyId:(NSInteger)classifyId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postDeleteCustomerClassifyWithClassifyId:classifyId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        for (MECustomerClassifyListModel *model in strongSelf.dataSource) {
            if (model.idField == classifyId) {
                [strongSelf.dataSource removeObject:model];
                kNoticeReloadFilesList
                [strongSelf.tableView reloadData];
                return;
            }
        }
    } failure:^(id object) {
    }];
}
//添加顾客分类
- (void)addCustomerClassifyWithClassifyName:(NSString *)classifyName {
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddCustomerClassifyWithClassifyName:classifyName successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MECustomerClassifyListModel *model = [MECustomerClassifyListModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf.dataSource addObject:model];
        kNoticeReloadFilesList
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

//添加生活习惯
- (void)addLivingHabitWithHabitName:(NSString *)HabitName {
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddLivingHabitWithClassifyId:[NSString stringWithFormat:@"%@",@(self.model.idField)] habit:HabitName habitType:[NSString stringWithFormat:@"%@",@(self.model.type)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            MELivingHabitsOptionModel *model = [MELivingHabitsOptionModel mj_objectWithKeyValues:responseObject.data];
            [strongSelf.dataSource addObject:model];
            NSMutableArray *habit = [NSMutableArray arrayWithArray:strongSelf.model.habit];
            [habit addObject:model];
            strongSelf.model.habit = [habit copy];
        }
        [strongSelf.tableView reloadData];
        kMeCallBlock(self.contentBlock,strongSelf.model);
    } failure:^(id object) {
    }];
}
//修改生活习惯
- (void)editLivingHabitWithHabitName:(NSString *)habitName model:(MELivingHabitsOptionModel *)model index:(NSInteger)index {
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditLivingHabitWithClassifyId:[NSString stringWithFormat:@"%@",@(model.classify_id)] habitId:[NSString stringWithFormat:@"%@",@(model.idField)] habit:habitName habitType:[NSString stringWithFormat:@"%@",@(model.habit_type)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        
        model.habit = habitName;
        for (MELivingHabitsOptionModel *optionModel in strongSelf.model.habit) {
            if (optionModel.idField == model.idField) {
                optionModel.habit = habitName;
            }
        }
        kMeCallBlock(self.contentBlock,strongSelf.model);
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}
//删除生活习惯
- (void)deleteLivingHabitWithHabitId:(NSString *)HabitId index:(NSInteger)index{
    kMeWEAKSELF
    [MEPublicNetWorkTool postDeleteLivingHabitWithHabitId:HabitId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"删除成功" view:kMeCurrentWindow];
        [strongSelf.dataSource removeObjectAtIndex:index];
        NSMutableArray *habit = [NSMutableArray arrayWithArray:strongSelf.model.habit];
        [habit removeObjectAtIndex:index];
        strongSelf.model.habit = [habit copy];
        [strongSelf.tableView reloadData];
        kMeCallBlock(self.contentBlock,strongSelf.model);
    } failure:^(id object) {
    }];
}
//修改生活习惯分类
- (void)editLivingHabitClassifyTitle:(NSString *)classiftTitle type:(NSInteger)type {
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditLivingHabitClassifyNameWithClassifyId:[NSString stringWithFormat:@"%@",@(self.model.idField)] classifyTitle:classiftTitle type:type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = (NSDictionary *)responseObject.data;
            strongSelf.model.classify_title = info[@"classify_title"];
            strongSelf.model.type = [info[@"type"] integerValue];
            strongSelf.chooseBtn.selected = strongSelf.model.type==0?YES:NO;
            [MECommonTool showMessage:@"保存成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
                kMeCallBlock(strongSelf.contentBlock,strongSelf.model);
            });
        }
    } failure:^(id object) {
    }];
}
//删除生活习惯分类
- (void)deleteLivingHabitClassifyWithClassifyId:(NSString *)classifyId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postDeleteCustomerLivingHabitClassifyWithClassifyId:classifyId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data intValue] == 1) {
            [MECommonTool showMessage:@"删除成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
                kMeCallBlock(self.deleteBlock);
            });
        }
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerTypeCell class]) forIndexPath:indexPath];
    
    if (self.isHabit) {
        MELivingHabitsOptionModel *model = self.dataSource[indexPath.row];
        [cell setUIWithTitle:kMeUnNilStr(model.habit)];
        kMeWEAKSELF
        cell.deleteBlock = ^{
            kMeSTRONGSELF
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf deleteLivingHabitWithHabitId:[NSString stringWithFormat:@"%@",@(model.idField)] index:indexPath.row];
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定要删除 %@ 吗？",kMeUnNilStr(model.habit)] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            [strongSelf presentViewController:alertController animated:YES completion:nil];
        };
    }else {
        MECustomerClassifyListModel *model = self.dataSource[indexPath.row];
        [cell setUIWithTitle:kMeUnNilStr(model.classify_name)];
        kMeWEAKSELF
        cell.deleteBlock = ^{
            kMeSTRONGSELF
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf deleteCustomerClassifyWithClassifyId:model.idField];
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定要删除 %@ 吗？",kMeUnNilStr(model.classify_name)] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            [strongSelf presentViewController:alertController animated:YES completion:nil];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isHabit) {
        MELivingHabitsOptionModel *model = self.dataSource[indexPath.row];
        kMeWEAKSELF
        [MECustomInputView showCustomInputViewWithTitle:kMeUnNilStr(self.model.classify_title) content:kMeUnNilStr(model.habit) showChooseBtn:YES isInput:YES saveBlock:^(NSString * str, BOOL isShow) {
            kMeSTRONGSELF
            model.habit_type = isShow?1:0;
            [strongSelf editLivingHabitWithHabitName:str model:model index:indexPath.row];
        } cancelBlock:^{
        } superView:kMeCurrentWindow];
    }else {
        MECustomerClassifyListModel *model = self.dataSource[indexPath.row];
        kMeCallBlock(self.contentBlock,model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isHabit) {
        return 49;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [headerView setUIWithSectionTitle:kMeUnNilStr(self.model.classify_title) isAdd:NO];
    kMeWEAKSELF
    headerView.tapBlock = ^(BOOL isTap) {
        kMeSTRONGSELF
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MECustomInputView showCustomInputViewWithTitle:@"修改" content:kMeUnNilStr(strongSelf.model.classify_title) showChooseBtn:YES isInput:NO saveBlock:^(NSString * str, BOOL isShow) {
                [strongSelf editLivingHabitClassifyTitle:str type:isShow?0:1];
            } cancelBlock:^{
            } superView:kMeCurrentWindow];
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [strongSelf deleteLivingHabitClassifyWithClassifyId:[NSString stringWithFormat:@"%@",@(strongSelf.model.idField)]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑生活习惯" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:editAction];
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        [strongSelf presentViewController:alertController animated:YES completion:nil];
    };
    return headerView;
}

#pragma mark -- Action
- (void)addBtnAction {
    kMeWEAKSELF
    if (self.isHabit) {
        [MECustomInputView showCustomInputViewWithTitle:kMeUnNilStr(self.model.classify_title) content:@"" showChooseBtn:NO isInput:NO saveBlock:^(NSString * str, BOOL isShow) {
            kMeSTRONGSELF
            [strongSelf addLivingHabitWithHabitName:str];
        } cancelBlock:^{
        } superView:kMeCurrentWindow];
    }else {
        [MECustomInputView showCustomInputViewWithTitle:@"添加顾客分类" content:@"" showChooseBtn:NO isInput:NO saveBlock:^(NSString * str, BOOL isShow) {
            kMeSTRONGSELF
            [strongSelf addCustomerClassifyWithClassifyName:str];
        } cancelBlock:^{
        } superView:kMeCurrentWindow];
    }
    
}
//生活习惯保存
- (void)rightBtnAction {
    [self editLivingHabitClassifyTitle:kMeUnNilStr(self.model.classify_title) type:self.chooseBtn.selected?0:1];
}

- (void)btnDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isChooseMore = sender.selected;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-80) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerTypeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerTypeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
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
        [_footerView addSubview:self.addBtn];
    }
    return _footerView;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_addBtn setBackgroundColor:kMEPink];
        _addBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        _addBtn.layer.cornerRadius = 20.0;
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:kMEPink];
        _rightBtn.cornerRadius = 12;
        _rightBtn.clipsToBounds = YES;
        _rightBtn.frame = CGRectMake(0, 0, 65, 25);
        _rightBtn.titleLabel.font = kMeFont(15);
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setTitle:@"是否多选" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:[UIColor colorWithHexString:@"#393939"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_delCollection_nor"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_delCollection_sel"] forState:UIControlStateSelected];
        _chooseBtn.selected = self.model.type==0?YES:NO;
        [_chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _chooseBtn.frame = CGRectMake(10, 15, 60, 40);
        [_chooseBtn setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:2];
        [_chooseBtn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

@end
