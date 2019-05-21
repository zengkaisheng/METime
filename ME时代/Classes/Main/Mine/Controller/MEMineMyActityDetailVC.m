//
//  MEMineMyActityDetailVC.m
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEMineMyActityDetailVC.h"
#import "MEMineActiveModel.h"
#import "MEMineMyActityDetailCell.h"

@interface MEMineMyActityDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    MEMineActiveModel *_model;
    NSMutableArray *_arrModel;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MEMineMyActityDetailVC

- (instancetype)initWithModel:(MEMineActiveModel *)model{
    if(self = [super init]){
//        _model = model;
//        _arrModel = [NSMutableArray array];
//        NSArray *arrFinish = @[];
//        if(kMeUnArr(_model.complete).count){
//            arrFinish = kMeUnArr(_model.complete);
//        }
//        [_arrModel addObject:arrFinish];
//        NSArray *arrDoing = @[];
//        if(model.doing){
//            arrDoing = @[model.doing];
//        }
//        [_arrModel addObject:arrDoing];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _arrModel[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _arrModel[indexPath.section];
    MEMineActiveLeveModel *model = arr[indexPath.row];
    MEMineMyActityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMineMyActityDetailCell class]) forIndexPath:indexPath];
//    [cell setUIWIthModel:model finish:indexPath.section == 0?YES:NO nowNum:_model.share_number];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEMineMyActityDetailCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMineMyActityDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMineMyActityDetailCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f1f1"];
    }
    return _tableView;
}

@end
