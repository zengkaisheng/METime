//
//  MEAppointmentCustomerListVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAppointmentCustomerListVC.h"
#import "MEFourSearchCouponNavView.h"
#import "MECustomerFileListModel.h"
#import "MEAppointmentObjectModel.h"
#import "MEAddAppointmentVC.h"

@interface MEAppointmentCustomerListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) MEFourSearchCouponNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation MEAppointmentCustomerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isFileList) {
        self.navBarHidden = YES;
        [self.view addSubview:self.navView];
        self.searchStr = @"";
        [self.refresh addRefreshView];
    }else {
        self.navBarHidden = NO;
        self.title = @"预约项目";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
        [self getObjectList];
    }
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- Action
- (void)addBtnAction {
    MEAddAppointmentVC *addVC = [[MEAddAppointmentVC alloc] init];
    addVC.isAddProject = YES;
    kMeWEAKSELF
    addVC.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf getObjectList];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"classify_id":@(0),
             @"search":self.searchStr
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECustomerFileListModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)getObjectList {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetAppointmentObjectListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSArray class]]){
            strongSelf.refresh.arrData = [MEAppointmentObjectModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else {
            strongSelf.refresh.arrData = [[NSMutableArray alloc] init];
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.refresh.arrData = [[NSMutableArray alloc] init];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.isFileList) {
        MECustomerFileListModel *model = self.refresh.arrData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@",kMeUnNilStr(model.name),kMeUnNilStr(model.phone)];
    }else {
        MEAppointmentObjectModel *model = self.refresh.arrData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.object_name)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFileList) {
        MECustomerFileListModel *model = self.refresh.arrData[indexPath.row];
        kMeCallBlock(self.chooseBlock,kMeUnNilStr(model.name),model.idField);
    }else {
        MEAppointmentObjectModel *model = self.refresh.arrData[indexPath.row];
        kMeCallBlock(self.chooseBlock,kMeUnNilStr(model.object_name),model.idField);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma setter&&getter
- (MEFourSearchCouponNavView *)navView{
    if(!_navView){
        _navView = [[MEFourSearchCouponNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight)];
        _navView.searchTF.placeholder = @"搜索";
        kMeWEAKSELF
        _navView.searchBlock = ^(NSString *str) {
            kMeSTRONGSELF
            strongSelf.searchStr = str;
            [strongSelf.refresh reload];
        };
        _navView.backBlock = ^{
            kMeSTRONGSELF
            [strongSelf.view endEditing:YES];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navView;
}

- (UIButton *)addBtn{
    if(!_addBtn){
        _addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:kMEPink];
        _addBtn.cornerRadius = 12;
        _addBtn.clipsToBounds = YES;
        _addBtn.frame = CGRectMake(0, 0, 65, 25);
        _addBtn.titleLabel.font = kMeFont(15);
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerFilesList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无顾客信息";
        }];
    }
    return _refresh;
}

@end
