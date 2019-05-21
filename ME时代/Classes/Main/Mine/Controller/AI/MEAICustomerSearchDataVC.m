//
//  MEAICustomerSearchDataVC.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAICustomerSearchDataVC.h"
#import "MEAICustomerHomeCell.h"
#import "MEAICustomerHomeModel.h"

@interface MEAICustomerSearchDataVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSString *_key;
    MEAICustomerHomeContentVCType _type;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEAICustomerSearchDataVC

- (instancetype)initWithKey:(NSString *)key type:(MEAICustomerHomeContentVCType)type{
    if(self = [super init]){
        _key = kMeUnNilStr(key);
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"搜索%@",_key];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),@"select":_key};
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
    [cell setSearchUiWithAddModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEAICustomerHomeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MEAIDataHomeTimeModel *model = self.refresh.arrData[indexPath.row];
    
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
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
