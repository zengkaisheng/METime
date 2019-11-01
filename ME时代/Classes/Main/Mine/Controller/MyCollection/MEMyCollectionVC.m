//
//  MEMyCollectionVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyCollectionVC.h"
#import "MEOnlineCourseListCell.h"
#import "MECourseDetailVC.h"
#import "MEMyCollectionModel.h"
#import "MEPersionalCourseDetailVC.h"

@interface MEMyCollectionVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MEMyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden = YES;
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
    [self.refresh.arrData addObjectsFromArray:[MEMyCollectionModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
    MEMyCollectionModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithCollectionModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEOnlineCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMyCollectionModel *model = self.refresh.arrData[indexPath.row];
    if (model.isEdit) {
        model.isSelected = !model.isSelected;
        [self reloadDeleteBtn];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        if (model.c_type == 3) {
            MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.idField];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.c_id type:model.c_type-1];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -- Action
- (void)editBtnAction {
    self.editBtn.selected = !self.editBtn.selected;
    self.chooseBtn.selected = NO;
    self.deleteBtn.selected = NO;
    if (self.editBtn.selected) {
        self.bottomView.hidden = NO;
        self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-50);
        [self reloadDatasWithIsEdit:YES];
    }else {
        self.bottomView.hidden = YES;
        self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
        [self reloadDatasWithIsEdit:NO];
    }
    [self.tableView reloadData];
}

- (void)reloadDatasWithIsEdit:(BOOL)isEdit {
    for (MEMyCollectionModel *model in self.refresh.arrData) {
        model.isEdit = isEdit;
        model.isSelected = NO;
    }
}

- (void)chooseBtnAction {
    self.chooseBtn.selected = !self.chooseBtn.selected;
    for (MEMyCollectionModel *model in self.refresh.arrData) {
        model.isSelected = self.chooseBtn.selected;
    }
    self.deleteBtn.selected = self.chooseBtn.selected;
    if (self.chooseBtn.selected) {
        self.deleteBtn.selected = YES;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.refresh.arrData.count] forState:UIControlStateSelected];
    }
    [self.tableView reloadData];
}

- (void)reloadDeleteBtn {
    NSInteger count = 0;
    for (MEMyCollectionModel *model in self.refresh.arrData) {
        if (model.isSelected) {
            count++;
        }
    }
    if (count == 0) {
        self.deleteBtn.selected = NO;
        self.chooseBtn.selected = NO;
    }else {
        self.deleteBtn.selected = YES;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",count] forState:UIControlStateSelected];
        if (count == self.refresh.arrData.count) {
            self.chooseBtn.selected = YES;
        }else {
            self.chooseBtn.selected = NO;
        }
    }
}

- (void)deleteBtnAction {
    NSMutableString *ids = [[NSMutableString alloc] init];
    for (MEMyCollectionModel *model in self.refresh.arrData) {
        if (model.isSelected) {
            [ids appendFormat:@"%ld,",model.idField];
        }
    }
    NSString *idString = [ids substringWithRange:NSMakeRange(0, ids.length-1)];
    if (idString.length <= 0) {
        [MECommonTool showMessage:@"请至少选择一个要删除的收藏" view:kMeCurrentWindow];
        return;
    }
    
    [self cancelCollectionWithIds:idString];
}
#pragma mark -- Networking
- (void)cancelCollectionWithIds:(NSString *)ids {
    kMeWEAKSELF
    [MEPublicNetWorkTool postCancelCollectionWithCollectionId:ids SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MEShowViewTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
        NSArray *array = [ids componentsSeparatedByString:@","];
        NSArray *tempArr = [strongSelf.refresh.arrData copy];
        for (int i = 0; i < array.count; i++) {
            for (int j = 0; j < tempArr.count; j++) {
                MEMyCollectionModel *model = tempArr[j];
                if (model.idField == [array[i] integerValue]) {
                    [strongSelf.refresh.arrData removeObject:model];
                }
            }
        }
        [strongSelf.tableView reloadData];
        [strongSelf reloadDeleteBtn];
    } failure:^(id object) {
        
    }];
}

#pragma setter&&getter
- (UIButton *)editBtn{
    if(!_editBtn){
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitle:@"取消" forState:UIControlStateSelected];
        [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _editBtn.frame = CGRectMake(0, 0, 44, 44);
        _editBtn.titleLabel.font = kMeFont(16);
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_chooseBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _chooseBtn.frame = CGRectMake(0, 0, (SCREEN_WIDTH-1)/2, 50);
        _chooseBtn.titleLabel.font = kMeFont(16);
        [_chooseBtn addTarget:self action:@selector(chooseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#ACACAC"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateSelected];
        [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#FB7D00"] forState:UIControlStateSelected];
        _deleteBtn.frame = CGRectMake((SCREEN_WIDTH-1)/2+1, 0, (SCREEN_WIDTH-1)/2, 50);
        _deleteBtn.titleLabel.font = kMeFont(16);
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.chooseBtn];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-1)/2, 6, 1, 34)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#707070"];
        [_bottomView addSubview:line1];
        [_bottomView addSubview:self.deleteBtn];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#707070"];
        [_bottomView addSubview:line2];
    }
    return _bottomView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineCourseListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonOnlineCollectionList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无收藏";
        }];
    }
    return _refresh;
}

@end
