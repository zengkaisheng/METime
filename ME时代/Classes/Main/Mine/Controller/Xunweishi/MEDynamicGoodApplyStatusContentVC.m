//
//  MEDynamicGoodApplyStatusContentVC.m
//  SunSum
//
//  Created by hank on 2019/3/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEDynamicGoodApplyStatusContentVC.h"
#import "MEDynamicGoodApplyStatusCell.h"
#import "MEDynamicGoodApplyModel.h"
#import "MEDynamicGoodApplyVC.h"

@interface MEDynamicGoodApplyStatusContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEDynamicGoodApplyStatusContentType _type;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEDynamicGoodApplyStatusContentVC

- (instancetype)initWithType:(MEDynamicGoodApplyStatusContentType)type{
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    dic[@"status"] = @(_type).description;
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEDynamicGoodApplyModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEDynamicGoodApplyStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDynamicGoodApplyStatusCell class]) forIndexPath:indexPath];
    MEDynamicGoodApplyModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEDynamicGoodApplyStatusCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEDynamicGoodApplyModel *model = self.refresh.arrData[indexPath.row];
    MEDynamicGoodApplyVC *vc = [[MEDynamicGoodApplyVC alloc]init];
    vc.parModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDynamicGoodApplyStatusCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDynamicGoodApplyStatusCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongXunweishiApplyList)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有申请记录";
        }];
    }
    return _refresh;
}

@end
