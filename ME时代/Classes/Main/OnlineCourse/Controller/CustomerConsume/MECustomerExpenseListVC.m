//
//  MECustomerExpenseListVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerExpenseListVC.h"
#import "MECustomerExpenseDetailModel.h"
#import "MEServiceCardCell.h"
#import "MEAddExpenseVC.h"

@interface MECustomerExpenseListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSInteger _filesId;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MECustomerExpenseListVC

- (instancetype)initWithType:(NSInteger)type filesId:(NSInteger)filesId{
    if (self = [super init]) {
        _type = type;
        _filesId = filesId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (_type) {
        case 4:
            self.title = @"会员充值";
            break;
        case 1:
            self.title = @"次卡项目";
            break;
        case 2:
            self.title = @"时间卡项目";
            break;
        case 3:
            self.title = @"产品";
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"customer_files_id":@(_filesId),
             @"type":@(_type)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEExpenseDetailSubModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEServiceCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEServiceCardCell class]) forIndexPath:indexPath];
    MEExpenseDetailSubModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithExpenseModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEExpenseDetailSubModel *model = self.refresh.arrData[indexPath.row];
    if (model.type == 4) {
        return 82;
    }
    return kMEServiceCardCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEExpenseDetailSubModel *model = self.refresh.arrData[indexPath.row];
    NSDictionary *info = @{@"title":self.title,@"type":@(_type),@"content":@[model]};
    MEAddExpenseVC *vc = [[MEAddExpenseVC alloc] initWithInfo:info filesId:model.idField];
    vc.isEdit = YES;
    kMeWEAKSELF
    vc.finishBlock = ^(id object) {
        kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEServiceCardCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEServiceCardCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerExpenseExpenseList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关消费记录";
        }];
    }
    return _refresh;
}

@end
