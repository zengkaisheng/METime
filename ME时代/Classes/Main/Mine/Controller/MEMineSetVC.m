//
//  MEMineSetVC.m
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineSetVC.h"
#import "MEMineSetCell.h"
#import "MEAboutWeVC.h"
#import "MESelectAddressVC.h"
#import "MEModifyPhoneVC.h"
#import "MECompandNoticeVC.h"

@interface MEMineSetVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrtype;
    BOOL _status;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) UIButton           *btnExit;

@end

@implementation MEMineSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
////        _arrtype = @[@{@"title":@"地址",@"subTitle":@[@{@"title":@"收货地址",@"type":@(MESetAddressStyle)}]},@{@"title":@"账号与安全",@"subTitle":@[@{@"title":@"更换手机号码",@"type":@(MESetPhoneStyle)},@{@"title":@"清理缓存",@"type":@(MESetCLearChacheStyle)}]},@{@"title":@"关于",@"subTitle":@[@{@"title":@"关于我们",@"type":@(MESetAboutWeStyle)}]}];
//    if(kCurrentUser.user_type == 3){
//        _arrtype = @[@{@"title":@"地址",@"subTitle":@[@{@"title":@"收货地址",@"type":@(MESetAddressStyle)}]},@{@"title":@"账号与安全",@"subTitle":@[@{@"title":@"清理缓存",@"type":@(MESetCLearChacheStyle)},@{@"title":@"接收店铺访问通知",@"type":@(MESetNoticeStyle)}]},@{@"title":@"关于",@"subTitle":@[@{@"title":@"关于我们",@"type":@(MESetAboutWeStyle)},@{@"title":@"APP隐私权政策",@"type":@(MESetCompandNoticeStyle)}]}];
//    }else{
       _arrtype = @[@{@"title":@"地址",@"subTitle":@[@{@"title":@"收货地址",@"type":@(MESetAddressStyle)}]},@{@"title":@"账号与安全",@"subTitle":@[@{@"title":@"更换手机号码",@"type":@(MESetPhoneStyle)},@{@"title":@"清理缓存",@"type":@(MESetCLearChacheStyle)}]},@{@"title":@"关于",@"subTitle":@[@{@"title":@"关于我们",@"type":@(MESetAboutWeStyle)},@{@"title":@"APP隐私权政策",@"type":@(MESetCompandNoticeStyle)}]}];
//    }
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnExit];
//    self.tableView.tableFooterView = self.btnExit;
    // Do any additional setup after loading the view.
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrtype.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _arrtype[section];
    NSArray *subTitle = dic[@"subTitle"];
    return subTitle.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMineSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMineSetCell class]) forIndexPath:indexPath];
    NSDictionary *dic = _arrtype[indexPath.section];
    NSArray *subTitle = dic[@"subTitle"];
    NSDictionary *subDic = subTitle[indexPath.row];
    cell.lblTitle.text = kMeUnNilStr(subDic[@"title"]);
//    MESetStyle type = [subDic[@"type"] integerValue];
//    kMeWEAKSELF
//    [cell setType:type status:_status switchBlock:^(BOOL status) {
//        kMeSTRONGSELF
//        strongSelf->_status = status;
//        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEMineSetCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arrtype[indexPath.section];
    NSArray *subTitle = dic[@"subTitle"];
    NSDictionary *subDic = subTitle[indexPath.row];
    MESetStyle type = [subDic[@"type"] integerValue];
    switch (type) {
        case MESetAddressStyle:{
            MESelectAddressVC *address = [[MESelectAddressVC alloc]init];
            [self.navigationController pushViewController:address animated:YES];
        }
            break;
        case MESetCompandNoticeStyle:{
            MECompandNoticeVC *notice = [[MECompandNoticeVC alloc]init];
            [self.navigationController pushViewController:notice animated:YES];
        }
            break;
        case MESetCLearChacheStyle:{
            [MBProgressHUD showMessage:@"正在清除缓存"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                
                NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                for (NSString *p in files) {
                    NSError *error;
                    NSString *path = [cachPath stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if (self) {
                        [MBProgressHUD hideHUD];
                    }
                });
            });
        }
            break;
        case MESetAboutWeStyle:{
            MEAboutWeVC *weVC = [[MEAboutWeVC alloc]init];
            [self.navigationController pushViewController:weVC animated:YES];
        }
            break;
        case MESetPhoneStyle:{
            MEModifyPhoneVC *weVC = [[MEModifyPhoneVC alloc]init];
            [self.navigationController pushViewController:weVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = _arrtype[section];
    NSString *title = dic[@"title"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEMineSetCellHeight)];
    view.backgroundColor =kMEHexColor(@"eeeeee");
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(k15Margin, 0, SCREEN_WIDTH - (k15Margin *2), kMEMineSetCellHeight)];
    lbl.textColor = kMEHexColor(@"9a9a9a");
    lbl.text = kMeUnNilStr(title);
    lbl.backgroundColor = kMEHexColor(@"eeeeee");;
    [view addSubview:lbl];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kMEMineSetCellHeight;
}

- (void)exitAction:(UIButton *)btn{
    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定退出吗?"];
    [aler addButtonWithTitle:@"取消"];
    kMeWEAKSELF
    [aler addButtonWithTitle:@"确定" block:^{
        kMeSTRONGSELF
        [MEUserInfoModel logout];
        [strongSelf.navigationController popViewControllerAnimated:NO];
        kMeCallBlock(strongSelf.exitBlock);
    }];
    [aler show];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-49) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMineSetCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMineSetCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEHexColor(@"eeeeee");
    }
    return _tableView;
}

- (UIButton *)btnExit{
    if(!_btnExit){
        _btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnExit.frame = CGRectMake(0, self.view.height - 49, SCREEN_WIDTH, 49);
        _btnExit.backgroundColor = [UIColor whiteColor];
        [_btnExit setTitle:@"退出" forState:UIControlStateNormal];
        [_btnExit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnExit addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnExit;
}

@end
