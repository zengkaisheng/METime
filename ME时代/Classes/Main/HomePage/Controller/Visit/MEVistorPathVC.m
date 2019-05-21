//
//  MEVistorPathVC.m
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEVistorPathVC.h"
#import "MEVistorPathMainCell.h"
#import "MEVistorPathCell.h"
#import "MEVistorUserModel.h"
#import "MEVistorUserPathModel.h"

@interface MEVistorPathVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEVistorUserModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;


@end

@implementation MEVistorPathVC

- (instancetype)initWithModel:(MEVistorUserModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"传播路径";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    if(_model.type == 1){
        return @{@"token":kMeUnNilStr(kCurrentUser.token),@"share_id":@(_model.share_id)};
    }else{
        return @{@"token":kMeUnNilStr(kCurrentUser.token),@"posters_id":@(_model.article_id)};
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEVistorUserPathModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section){
        return self.refresh.arrData.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section){
        MEVistorUserPathModel *modelu =  self.refresh.arrData[indexPath.row];
        MEVistorPathCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVistorPathCell class]) forIndexPath:indexPath];
        [cell setUiWIthModel:modelu count:indexPath.row];
        return cell;
    }else{
        MEVistorPathMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVistorPathMainCell class]) forIndexPath:indexPath];
        [cell setUiWIthModle:_model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section){
        return kMEVistorPathCellHeight;
    }else{
        return kMEVistorPathMainCellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *arr = @[@"传播页面",@"传播路径"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(11, 0, SCREEN_WIDTH -22, 62)];
    lbl.font = [UIFont systemFontOfSize:21];
    lbl.textColor = [UIColor colorWithHexString:@"090909"];
    lbl.text = arr[section];
    [view addSubview:lbl];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section){

    }
}

#pragma mark - Setter And Getter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVistorPathMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVistorPathMainCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVistorPathCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVistorPathCell class])];
        
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
        NSString *url = _model.type == 1?MEIPcommonGetSpreadPath:MEIPcommonGetPosterSpreadPath;
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(url)];
        _refresh.delegate = self;
        _refresh.showFailView = NO;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];

        }];
    }
    return _refresh;
}



@end
