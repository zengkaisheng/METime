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

@interface MECustomerTypeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MECustomerTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客分类";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    [self getCustomerClassifyListWithNetworking];
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
                return;
            }
        }
        [strongSelf.tableView reloadData];
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
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerTypeCell class]) forIndexPath:indexPath];
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [strongSelf presentViewController:alertController animated:YES completion:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerClassifyListModel *model = self.dataSource[indexPath.row];
    kMeCallBlock(self.contentBlock,model);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- Action
- (void)addBtnAction {
    kMeWEAKSELF
    [MECustomInputView showCustomInputViewWithTitle:@"" saveBlock:^(NSString *str) {
        kMeSTRONGSELF
        [strongSelf addCustomerClassifyWithClassifyName:str];
    } cancelBlock:^{
        
    } superView:kMeCurrentWindow];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-80) style:UITableViewStylePlain];
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

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_addBtn setBackgroundColor:kMEPink];
        _addBtn.frame = CGRectMake(48, SCREEN_HEIGHT - 55, SCREEN_WIDTH-96, 40);
        _addBtn.layer.cornerRadius = 20.0;
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
