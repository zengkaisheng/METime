//
//  MEProjectSettingVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEProjectSettingVC.h"
#import "MEProjectSettingListModel.h"
#import "MEProjectSettingListCell.h"
#import "MEAddObjectVC.h"

@interface MEProjectSettingVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation MEProjectSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目设置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEProjectSettingListModel mj_objectArrayWithKeyValuesArray:data]];
    [self getProjectSettingDatas];
}

#pragma mark -- Networking
- (void)getProjectSettingDatas {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetObjectListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            if (self.refresh.arrData.count > 0) {
                [self.refresh.arrData removeAllObjects];
            }
            [self.refresh.arrData addObjectsFromArray:[MEProjectSettingListModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)deleteProjectSettingDatasWithObjectId:(NSInteger)objectId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postDeleteObjectsWithObjectId:objectId SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"删除成功" view:kMeCurrentWindow];
        [strongSelf.refresh reload];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -- Action
- (void)addBtnAction {
    MEAddObjectVC *vc = [[MEAddObjectVC alloc] init];
    kMeWEAKSELF
    vc.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editObjectWithModel:(MEProjectSettingListModel *)model; {
    MEAddObjectVC *vc = [[MEAddObjectVC alloc] initWithModel:model];
    kMeWEAKSELF
    vc.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEProjectSettingListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEProjectSettingListCell class]) forIndexPath:indexPath];
    MEProjectSettingListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 0) {//编辑
            [strongSelf editObjectWithModel:model];
        }else if (index == 1) {//删除
            [strongSelf deleteProjectSettingDatasWithObjectId:model.idField];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEProjectSettingListModel *model = self.refresh.arrData[indexPath.row];
    kMeCallBlock(self.chooseBlock,@{@"name":kMeUnNilStr(model.object_name),@"id":@(model.idField),@"money":@(model.money)});
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProjectSettingListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEProjectSettingListCell class])];
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

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerObjectList)];
        _refresh.delegate = self;
        _refresh.isDataInside = NO;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关数据";
        }];
    }
    return _refresh;
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

@end
