//
//  MEEditCustomerInfomationVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEditCustomerInfomationVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MELivingHabitListModel.h"
#import "MECustomerContentCell.h"
#import "MEAddCustomerInformationModel.h"
#import "MECustomerFilesInfoModel.h"
#import "MECustomerFollowTpyeModel.h"
#import "MESetCustomerFileSalesModel.h"

@interface MEEditCustomerInfomationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *habitList;
@property (nonatomic, strong) NSArray *followTypeList;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger customerId;

@property (nonatomic, strong) MEAddCustomerInformationModel *addInfoModel; //新增Model
@property (nonatomic, strong) MECustomerFilesInfoModel *detailModel; //详情Model
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) NSInteger type;

@end

@implementation MEEditCustomerInfomationVC

- (instancetype)initWithInfo:(NSDictionary *)info customerId:(NSInteger)customerId{
    if (self = [super init]) {
        self.title = kMeUnNilStr(info[@"title"]);
        self.type = [info[@"type"] integerValue];
        [self.dataSource addObject:info];
        self.customerId = customerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    if (self.type == 1) {
        self.tableView.tableFooterView = self.footerView;
    }else if (self.type == 3) {
        self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70);
        self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70);
        [self.view addSubview:self.footerView];
    }
    
}

#pragma mark -- Action
- (void)saveBtnAction {
    switch (self.type) {
        case 1:
            [self addCustomerInformationsWithNetWork];
            break;
        case 2:
            
            break;
        case 3:
            [self saveCustomerSalesInfo];
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

//添加客户基本信息
- (void)addCustomerInformationsWithNetWork {
    MEAddCustomerInformationModel *addModel = [[MEAddCustomerInformationModel alloc] init];
    addModel.idField = self.customerId;
    for (NSDictionary *dict in self.dataSource) {
        if ([dict[@"title"] isEqualToString:@"基本资料"]) {
            NSArray *array = dict[@"content"];
            for (MEAddCustomerInfoModel *model in array) {
                if ([model.title isEqualToString:@"姓名"]) {
                    if (kMeUnNilStr(model.value).length <= 0) {
                        [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                        return;
                    }else {
                        addModel.name = model.value;
                    }
                }
                if ([model.title isEqualToString:@"性别"]) {
                    if (kMeUnNilStr(model.value).length <= 0) {
                        [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                        return;
                    }else {
                        addModel.sex = model.valueId;
                    }
                }
                if ([model.title isEqualToString:@"生日"]) {
                    addModel.birthday = model.value;
                }
                if ([model.title isEqualToString:@"微信"]) {
                    addModel.wechat = model.value;
                }
                if ([model.title isEqualToString:@"QQ"]) {
                    addModel.qq = model.value;
                }
                if ([model.title isEqualToString:@"手机号码"]) {
                    if (kMeUnNilStr(model.value).length <= 0) {
                        [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                        return;
                    }else {
                        addModel.phone = model.value;
                    }
                }
                if ([model.title isEqualToString:@"最佳致电时间"]) {
                    addModel.best_communication_time = model.value;
                }
                if ([model.title isEqualToString:@"身高"]) {
                    addModel.tall = model.value;
                }
                if ([model.title isEqualToString:@"体重"]) {
                    addModel.weight = model.value;
                }
                if ([model.title isEqualToString:@"血型"]) {
                    addModel.blood_type = model.value;
                }
                if ([model.title isEqualToString:@"兴趣爱好"]) {
                    addModel.interest = model.value;
                }
                if ([model.title isEqualToString:@"性格特征"]) {
                    addModel.traits_of_character = model.value;
                }
                if ([model.title isEqualToString:@"婚否"]) {
                    addModel.married = model.valueId;
                }
                if ([model.title isEqualToString:@"职业"]) {
                    addModel.job = model.value;
                }
                if ([model.title isEqualToString:@"月均收入"]) {
                    addModel.month_earning = model.value;
                }
                if ([model.title isEqualToString:@"消费习惯"]) {
                    addModel.consumption_habit = model.value;
                }
                if ([model.title isEqualToString:@"地址"]) {
                    addModel.address = model.value;
                }
                if ([model.title isEqualToString:@"顾客分类"]) {
                    addModel.customer_classify_id = model.valueId;
                }
            }
        }
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditCustomerInformationWithInformationModel:addModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.finishBlock);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id object) {
    }];
}

- (void)saveCustomerSalesInfo {
    MESetCustomerFileSalesModel *salesModel = [[MESetCustomerFileSalesModel alloc] init];
    salesModel.customer_files_id = self.customerId;
    
    for (NSDictionary *dict in self.dataSource) {
        if ([dict[@"title"] isEqualToString:@"顾客销售信息"]) {
            NSArray *array = dict[@"content"];
            for (MEAddCustomerInfoModel *model in array) {
                if ([model.title isEqualToString:@"到店目的及要求"]) {
                    salesModel.objectives_and_requirements = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"兴趣项目"]) {
                    salesModel.interest_object = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"主推项目"]) {
                    salesModel.main_projects = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"预计年消费"]) {
                    salesModel.consumption = kMeUnNilStr(model.value);
                }
            }
        }
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetCustomerSalesInfoWithSalesModel:salesModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.finishBlock);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info isAdd:NO isEdit:YES];
//    kMeWEAKSELF
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.dataSource[indexPath.section];
    return [MECustomerContentCell getCellHeightWithInfo:info];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
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

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [saveBtn setBackgroundColor:kMEPink];
        saveBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        saveBtn.layer.cornerRadius = 20.0;
        [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:saveBtn];
    }
    return _footerView;
}

@end
