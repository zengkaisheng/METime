//
//  MEAICustomerHomeContentVC.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAICustomerHomeContentVC.h"
#import "MEAICustomerHomeCell.h"
#import "MEAICustomerHomeModel.h"
#import "MEAICustomerHomeHeaderSearchView.h"
#import "MEAiCustomerDetailVC.h"

@interface MEAICustomerHomeContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEAICustomerHomeContentVCType _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEAICustomerHomeContentVC

- (instancetype)initWithType:(MEAICustomerHomeContentVCType)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEAICustomerHomeModel mj_objectArrayWithKeyValuesArray:data]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAICustomerHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAICustomerHomeCell class]) forIndexPath:indexPath];
    MEAICustomerHomeModel *model = self.refresh.arrData[indexPath.row];
    [cell setUiWithAddModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEAICustomerHomeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAICustomerHomeModel *model = self.refresh.arrData[indexPath.row];
    MEAiCustomerDetailVC *vc = [[MEAiCustomerDetailVC alloc]initWithUserId:kMeUnNilStr(model.uid)];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return k10Margin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, k10Margin)];
    view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    return view;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight-kMEAICustomerHomeHeaderSearchViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAICustomerHomeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAICustomerHomeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =[UIColor colorWithHexString:@"f4f4f4"];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        NSString *staApi = @"";
        switch (_type) {
            case MEAICustomerHomeContentVCAddType:
                staApi = kGetApiWithUrl(MEIPcommonaigetjoinTime);
                break;
            case MEAICustomerHomeContentVCFollowType:
                staApi = kGetApiWithUrl(MEIPcommonaigetupdateFollow);
                break;
            case MEAICustomerHomeContentVCActiveType:
                staApi = kGetApiWithUrl(MEIPcommonaigetactive);
                break;
            default:
                break;
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:staApi];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有客户";
            failView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        }];
    }
    return _refresh;
}

@end

