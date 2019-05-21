//
//  MEClerksSortVC.m
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEClerksSortVC.h"
#import "MEClerksSortCell.h"
#import "MEFilterClerkView.h"
#import "MEClerksSortModel.h"

@interface MEClerksSortVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,FilterClerkViewDelegate>{
    kMEFilterClerkViewType _type;
    ButtonClickType _typeSort;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) MEFilterClerkView *filterView;
@end

@implementation MEClerksSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店员排名";
    //默认 转发 大到小
    _type = kMEFilterClerkViewZfType;
    _typeSort = ButtonClickTypeDown;
    self.view.backgroundColor = kMEeeeeee;
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    NSString *order = @"";
    switch (_type) {
        case kMEFilterClerkViewZfType:
            order = @"share";
            break;
        case kMEFilterClerkViewReadType:
            order = @"read";
            break;
        case kMEFilterClerkViewMoneyType:
            order = @"brokerage";
            break;
        default:
            break;
    }
    NSString *order_type = _typeSort==ButtonClickTypeDown?@"desc":@"asc";
    return @{@"order":order,@"order_type":order_type,@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEClerksSortModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)selectTopButton:(MEFilterClerkView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType)type{
    _type = index;
    _typeSort = type;
    [self.refresh reload];
}


#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEClerksSortModel *model = self.refresh.arrData[indexPath.row];
    MEClerksSortCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEClerksSortCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEClerksSortCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+kMEFilterClerkViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEFilterClerkViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEClerksSortCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEClerksSortCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEeeeeee;
        _tableView.tableFooterView = view;
        _tableView.backgroundColor = kMEeeeeee;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonMyClerkOrder)];
        _refresh.delegate = self;
        _refresh.isGet = YES;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有店员";
        }];
    }
    return _refresh;
}

- (MEFilterClerkView *)filterView{
    if(!_filterView){
        _filterView = [[MEFilterClerkView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, kMEFilterClerkViewHeight)];
        _filterView.delegate = self;
    }
    return _filterView;
}
@end
