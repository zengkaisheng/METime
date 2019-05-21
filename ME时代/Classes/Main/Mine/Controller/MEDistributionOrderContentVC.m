//
//  MEDistributionOrderContentVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDistributionOrderContentVC.h"
#import "MEDistributionOrderCell.h"

@interface MEDistributionOrderContentVC ()<UITableViewDelegate, UITableViewDataSource>{
    MEDistrbutionOrderStyle _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;


@end

@implementation MEDistributionOrderContentVC

- (instancetype)initWithType:(MEDistrbutionOrderStyle)type{
    if(self = [super init]){
        _type = type;
        _arrData = @[@"",@"",@"",@"",@"",@"",@"",@""];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //MEStoreModel *storeModel = self.arrStore[section];
    return self.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEDistributionOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDistributionOrderCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:@"" Type:_type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEDistributionOrderCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDistributionOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDistributionOrderCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


@end
