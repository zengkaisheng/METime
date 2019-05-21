//
//  MEGoodManngerContentVC.m
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEGoodManngerContentVC.h"
#import "MEGoodManngerCell.h"
#import "MEGoodManngerModel.h"
#import "MEAddGoodVC.h"

@interface MEGoodManngerContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEGoodManngerContentVC

- (instancetype)initWithType:(NSInteger)type{
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
    dic[@"state"] = @(_type).description;
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if(self.refresh.pageIndex == 1){
        kMeCallBlock(_finishBlock,self.refresh.response);
    }
    [self.refresh.arrData addObjectsFromArray:[MEGoodManngerModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEGoodManngerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGoodManngerCell class]) forIndexPath:indexPath];
    MEGoodManngerModel *model = self.refresh.arrData[indexPath.row];
    [cell setUiWithModel:model];
    cell.delBlock = ^{
        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除商品?"];
        kMeWEAKSELF
        [aler addButtonWithTitle:@"确定" block:^{
            [MEPublicNetWorkTool postgetDelStoreGoodsWithProduct_id:kMeUnNilStr(model.product_id) SuccessBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                [strongSelf.refresh reload];
            } failure:^(id object) {
                
            }];
        }];
        [aler addButtonWithTitle:@"取消"];
        [aler show];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEGoodManngerCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodManngerModel *model = self.refresh.arrData[indexPath.row];
    MEAddGoodVC *vc = [[MEAddGoodVC alloc]initWithProductId:kMeUnNilStr(model.product_id)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadNetData{
    [self.refresh reload];
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMEGoodManngerContentVCBootomHeigt) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGoodManngerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGoodManngerCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongGoodsGetStoreGoods)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
            failView.lblOfNodata.text = @"没有商品";
        }];
    }
    return _refresh;
}

@end
