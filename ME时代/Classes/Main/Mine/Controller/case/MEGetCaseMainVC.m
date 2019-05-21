//
//  MEGetCaseMainVC.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGetCaseMainVC.h"
#import "MEGetCaseMainCell.h"
#import "MEGetCaseContentVC.h"
#import "MEGetCaseMainModel.h"

@interface MEGetCaseMainVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    MEGetCaseStyle _type;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;


@end

@implementation MEGetCaseMainVC

- (instancetype)initWithType:(MEGetCaseStyle)type{
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

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    switch (_type) {
        case MEGetCaseAllStyle:{
            
        }
            break;
        case MEGetCaseingStyle:
        {
            dic[@"state"] = @"1";
        }
            break;
        case MEGetCaseedStyle:
        {
            dic[@"state"] = @"2";
        }
            break;
        case MEGetCasenotStyle:
        {
            dic[@"state"] = @"-1";
        }
            break;
        case MEGetCasePayEdStyle:
        {
            dic[@"state"] = @"3";
        }
            break;
        default:
            break;
    }
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEGetCaseMainModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGetCaseMainModel *model = self.refresh.arrData[indexPath.row];
    MEGetCaseMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGetCaseMainCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGetCaseMainModel *model = self.refresh.arrData[indexPath.row];
    return [MEGetCaseMainCell getCellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGetCaseMainModel *model = self.refresh.arrData[indexPath.row];
    MEGetCaseContentVC *vc = [[MEGetCaseContentVC alloc]initWithMoney_check_sn:kMeUnNilStr(model.order_sn)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGetCaseMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGetCaseMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view.backgroundColor = [UIColor colorWithHexString:@"f1f2f6"];
        _tableView.tableFooterView = view;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f2f6"];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommondestoonFinanceCashListh)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有提现";
        }];
    }
    return _refresh;
}
@end
