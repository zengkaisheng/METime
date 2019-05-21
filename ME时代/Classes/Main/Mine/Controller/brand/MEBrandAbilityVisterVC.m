//
//  MEBrandAbilityVisterVC.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAbilityVisterVC.h"
#import "MEBrandAbilityVisterCell.h"
#import "MEBrandAbilityManngerVC.h"
#import "MEBrandAbilityVisterModel.h"
#import "MEBrandAISortModel.h"


@interface MEBrandAbilityVisterVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>
{
    MEBrandAISortModel *_sortModel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEBrandAbilityVisterVC

- (instancetype)initWithModel:(MEBrandAISortModel *)model{
    if(self = [super init]){
        _sortModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"store_id":kMeUnNilStr(_sortModel.store_id)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEBrandAbilityVisterModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEBrandAbilityVisterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandAbilityVisterCell class]) forIndexPath:indexPath];
    MEBrandAbilityVisterModel *model = self.refresh.arrData[indexPath.row];
    [cell setUiWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEBrandAbilityVisterCellHeight;
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandAbilityManngerVCHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBrandAbilityVisterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBrandAbilityVisterCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongStoreAccessCount)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有店铺";
        }];
    }
    return _refresh;
}


@end
