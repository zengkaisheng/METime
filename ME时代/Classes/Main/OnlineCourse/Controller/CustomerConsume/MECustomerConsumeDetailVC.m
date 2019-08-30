//
//  MECustomerConsumeDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerConsumeDetailVC.h"
#import "MECustomerExpenseDetailModel.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerExpenseContentCell.h"

#import "MEAddExpenseVC.h"
#import "MECustomerExpenseListVC.h"

@interface MECustomerConsumeDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *habitList;
@property (nonatomic, strong) NSArray *followTypeList;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) MECustomerExpenseDetailModel *detailModel; //详情Model

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSInteger filesId;

@end

@implementation MECustomerConsumeDetailVC

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
        [self getCustomerExpenseDetailWithFilesId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客消费详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- Networking
- (void)getCustomerFilesDetailWithPhone {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerFilesDetailWithPhone:self.phone successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if (kMeUnObjectIsEmpty(responseObject.data)) {
            [MECommonTool showMessage:@"未找到档案,请前往顾客档案添加" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else {
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf.detailModel = [MECustomerExpenseDetailModel mj_objectWithKeyValues:responseObject.data];
                if (strongSelf.detailModel.ci_card.count <= 0) {
                    strongSelf.detailModel.ci_card = [[NSArray alloc] init];
                }
                if (strongSelf.detailModel.time_card.count <= 0) {
                    strongSelf.detailModel.time_card = [[NSArray alloc] init];
                }
                if (strongSelf.detailModel.product.count <= 0) {
                    strongSelf.detailModel.product = [[NSArray alloc] init];
                }
                if (strongSelf.detailModel.top_up.count <= 0) {
                    strongSelf.detailModel.top_up = [[NSArray alloc] init];
                }
            }else {
                strongSelf.detailModel = nil;
            }
            [strongSelf loadDetailInfo];
        }
    } failure:^(id object) {
    }];
}

- (void)getCustomerExpenseDetailWithFilesId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerExpenseDetailWithFilesId:self.filesId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.detailModel = [MECustomerExpenseDetailModel mj_objectWithKeyValues:responseObject.data];
            strongSelf.detailModel.idField = strongSelf.filesId;
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
    
    MEAddCustomerInfoModel *bestTimeModel = [self creatModelWithTitle:@"最佳致电时间" andValue:kMeUnNilStr(self.detailModel.best_communication_time)];
    
    MEAddCustomerInfoModel *totalModel = [self creatModelWithTitle:@"总消费" andValue:[NSString stringWithFormat:@"%@元",@(self.detailModel.expense_total)]];
    
    MEAddCustomerInfoModel *yearModel = [self creatModelWithTitle:@"年均消费" andValue:[NSString stringWithFormat:@"%d元",kMeUnNilStr(self.detailModel.annual_average).intValue]];
    
    MEAddCustomerInfoModel *monthModel = [self creatModelWithTitle:@"月均消费" andValue:[NSString stringWithFormat:@"%d元",kMeUnNilStr(self.detailModel.monthly_average).intValue]];
    
    MEAddCustomerInfoModel *typeModel = [self creatModelWithTitle:@"顾客分类" andValue:kMeUnNilStr(self.detailModel.classify_name)];
    
    for (MEExpenseDetailSubModel *model in self.detailModel.top_up) {
        model.type = 4;
    }
    
    for (MEExpenseDetailSubModel *model in self.detailModel.ci_card) {
        model.type = 1;
    }
    
    for (MEExpenseDetailSubModel *model in self.detailModel.time_card) {
        model.type = 2;
    }
    
    for (MEExpenseDetailSubModel *model in self.detailModel.product) {
        model.type = 3;
    }
    
    [self.dataSource addObject:@{@"title":@"基本资料",@"type":@"1",@"filesId":@(self.filesId),@"content":@[nameModel,phoneModel,wechatModel,bestTimeModel,totalModel,yearModel,monthModel,typeModel]}];
    
    [self.dataSource addObject:@{@"title":@"会员充值",@"type":@"2",@"filesId":@(self.filesId),@"content":kMeUnArr(self.detailModel.top_up)}];
    
    [self.dataSource addObject:@{@"title":@"次卡项目",@"type":@"2",@"filesId":@(self.filesId),@"content":kMeUnArr(self.detailModel.ci_card)}];
    
    [self.dataSource addObject:@{@"title":@"时间卡项目",@"type":@"2",@"filesId":@(self.filesId),@"content":kMeUnArr(self.detailModel.time_card)}];
    
    [self.dataSource addObject:@{@"title":@"产品",@"type":@"2",@"filesId":@(self.filesId),@"content":kMeUnArr(self.detailModel.product)}];
    
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
    MECustomerExpenseContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerExpenseContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 0) {//查看详情
            NSInteger type = 1;
            if ([info[@"title"] isEqualToString:@"会员充值"]) {
                type = 4;
            }else if ([info[@"title"] isEqualToString:@"次卡项目"]) {
                type = 1;
            }else if ([info[@"title"] isEqualToString:@"时间卡项目"]) {
                type = 2;
            }else if ([info[@"title"] isEqualToString:@"产品"]) {
                type = 3;
            }
            MECustomerExpenseListVC *listVC = [[MECustomerExpenseListVC alloc] initWithType:type filesId:strongSelf.filesId];
            [strongSelf.navigationController pushViewController:listVC animated:YES];
        }else if (index == 1) {//添加服务
            MEAddExpenseVC *addVC = [[MEAddExpenseVC alloc] initWithInfo:info filesId:strongSelf.filesId];
            addVC.finishBlock = ^(id object) {
                [strongSelf getCustomerExpenseDetailWithFilesId];
            };
            [strongSelf.navigationController pushViewController:addVC animated:YES];
        }else if (index == 2) {
            [strongSelf getCustomerExpenseDetailWithFilesId];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.dataSource[indexPath.section];
    return [MECustomerExpenseContentCell getCellHeightWithInfo:info];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerExpenseContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerExpenseContentCell class])];
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
