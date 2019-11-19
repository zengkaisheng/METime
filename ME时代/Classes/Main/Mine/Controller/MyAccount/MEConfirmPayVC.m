//
//  MEConfirmPayVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEConfirmPayVC.h"
#import "MEPersionalCourseDetailModel.h"
#import "MEconfirmPayCell.h"
#import "MEMyAccountModel.h"
#import "MEInputPayPasswordView.h"
#import "MESetPayPasswordVC.h"
#import "MEChangePayPasswordVC.h"
#import "METopUpVC.h"

@interface MEConfirmPayVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MEPersionalCourseDetailModel *model;
@property (nonatomic, strong) MEMyAccountModel *accountModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSString *orderSn;
@property (nonatomic, strong) NSString *password;

@end

@implementation MEConfirmPayVC

- (instancetype)initWithModel:(MEPersionalCourseDetailModel *)model {
    if(self = [super init]){
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认支付";
    [self.view addSubview:self.tableView];
    self.orderSn = @"";
    self.password = @"";
    self.tableView.tableFooterView = self.footerView;
    
    [self requestMyAccountWithNetWork];
}

#pragma mark -- Networking
//资金明细
- (void)requestMyAccountWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetMyAccountWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.accountModel = [MEMyAccountModel mj_objectWithKeyValues:responseObject.data];
            kCurrentUser.is_set_pay_pass = strongSelf.accountModel.is_set;
        }else {
            strongSelf.accountModel = nil;
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

//生成订单
- (void)createOrderWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postCreateOrderWithCourseId:[NSString stringWithFormat:@"%ld",(long)self.model.idField] orderType:@"6" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.orderSn = responseObject.data[@"order_sn"];
        
        [strongSelf buyCourseWithNetWork];
    } failure:^(id object) {
        
    }];
}

//余额支付
- (void)buyCourseWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postBuyCourseWithOrderSn:kMeUnNilStr(self.orderSn) type:@"1" password:kMeUnNilStr(self.password) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code integerValue] == 200) {
            [MECommonTool showMessage:@"购买成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kMeCallBlock(strongSelf.successBlock);
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
    }];
}

#pragma mark -- action
- (void)payBtnAction {
    if ([self.model.price floatValue] > [self.accountModel.money floatValue]) {
        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"您的账户余额不足"];
        kMeWEAKSELF
        [aler addButtonWithTitle:@"取消"];
        [aler addButtonWithTitle:@"立即充值" block:^{
            kMeSTRONGSELF
            METopUpVC *vc = [[METopUpVC alloc] init];
            vc.finishBlock = ^{
                [strongSelf requestMyAccountWithNetWork];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }];
        [aler show];
    }else {
        if (kCurrentUser.is_set_pay_pass == 1) {
            kMeWEAKSELF
            [MEInputPayPasswordView showInputPayPasswordViewWithTitle:@"课程购买" money:kMeUnNilStr(self.model.price) confirmBlock:^(NSString *str) {
                NSLog(@"密码%@",str);
                kMeSTRONGSELF
                strongSelf.password = kMeUnNilStr(str);
                [strongSelf createOrderWithNetWork];
            } forgetBlock:^{
                kMeSTRONGSELF
                MEChangePayPasswordVC *vc = [[MEChangePayPasswordVC alloc] init];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            } cancelBlock:^{
                NSLog(@"取消");
            } superView:kMeCurrentWindow];
        }else {//未设置支付密码
            MESetPayPasswordVC *vc = [[MESetPayPasswordVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEconfirmPayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEconfirmPayCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setFirstCellUIWithHeaderPic:kMeUnNilStr(self.model.courses_images) title:kMeUnNilStr(self.model.name)];
    }else if (indexPath.row == 1) {
        [cell setSecondCellUIWithMoney:kMeUnNilStr(self.model.price)];
    }else if (indexPath.row == 2) {
        [cell setThirdCellUIWithAccount:kMeUnNilStr(self.accountModel.money)];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 78;
    }
    return 55;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEconfirmPayCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEconfirmPayCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 16, SCREEN_WIDTH-30, 42)];
        payBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        payBtn.layer.cornerRadius = 14;
        
        [payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:payBtn];
    }
    return _footerView;
}

@end
