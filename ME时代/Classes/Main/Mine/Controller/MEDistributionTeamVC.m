//
//  MEDistributionTeamVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDistributionTeamVC.h"
#import "MEDistrbutionMyTeamCell.h"
#import "MEDistributionTeamModel.h"
#import "MERCConversationVC.h"

@interface MEDistributionTeamVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEClientTypeStyle _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEDistributionTeamVC

- (instancetype)initWithType:(MEClientTypeStyle)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的团队";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEDistributionTeamModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEDistrbutionMyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDistrbutionMyTeamCell class]) forIndexPath:indexPath];
    MEDistributionTeamModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEDistrbutionMyTeamCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEDistributionTeamModel *model = self.refresh.arrData[indexPath.row];
    TConversationCellData *data = [[TConversationCellData alloc] init];
    data.convId = kMeUnNilStr(model.tls_id);
    data.convType = TConv_Type_C2C;
    data.title = kMeUnNilStr(model.nick_name);;
    MERCConversationVC *chat = [[MERCConversationVC alloc] initWIthconversationData:data];
    //    chat.conversation = data;
    [self.navigationController pushViewController:chat animated:YES];
    
    
    //    MERCConversationVC *conversationVC = [[MERCConversationVC alloc]init];
    //    conversationVC.conversationType = ConversationType_PRIVATE;
    //    conversationVC.targetId = @(model.member_id).description ;//RONGYUNCUSTOMID;
    //    conversationVC.title = kMeUnNilStr(model.nick_name);
    //    if([@(model.member_id).description isEqualToString:kCurrentUser.uid]){
    //        [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self.view];
    //    }else{
    //        [self.navigationController pushViewController:conversationVC animated:YES];
    //    }
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDistrbutionMyTeamCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDistrbutionMyTeamCell class])];
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
        NSString *strAPi = MEIPcommonUserGetAdminTeam;
        if(_type == MEClientTypeClerkStyle || _type==MEClientCTypeStyle){
            strAPi = MEIPcommonUserGetTeam;
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(strAPi)];
        _refresh.isGet = YES;
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有团队";
        }];
    }
    return _refresh;
}


@end
