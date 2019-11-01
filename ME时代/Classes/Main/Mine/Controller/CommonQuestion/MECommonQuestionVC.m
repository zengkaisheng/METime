//
//  MECommonQuestionVC.m
//  志愿星
//
//  Created by gao lei on 2019/6/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommonQuestionVC.h"
#import "MECommonQuestionListModel.h"
#import "MECommonQuestionListCell.h"
#import "MEQuestionDetailVC.h"

@interface MECommonQuestionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation MECommonQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.title = @"常见问题";
    
    [self.view addSubview:self.tableView];
    [self requestNetWork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.rightBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.rightBtn) {
        [self.rightBtn removeFromSuperview];
        self.rightBtn = nil;
    }
}

#pragma mark -- networking
- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetQuestionListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.dataSource removeAllObjects];
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            [self.dataSource addObjectsFromArray:[MECommonQuestionListModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

- (void)reloadData {
    [self requestNetWork];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommonQuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECommonQuestionListCell class]) forIndexPath:indexPath];
    MECommonQuestionListModel *model = self.dataSource[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        NSArray *problem = model.problem;
        MECommonQuestionSubModel *subModel = problem[index];
        MEQuestionDetailVC *detailVC = [[MEQuestionDetailVC alloc] initWithQuestionId:subModel.idField];
        detailVC.title = model.name;
        [strongSelf.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommonQuestionListModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

#pragma setter && getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight + 2, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight - 2) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommonQuestionListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECommonQuestionListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEf5f4f4;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_refresh"] forState:UIControlStateNormal];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 44, 44);
        [_rightBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
