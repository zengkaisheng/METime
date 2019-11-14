//
//  MEEditMyInfoVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEditMyInfoVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MEMyInfoListCell.h"

@interface MEEditMyInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEAddCustomerInfoModel *model;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation MEEditMyInfoVC

- (instancetype)initWithModel:(MEAddCustomerInfoModel *)model {
    if (self = [super init]) {
        self.model = [MEAddCustomerInfoModel mj_objectWithKeyValues:model.mj_keyValues];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"修改%@",self.model.title];
    self.model.isTextField = YES;
    self.model.isHideArrow = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark -- action
- (void)editBtnAction {
    if ([self.model.title isEqualToString:@"昵称"]) {
        [self editNickNameWithNetWork];
    }else if ([self.model.title isEqualToString:@"公益签名"]) {
        [self editSignatureWithNetWork];
    }
}

- (void)cancelEdit {
    [self.view endEditing:YES];
}

#pragma mark -- Networking
//修改昵称
- (void)editNickNameWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditNickNameWithNickName:kMeUnNilStr(self.model.value) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code integerValue] == 200) {
            [MECommonTool showMessage:@"修改成功" view:strongSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kMeCallBlock(strongSelf.finishBlock);
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
        
    }];
}

//修改签名
- (void)editSignatureWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditSignatureWithSignature:kMeUnNilStr(self.model.value) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code integerValue] == 200) {
            [MECommonTool showMessage:@"修改成功" view:strongSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kMeCallBlock(strongSelf.finishBlock);
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
    MEMyInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyInfoListCell class]) forIndexPath:indexPath];
    [cell setUIWithCustomerModel:self.model];
    kMeWEAKSELF
    cell.textBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.value = str;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}


#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+6, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-6) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyInfoListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyInfoListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 50, SCREEN_WIDTH-50, 50)];
        editBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [editBtn setTitle:@"修改" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        editBtn.layer.cornerRadius = 4;
        
        [editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:editBtn];
    }
    return _footerView;
}


@end
