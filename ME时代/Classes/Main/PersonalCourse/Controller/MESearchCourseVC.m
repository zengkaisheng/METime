//
//  MESearchCourseVC.m
//  志愿星
//
//  Created by gao lei on 2019/9/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESearchCourseVC.h"
#import "MEFourSearchCouponNavView.h"
#import "MEPersionalCourseListCell.h"
#import "MEPersonalCourseListModel.h"
#import "MEPersionalCourseDetailVC.h"

@interface MESearchCourseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) MEFourSearchCouponNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, copy) NSString *keyword;

@end

@implementation MESearchCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    [self.view addSubview:self.navView];
    [self.navView.searchTF becomeFirstResponder];
    [self.view addSubview:self.tableView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"keyword":kMeUnNilStr(self.keyword)
             };
}

- (void)handleResponse:(id)data{
    if (![data isKindOfClass:[NSArray class]]) {
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECourseListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEPersionalCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPersionalCourseListCell class]) forIndexPath:indexPath];
    MECourseListModel *listModel = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:listModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEPersionalCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseListModel *listModel = self.refresh.arrData[indexPath.row];
    
    MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:listModel.idField];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter && getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersionalCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPersionalCourseListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCoursesGetCoursesList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关课程";
        }];
    }
    return _refresh;
}

- (MEFourSearchCouponNavView *)navView{
    if(!_navView){
        _navView = [[MEFourSearchCouponNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight)];
        kMeWEAKSELF
        self.navView.searchTF.placeholder = @"搜索课程";
        _navView.searchBlock = ^(NSString *str) {
            kMeSTRONGSELF
            if (strongSelf.keyword.length <= 0) {
                strongSelf.keyword = str;
                [strongSelf.refresh addRefreshView];
            } else {
                strongSelf.keyword = str;
                [strongSelf.refresh reload];
            }
        };
        _navView.backBlock = ^{
            kMeSTRONGSELF
            [strongSelf.view endEditing:YES];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navView;
}
@end
