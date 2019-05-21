//
//  MEDistributionMoneyVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDistributionMoneyVC.h"
#import "MEDistributionMoneyView.h"

@interface MEDistributionMoneyVC ()<UITableViewDelegate, UITableViewDataSource>{
    id _model;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEDistributionMoneyView *viewDistributionMoney;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MEDistributionMoneyVC

- (instancetype)initWithModel:(id)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享美豆";
    self.view.backgroundColor = kMEHexColor(@"#eeeeee");
    self.tableView.backgroundColor = kMEHexColor(@"#eeeeee");
    self.tableView.tableHeaderView = self.viewDistributionMoney;
    self.tableView.tableFooterView = self.bottomView;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (void)putForward:(UIButton *)btn{
    
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEDistributionMoneyView *)viewDistributionMoney{
    if(!_viewDistributionMoney){
        _viewDistributionMoney = [[[NSBundle mainBundle]loadNibNamed:@"MEDistributionMoneyView" owner:nil options:nil] lastObject];
        _viewDistributionMoney.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEDistributionMoneyViewHeight);
    }
    return _viewDistributionMoney;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 50);
        [btn addTarget:self action:@selector(putForward:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = kMEPink;
        [btn setTitle:@"我要兑换" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_bottomView addSubview:btn];
    }
    return _bottomView;
}


@end
