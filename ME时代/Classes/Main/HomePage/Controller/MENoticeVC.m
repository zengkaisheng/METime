//
//  MENoticeVC.m
//  ME时代
//
//  Created by hank on 2018/11/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENoticeVC.h"
#import "MENoticeCell.h"
#import "MENoticeModel.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEMyOrderDetailVC.h"
#import "MEAppointmentDetailVC.h"
#import "MEArticleDetailVC.h"
#import "MEArticelModel.h"

@interface MENoticeVC ()<RefreshToolDelegate,UITableViewDelegate,UITableViewDataSource>{
//    MEJpushType _type;
//    NSString *_title;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MENoticeVC

//- (instancetype)initWithNoticeType:(MEJpushType)type title:(NSString *)title{
//    if(self = [super init]){
//        _title = title;
//        _type = type;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    // Do any additional setup after loading the view.
}

#pragma mark - Action
- (void)allRead{
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:@"确定全部设为已读"];
    alertView.isSupportRotating = YES;
    [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
    }];
    kMeWEAKSELF
    [alertView addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        kMeSTRONGSELF
        [MEPublicNetWorkTool getUseAllReadedInfoWithType:0 SuccessBlock:^(ZLRequestResponse *responseObject) {
            [strongSelf.refresh reload];
            kNoticeUnNoticeMessage
        } failure:nil];
    }];
    [alertView show];
}

- (NSDictionary *)requestParameter{
//    @"type":@(_type)
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MENoticeModel mj_objectArrayWithKeyValuesArray:data]];
}



#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MENoticeModel *model = self.refresh.arrData[indexPath.row];
    MENoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENoticeCell class])];
    [cell setUIWIthModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMENoticeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MENoticeModel *model = self.refresh.arrData[indexPath.row];
    if(model.is_read==1){
        kMeWEAKSELF
        [MEPublicNetWorkTool getUserReadedNoticeWithNoticeId:model.idField SuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            model.is_read = 2;
            [strongSelf.tableView reloadData];
            kNoticeUnNoticeMessage
        } failure:nil];
    }
    switch (model.type) {
        case MEJpushNoticeType:{
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:[model.ids integerValue]];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MEJpushOrderType:{
            MEMyOrderDetailVC *dvc = [[MEMyOrderDetailVC alloc]initWithOrderGoodsSn:kMeUnNilStr(model.ids)];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MEJpushVersionUpdateType:{
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",kMEAppId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case MEJpushServiceAppointType:{
            MEAppointmentDetailVC *dvc = [[MEAppointmentDetailVC alloc]initWithReserve_sn:kMeUnNilStr(model.ids) userType:MEClientBTypeStyle];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
            
        case MEJpushServiceUrlType:{
            NSString *urlStr = kMeUnNilStr(model.ids);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case MEJpushServiceDynalType:{
//            MEAppointmentDetailVC *dvc = [[MEAppointmentDetailVC alloc]initWithReserve_sn:kMeUnNilStr(model.ids) userType:MEClientBTypeStyle];
//            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MEJpushServiceArticelType:{
            NSString *urlStr = kMeUnNilStr(model.ids);
            MEArticelModel *model = [MEArticelModel new];
            model.article_id = [urlStr integerValue];
            MEArticleDetailVC *vc = [[MEArticleDetailVC alloc]initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEJpushServiceActiveType:{

        }
            break;
        default:
            break;
    }

}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENoticeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENoticeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEfbfbfb;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonNotices)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有通知";
        }];
    }
    return _refresh;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-15, 0, 70, 25);
        [_btnRight setTitle:@"一键已读" forState:UIControlStateNormal];
        _btnRight.titleLabel.font = kMeFont(14);
        [_btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(allRead) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}


@end
