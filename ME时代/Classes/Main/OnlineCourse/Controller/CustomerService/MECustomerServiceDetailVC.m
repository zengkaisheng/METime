//
//  MECustomerServiceDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceDetailVC.h"
#import "MECustomerServiceDetailModel.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerServiceContentCell.h"
#import "MEAddServiceVC.h"
#import "MEServiceListVC.h"

@interface MECustomerServiceDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *habitList;
@property (nonatomic, strong) NSArray *followTypeList;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) MECustomerServiceDetailModel *detailModel; //详情Model

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSInteger filesId;

@end

@implementation MECustomerServiceDetailVC

- (instancetype)initWithPhone:(NSString *)phone {
    if (self = [super init]) {
        self.phone = phone;
        [self getCustomerFilesDetailWithPhone];
    }
    return self;
}

- (instancetype)initWithFilesId:(NSInteger)filesId {
    if (self = [super init]) {
        self.filesId = filesId;
        [self getCustomerServiceDetailWithFilesId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客服务详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark -- Networking
- (void)getCustomerFilesDetailWithPhone {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerFilesDetailWithPhone:self.phone successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.detailModel = [MECustomerServiceDetailModel mj_objectWithKeyValues:responseObject.data];
            if (strongSelf.detailModel.ci_card_service.count <= 0) {
                strongSelf.detailModel.ci_card_service = [[NSArray alloc] init];
            }
            if (strongSelf.detailModel.time_card_service.count <= 0) {
                strongSelf.detailModel.time_card_service = [[NSArray alloc] init];
            }
            if (strongSelf.detailModel.product_service.count <= 0) {
                strongSelf.detailModel.product_service = [[NSArray alloc] init];
            }
        }else {
            strongSelf.detailModel = nil;
        }
        [strongSelf loadDetailInfo];
    } failure:^(id object) {
    }];
}

- (void)getCustomerServiceDetailWithFilesId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerServiceDetailWithFilesId:self.filesId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.detailModel = [MECustomerServiceDetailModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.detailModel = nil;
        }
        [strongSelf loadDetailInfo];
    } failure:^(id object) {
    }];
}

- (void)loadDetailInfo {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    //基本资料
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"姓名" andValue:kMeUnNilStr(self.detailModel.name)];
    
    MEAddCustomerInfoModel *phoneModel = [self creatModelWithTitle:@"手机号码" andValue:kMeUnNilStr(self.detailModel.phone)];
    
    MEAddCustomerInfoModel *wechatModel = [self creatModelWithTitle:@"微信/QQ" andValue:kMeUnNilStr(self.detailModel.wechat)];
    
    MEAddCustomerInfoModel *habitModel = [self creatModelWithTitle:@"预约习惯" andValue:kMeUnNilStr(self.detailModel.consumption_habit)];
    
    MEAddCustomerInfoModel *bestTimeModel = [self creatModelWithTitle:@"最佳预约时间" andValue:kMeUnNilStr(self.detailModel.best_communication_time)];
    
    MEAddCustomerInfoModel *totalModel = [self creatModelWithTitle:@"总到店次数" andValue:[NSString stringWithFormat:@"%@次",@(self.detailModel.come_total)]];
    
    MEAddCustomerInfoModel *yearModel = [self creatModelWithTitle:@"年均到店次数" andValue:[NSString stringWithFormat:@"%d次",kMeUnNilStr(self.detailModel.annual_average).intValue]];
    
    MEAddCustomerInfoModel *monthModel = [self creatModelWithTitle:@"月均到店次数" andValue:[NSString stringWithFormat:@"%d次",kMeUnNilStr(self.detailModel.monthly_average).intValue]];
    
    [self.dataSource addObject:@{@"title":@"基本资料",@"type":@"1",@"content":@[nameModel,phoneModel,wechatModel,habitModel,bestTimeModel,totalModel,yearModel,monthModel]}];
    
    [self.dataSource addObject:@{@"title":@"次卡服务详情",@"type":@"2",@"content":kMeUnArr(self.detailModel.ci_card_service)}];
    
    [self.dataSource addObject:@{@"title":@"时间卡服务详情",@"type":@"2",@"content":kMeUnArr(self.detailModel.time_card_service)}];
    
    [self.dataSource addObject:@{@"title":@"套盒产品服务详情",@"type":@"2",@"content":kMeUnArr(self.detailModel.product_service)}];
    
    [self.tableView reloadData];
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andValue:(NSString *)value{
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = value;
    model.isTextField = NO;
    model.isHideArrow = YES;
    return model;
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerServiceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerServiceContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 0) {//查看详情
            MEServiceListVC *listVC = [[MEServiceListVC alloc] initWithType:indexPath.section filesId:strongSelf.filesId];
            [strongSelf.navigationController pushViewController:listVC animated:YES];
        }else if (index == 1) {//添加服务
            MEAddServiceVC *addVC = [[MEAddServiceVC alloc] initWithInfo:info filesId:strongSelf.filesId];
            addVC.isAddService = YES;
            addVC.finishBlock = ^(id object) {
                [strongSelf getCustomerServiceDetailWithFilesId];
            };
            [strongSelf.navigationController pushViewController:addVC animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.dataSource[indexPath.section];
    return [MECustomerServiceContentCell getCellHeightWithInfo:info];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerServiceContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerServiceContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
