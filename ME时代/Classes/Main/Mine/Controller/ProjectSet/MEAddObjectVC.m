//
//  MEAddObjectVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddObjectVC.h"
#import "MEProjectSettingListModel.h"
#import "MEAddObjectCell.h"

@interface MEAddObjectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEProjectSettingListModel *model;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation MEAddObjectVC

- (instancetype)initWithModel:(MEProjectSettingListModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.isEdit = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isEdit) {
        self.title = @"项目编辑";
    }else {
        self.title = @"项目设置";
        [self loadAddObjectsDatas];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.tableView];
}

- (void)tapAction {
    [self.view endEditing:YES];
}

- (void)loadAddObjectsDatas {
    self.model = [[MEProjectSettingListModel alloc] init];
    [self.tableView reloadData];
}

#pragma mark -- Networking
- (void)bottomBtnAction {
    if (self.isEdit) {
        [self editObject];
    }else {
        [self addObject];
    }
}

- (void)addObject {
    if (kMeUnNilStr(self.model.object_name).length <= 0) {
        [MECommonTool showMessage:@"请输入项目名称" view:kMeCurrentWindow];
        return;
    }
    if (self.model.money == 0) {
        [MECommonTool showMessage:@"请输入手工费" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddObjectWithObjectName:kMeUnNilStr(self.model.object_name) money:[NSString stringWithFormat:@"%@",@(self.model.money)] SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            [MECommonTool showMessage:@"添加成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
    }];
}

- (void)editObject {
    if (kMeUnNilStr(self.model.object_name).length <= 0) {
        [MECommonTool showMessage:@"请输入项目名称" view:kMeCurrentWindow];
        return;
    }
    if (self.model.money == 0) {
        [MECommonTool showMessage:@"请输入手工费" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditObjectWithObjectId:self.model.idField objectName:kMeUnNilStr(self.model.object_name) money:[NSString stringWithFormat:@"%@",@(self.model.money)] SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            [MECommonTool showMessage:@"修改成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAddObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddObjectCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111;
}


#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-40-30) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddObjectCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddObjectCell class])];
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

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn setBackgroundColor:kMEPink];
        _bottomBtn.frame = CGRectMake(40, SCREEN_HEIGHT-40-15, SCREEN_WIDTH-80, 40);
        _bottomBtn.layer.cornerRadius = 20.0;
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
