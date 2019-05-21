//
//  MEAddGoodStoreGoodsTypeVC.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddGoodStoreGoodsTypeVC.h"
#import "MEAddGoodStoreGoodsTypeCell.h"
#import "MEAddGoodStoreGoodsType.h"

@interface MEAddGoodStoreGoodsTypeVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
   
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEAddGoodStoreGoodsTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    
}


- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEAddGoodStoreGoodsType mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAddGoodStoreGoodsTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddGoodStoreGoodsTypeCell class]) forIndexPath:indexPath];
    MEAddGoodStoreGoodsType *model = self.refresh.arrData[indexPath.row];
    cell.lblTitle.text = kMeUnNilStr(model.category_name);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEAddGoodStoreGoodsTypeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAddGoodStoreGoodsType *model = self.refresh.arrData[indexPath.row];
    kMeCallBlock(_blcok,model);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddGoodStoreGoodsTypeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddGoodStoreGoodsTypeCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPGoodsGetCategory)];
        _refresh.numOfsize = @(100);
//        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
            failView.lblOfNodata.text = @"没有分类";
        }];
    }
    return _refresh;
}
@end
