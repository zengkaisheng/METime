//
//  MEPAVistorVC.m
//  ME时代
//
//  Created by hank on 2019/4/4.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEPAVistorVC.h"
#import "MEPAVistorCell.h"
#import "MEVistorUserModel.h"
#import "MERCConversationVC.h"

@interface MEPAVistorVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEPAVistorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获客图文";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
//    if(self.followUpMember){
//        return @{@"token":kMeUnNilStr(kCurrentUser.token),@"type":@"1",@"uid":@"1"};
//    }else{
      return @{@"token":kMeUnNilStr(kCurrentUser.token)};
//    }
    
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEVistorUserModel mj_objectArrayWithKeyValuesArray:data]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEPAVistorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPAVistorCell class]) forIndexPath:indexPath];
    MEVistorUserModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEPAVistorCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEVistorUserModel *model = self.refresh.arrData[indexPath.row];
    if(model.user == nil){
        [MEShowViewTool showMessage:@"未获取到用户信息" view:self.view];
        return;
    }
    if(kMeUnNilStr(model.tls_id).length == 0){
        [MEShowViewTool showMessage:@"未获取到用户信息" view:self.view];
        return;
    }
    if(kMeUnNilStr(model.user.cellphone).length == 0){
        [MEShowViewTool showMessage:@"未获取到用户信息" view:self.view];
        return;
    }
    MECustomActionSheet *sheet = [[MECustomActionSheet alloc]initWithTitles:@[@"聊天",@"拨打电话"]];
    kMeWEAKSELF
    sheet.blockBtnTapHandle = ^(NSInteger index){
        kMeSTRONGSELF
        if(index){
            //1投票活动2海报3文章4访问店铺
            NSInteger type = 3;
            if(model.type == 2){
                type = 2;
            }
            [MEPublicNetWorkTool postgetIPcommonclerknotFollowUpMemberWithUid:@(model.member_id).description type:type SuccessBlock:nil failure:nil];
            [MECommonTool showWithTellPhone:kMeUnNilStr(model.user.cellphone) inView:strongSelf.view];
        }else{
            if([kMeUnNilStr(model.tls_id) isEqualToString:kCurrentUser.tls_data.tls_id]){
                [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:strongSelf.view];
            }else{
                TConversationCellData *data = [[TConversationCellData alloc] init];
                data.convId = kMeUnNilStr(model.tls_id);
                data.convType = TConv_Type_C2C;
                data.title = kMeUnNilStr(model.user.nick_name);;
                MERCConversationVC *chat = [[MERCConversationVC alloc] initWIthconversationData:data];
                [strongSelf.navigationController pushViewController:chat animated:YES];
            }
        }
    };
    [sheet show];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPAVistorCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPAVistorCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        NSString *apiSTr = kGetApiWithUrl(MEIPcommonGetAccessUser);
//        if(self.followUpMember){
//            apiSTr = kGetApiWithUrl(MEIPcommonaifollowUpMember);
//        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:apiSTr];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有记录";
        }];
    }
    return _refresh;
}

@end
