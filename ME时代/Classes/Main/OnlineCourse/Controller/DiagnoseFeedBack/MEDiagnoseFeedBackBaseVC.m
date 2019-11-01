//
//  MEDiagnoseFeedBackBaseVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseFeedBackBaseVC.h"
#import "MEDiagnoseConsultModel.h"
#import "MEDiagnoseReportModel.h"
#import "MEDiagnoseListCell.h"

#import "MEDiagnoseConsultDetailVC.h"
#import "MEDiagnoseReportVC.h"

@interface MEDiagnoseFeedBackBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MEDiagnoseFeedBackBaseVC

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{
             @"token":kMeUnNilStr(kCurrentUser.token),
             @"type":@(_type)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if (_type == 1) {
        [self.refresh.arrData addObjectsFromArray:[MEDiagnoseConsultModel mj_objectArrayWithKeyValuesArray:data]];
    }else {
        [self.refresh.arrData addObjectsFromArray:[MEDiagnoseReportModel mj_objectArrayWithKeyValuesArray:data]];
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEDiagnoseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseListCell class]) forIndexPath:indexPath];
    if (_type == 1) {
        MEDiagnoseConsultModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithConsultModel:model];
    }else {
        MEDiagnoseReportModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithReportModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 1) {
        MEDiagnoseConsultModel *model = self.refresh.arrData[indexPath.row];
        CGFloat height = [kMeUnNilStr(model.problem) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        return 113-21+height;
    }
    return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 1) {
        MEDiagnoseConsultModel *model = self.refresh.arrData[indexPath.row];
        MEDiagnoseConsultDetailVC *vc = [[MEDiagnoseConsultDetailVC alloc] initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        MEDiagnoseReportModel *model = self.refresh.arrData[indexPath.row];
        MEDiagnoseReportVC *vc = [[MEDiagnoseReportVC alloc] initWithReportId:[NSString stringWithFormat:@"%ld",model.idField]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-20) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonDiagnosisList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关信息";
        }];
    }
    return _refresh;
}

@end
