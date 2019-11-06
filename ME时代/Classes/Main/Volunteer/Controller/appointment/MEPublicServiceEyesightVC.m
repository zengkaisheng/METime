//
//  MEPublicServiceEyesightVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicServiceEyesightVC.h"
#import "MEPersionalCourseListCell.h"
#import "MEPersonalCourseListModel.h"
#import "MEPersionalCourseDetailVC.h"
#import "MEAppointmentEyesightDetailVC.h"

#import "MEFiveHomeNavView.h"
#import "MEFiveCategoryView.h"

@interface MEPublicServiceEyesightVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) UIButton *appointmentBtn;

@end

@implementation MEPublicServiceEyesightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公益视力";
    self.navBarHidden = self.isHome;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self.view addSubview:self.appointmentBtn];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"classify_id":@(9)
             };
}

- (void)handleResponse:(id)data{
    if (![data isKindOfClass:[NSArray class]]) {
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECourseListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- Action
- (void)appointmentAction {
    MEAppointmentEyesightDetailVC *vc = [[MEAppointmentEyesightDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEPersionalCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPersionalCourseListCell class]) forIndexPath:indexPath];
    MECourseListModel *listModel = self.refresh.arrData[indexPath.row];
    [cell setPublicServiceUIWithModel:listModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEPersionalCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseListModel *listModel = self.refresh.arrData[indexPath.row];
    if (listModel.type == 3) {
        MEBaseVC *vc = [[MEBaseVC alloc] init];
        vc.title = @"详情";
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        CGFloat width = [UIScreen mainScreen].bounds.size.width-15;
        NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
        [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(listModel.detail)] baseURL:nil];
        [vc.view addSubview:webView];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:listModel.idField];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma setter && getter
- (UITableView *)tableView{
    if(!_tableView){
        
        CGRect frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
        if (self.isHome) {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-kMEFiveCategoryViewHeight);
        }
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
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
            failView.lblOfNodata.text = @"暂无相关数据";
        }];
    }
    return _refresh;
}

- (UIButton *)appointmentBtn{
    if(!_appointmentBtn){
        _appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _appointmentBtn.frame = CGRectMake(15, SCREEN_HEIGHT -15-44, SCREEN_WIDTH-30, 44);
        [_appointmentBtn setTitle:@"视力预约" forState:UIControlStateNormal];
        [_appointmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_appointmentBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        _appointmentBtn.layer.cornerRadius = 5;
        _appointmentBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_appointmentBtn addTarget:self action:@selector(appointmentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointmentBtn;
}

@end
