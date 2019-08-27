//
//  MEAddExpenseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddExpenseVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerExpenseContentCell.h"
#import "MEAddCustomerExpenseModel.h"
#import "MECustomerExpenseDetailModel.h"
#import "MEExpenseDetailsModel.h"
#import "MEExpenseSourceModel.h"

@interface MEAddExpenseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger filesId;

@property (nonatomic, strong) NSArray *sourceList;
@property (nonatomic, strong) NSArray *natureList;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) MEExpenseDetailsModel *expenseModel;

@end

@implementation MEAddExpenseVC

- (instancetype)initWithInfo:(NSDictionary *)info filesId:(NSInteger)filesId{
    if (self = [super init]) {
        if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"次卡项目"]) {
            self.type = 1;
            self.title = @"次卡项目";
        }else if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"时间卡项目"]) {
            self.type = 2;
            self.title = @"时间卡项目";
        }else if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"产品"]) {
            self.type = 3;
            self.title = @"产品";
        }else if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"会员充值"]) {
            self.type = 4;
            self.title = @"会员充值";
        }
        [self.datas addObjectsFromArray:kMeUnArr(info[@"content"])];
        self.filesId = filesId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70);
    self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70);
    [self.view addSubview:self.footerView];
    
    if (self.isEdit) {
        [self getExpenseDetail];
    }else {
        if (self.type == 4) {
            [self reloadDatas];
        }else {
            [self getExpenseSourceList];
        }
    }
}

- (void)reloadDatas {
    if (self.type == 4) {
        [self reloadExpenseDatasWithTopUp];
    }else {
        [self reloadExpenseDatasWithCardData];
    }
}

//服务数据组装
- (void)reloadExpenseDatasWithTopUp {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    MEAddCustomerInfoModel *amountModel = [self creatModelWithTitle:@"充值金额" andPlaceHolder:@"请输入充值金额" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入充值金额"];
    amountModel.isNumberType = YES;
    
    MEAddCustomerInfoModel *timeModel = [self creatModelWithTitle:@"充值时间" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择充值时间"];
    timeModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *contentModel = [self creatModelWithTitle:@"充值活动内容" andPlaceHolder:@"请输入充值活动内容" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入充值活动内容"];
    
    MEAddCustomerInfoModel *projectModel = [self creatModelWithTitle:@"赠送项目" andPlaceHolder:@"请输入赠送项目" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *productModel = [self creatModelWithTitle:@"赠送产品" andPlaceHolder:@"请输入赠送产品" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *requirementModel = [self creatModelWithTitle:@"充值金划扣要求" andPlaceHolder:@"请输入充值金划扣要求" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入充值金划扣要求"];
    
    MEAddCustomerInfoModel *remarkModel = [self creatModelWithTitle:@"备注" andPlaceHolder:@"请输入备注" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    
    if (self.isEdit) {
        amountModel.value = [NSString stringWithFormat:@"%@",@(self.expenseModel.money)];
        timeModel.value = kMeUnNilStr(self.expenseModel.top_up_time);
        contentModel.value = kMeUnNilStr(self.expenseModel.content);
        projectModel.value = kMeUnNilStr(self.expenseModel.give_object);
        productModel.value = kMeUnNilStr(self.expenseModel.give_product);
        requirementModel.value = kMeUnNilStr(self.expenseModel.require);
        remarkModel.value = kMeUnNilStr(self.expenseModel.remark);
    }
    
    [self.dataSource addObject:@{@"title":self.title,@"type":@"1",@"isHiddenHeaderV":@(YES),@"content":@[amountModel,timeModel,contentModel,projectModel,productModel,requirementModel,remarkModel]}];
    
    [self.tableView reloadData];
}

- (void)reloadExpenseDatasWithCardData {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"项目名称" andPlaceHolder:@"请输入项目名称" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入项目名称"];
    [array addObject:nameModel];
    
    MEAddCustomerInfoModel *amountModel = [self creatModelWithTitle:@"消费金额" andPlaceHolder:@"请输入消费金额" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入消费金额"];
    amountModel.isNumberType = YES;
    [array addObject:amountModel];
    
    MEAddCustomerInfoModel *sourceModel = [self creatModelWithTitle:@"消费来源" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请选择消费来源"];
    sourceModel.isHideArrow = YES;
    [array addObject:sourceModel];
    
    if (self.isEdit) {
        for (NSString *ids in self.expenseModel.source_id) {
            for (MEExpenseSourceModel *sourceModel in self.sourceList) {
                if ([ids integerValue] == sourceModel.idField) {
                    sourceModel.isSelected = YES;
                }
            }
        }
    }
    [array addObjectsFromArray:self.sourceList];
    
    MEAddCustomerInfoModel *timeModel = [self creatModelWithTitle:@"消费时间" andPlaceHolder:@"请选择消费时间" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择消费时间"];
    timeModel.isHideArrow = NO;
    if (self.type == 2) {
        timeModel.title = @"开卡时间";
        timeModel.placeHolder = timeModel.toastStr = @"请选择开卡时间";
    }
    [array addObject:timeModel];
    
    MEAddCustomerInfoModel *contentModel = [self creatModelWithTitle:@"项目内容" andPlaceHolder:@"请输入项目内容" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入项目内容"];
    if (self.type == 3) {
        contentModel.title = @"购买产品内容";
        contentModel.placeHolder = contentModel.toastStr = @"请输入购买产品内容";
    }
    [array addObject:contentModel];
    
    MEAddCustomerInfoModel *numModel = [self creatModelWithTitle:@"购买次数" andPlaceHolder:@"请输入购买次数" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入购买次数"];
    numModel.isNumberType = YES;
    if (self.type == 2) {
        numModel.title = @"购买时长";
        numModel.placeHolder = numModel.toastStr = @"请输入购买时长";
        numModel.isNumberType = YES;
    }else if (self.type == 3) {
        numModel.title = @"赠送产品内容";
        numModel.placeHolder = numModel.toastStr = @"请输入赠送产品内容";
        numModel.isNumberType = NO;
    }
    [array addObject:numModel];
    
    MEAddCustomerInfoModel *giveNumModel = [self creatModelWithTitle:@"赠送次数" andPlaceHolder:@"请输入赠送次数" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    giveNumModel.isNumberType = YES;
    if (self.type == 2) {
        giveNumModel.title = @"赠送时长";
        giveNumModel.placeHolder = giveNumModel.toastStr = @"请输入赠送时长";
    }else if (self.type == 3) {
        giveNumModel.title = @"产品性质";
        giveNumModel.toastStr = @"请选择产品性质";
        giveNumModel.isTextField = NO;
        giveNumModel.isHideArrow = YES;
    }
    [array addObject:giveNumModel];
    
    if (self.isEdit) {
        for (NSString *ids in self.expenseModel.product_nature_id) {
            for (MEExpenseSourceModel *natureModel in self.natureList) {
                if ([ids integerValue] == natureModel.idField) {
                    natureModel.isSelected = YES;
                }
            }
        }
    }
    [array addObjectsFromArray:self.natureList];
    
    MEAddCustomerInfoModel *totalModel = [self creatModelWithTitle:@"总次数" andPlaceHolder:@"请输入总次数" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入总次数"];
    totalModel.isNumberType = YES;
    if (self.type == 2) {
        totalModel.title = @"总时长";
        totalModel.placeHolder = totalModel.toastStr = @"请输入总时长";
    }else if (self.type == 3) {
        totalModel.title = @"赠送服务次数";
        totalModel.placeHolder = totalModel.toastStr = @"请输入赠送服务次数";
        totalModel.isMustInput = NO;
    }
    [array addObject:totalModel];
    
    MEAddCustomerInfoModel *remarkModel = [self creatModelWithTitle:@"备注" andPlaceHolder:@"请输入备注" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    [array addObject:remarkModel];
    
    if (self.isEdit) {
        nameModel.value = kMeUnNilStr(self.expenseModel.name);
        amountModel.value = [NSString stringWithFormat:@"%@",@(self.expenseModel.money)];
        sourceModel.value = @" ";
        timeModel.value = kMeUnNilStr(self.expenseModel.expense_date);
        contentModel.value = kMeUnNilStr(self.expenseModel.content);
        numModel.value = [NSString stringWithFormat:@"%@",@(self.expenseModel.num)];
        giveNumModel.value = [NSString stringWithFormat:@"%@",@(self.expenseModel.give_num)];
        totalModel.value = [NSString stringWithFormat:@"%@",@(self.expenseModel.total_num)];
        remarkModel.value = kMeUnNilStr(self.expenseModel.remark);
        if (self.type == 2) {
            timeModel.value = kMeUnNilStr(self.expenseModel.open_time);
            numModel.value = kMeUnNilStr(self.expenseModel.time);
            giveNumModel.value = kMeUnNilStr(self.expenseModel.give_time);
            totalModel.value = kMeUnNilStr(self.expenseModel.total_time);
        }else if (self.type == 3) {
            numModel.value = kMeUnNilStr(self.expenseModel.give_content);
            giveNumModel.value = @" ";
            totalModel.value = [NSString stringWithFormat:@"%@",@(self.expenseModel.give_service_num)];
        }
    }
    if (self.type == 3) {
        [self.dataSource addObject:@{@"title":self.title,@"type":@"1",@"isHiddenHeaderV":@(YES),@"content":[array copy],@"sourceCount":@(self.sourceList.count),@"natureCount":@(self.natureList.count)}];
    }else {
        [self.dataSource addObject:@{@"title":self.title,@"type":@"1",@"isHiddenHeaderV":@(YES),@"content":[array copy],@"sourceCount":@(self.sourceList.count)}];
    }
    
    [self.tableView reloadData];
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder andMaxInputWords:(NSInteger)maxInputWords andIsTextField:(BOOL)isTextField andIsMustInput:(BOOL)isMustInput andToastStr:(NSString *)toastStr{
    
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = @"";
    model.placeHolder = placeHolder;
    model.maxInputWord = maxInputWords;
    model.isTextField = isTextField;
    model.isMustInput = isMustInput;
    model.toastStr = toastStr;
    model.isEdit = YES;
    model.isHideArrow = YES;
    return model;
}

#pragma mark -- Networking
//获取消费详情
- (void)getExpenseDetail {
    MEExpenseDetailSubModel *model = self.datas.firstObject;
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerExpenseDetailWithExpenseId:model.idField type:self.type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.expenseModel = [MEExpenseDetailsModel mj_objectWithKeyValues:responseObject.data];
        }
        if (strongSelf.type == 4) {
            [strongSelf reloadDatas];
        }else {
            [strongSelf getExpenseSourceList];
        }
    } failure:^(id object) {
    }];
}

//获取消费来源
- (void)getExpenseSourceList {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetExpenseSourceListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.sourceList = [MEExpenseSourceModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            [strongSelf.sourceList enumerateObjectsUsingBlock:^(MEExpenseSourceModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.type = 1;
            }];
        }else {
            strongSelf.sourceList = [[NSArray alloc] init];
        }
        if (strongSelf.type == 3) {
            [strongSelf getProductNatureList];
        }else {
            [strongSelf reloadDatas];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.sourceList = [[NSArray alloc] init];
        [strongSelf reloadDatas];
    }];
}

//获取产品性质
- (void)getProductNatureList {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetExpenseProductNatureListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.natureList = [MEExpenseSourceModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            [strongSelf.natureList enumerateObjectsUsingBlock:^(MEExpenseSourceModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.type = 2;
            }];
        }else {
            strongSelf.natureList = [[NSArray alloc] init];
        }
        [strongSelf reloadDatas];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.natureList = [[NSArray alloc] init];
        [strongSelf reloadDatas];
    }];
}

//添加消费
- (void)saveCustomerExpense {
    MEAddCustomerExpenseModel *addModel = [[MEAddCustomerExpenseModel alloc] init];
    addModel.type = self.type;
    addModel.customer_files_id = [NSString stringWithFormat:@"%@",@(self.filesId)];
    
    NSMutableArray *sourceId = [[NSMutableArray alloc] init];
    NSMutableArray *natureId = [[NSMutableArray alloc] init];
    for (NSDictionary *info in self.dataSource) {
        NSArray *content = info[@"content"];
        for (id obj in content) {
            if ([obj isKindOfClass:[MEAddCustomerInfoModel class]]) {
                MEAddCustomerInfoModel *model = (MEAddCustomerInfoModel *)obj;
                if (model.isMustInput) {
                    if (model.value.length <= 0) {
                        [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                        return;
                    }
                }
                if ([model.title isEqualToString:@"充值金额"] || [model.title isEqualToString:@"消费金额"]) {
                    addModel.money = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"项目名称"]) {
                    addModel.name = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"充值时间"]) {
                    addModel.top_up_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"充值活动内容"] || [model.title isEqualToString:@"项目内容"] || [model.title isEqualToString:@"购买产品内容"]) {
                    addModel.content = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"消费时间"]) {
                    addModel.expense_date = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"购买次数"]) {
                    addModel.num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送次数"]) {
                    addModel.give_num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"总次数"]) {
                    addModel.total_num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"开卡时间"]) {
                    addModel.open_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"购买时长"]) {
                    addModel.time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送时长"]) {
                    addModel.give_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"总时长"]) {
                    addModel.total_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送产品内容"]) {
                    addModel.give_content = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送服务次数"]) {
                    addModel.give_service_num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送项目"]) {
                    addModel.give_object = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送产品"]) {
                    addModel.give_product = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"充值金划扣要求"]) {
                    addModel.require = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"备注"]) {
                    addModel.remark = kMeUnNilStr(model.value);
                }
            }else if ([obj isKindOfClass:[MEExpenseSourceModel class]]) {
                MEExpenseSourceModel *model = (MEExpenseSourceModel *)obj;
                if (model.type == 1) {
                    if (model.isSelected) {
                        [sourceId addObject:[NSString stringWithFormat:@"%@",@(model.idField)]];
                    }
                }else if (model.type == 2) {
                    if (model.isSelected) {
                        [natureId addObject:[NSString stringWithFormat:@"%@",@(model.idField)]];
                    }
                }
            }
        }
    }
    if (self.type != 4) {
        if (self.type == 3) {
            if (natureId.count <= 0) {
                [MECommonTool showMessage:@"请选择产品性质" view:kMeCurrentWindow];
                return;
            }else {
                addModel.product_nature_id = [natureId componentsJoinedByString:@","];
            }
        }
        if (sourceId.count <= 0) {
            [MECommonTool showMessage:@"请选择消费来源" view:kMeCurrentWindow];
            return;
        }else {
            addModel.source_id = [sourceId componentsJoinedByString:@","];
        }
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddCustomerExpenseWithExpenseModel:addModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"添加成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock,@{});
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id object) {
    }];
}

//编辑顾客消费
- (void)editCustomerExpense {
    MEAddCustomerExpenseModel *addModel = [[MEAddCustomerExpenseModel alloc] init];
    addModel.type = self.type;
    addModel.customer_files_id = [NSString stringWithFormat:@"%@",@(self.expenseModel.customer_files_id)];
    
    NSMutableArray *sourceId = [[NSMutableArray alloc] init];
    NSMutableArray *natureId = [[NSMutableArray alloc] init];
    for (NSDictionary *info in self.dataSource) {
        NSArray *content = info[@"content"];
        for (id obj in content) {
            if ([obj isKindOfClass:[MEAddCustomerInfoModel class]]) {
                MEAddCustomerInfoModel *model = (MEAddCustomerInfoModel *)obj;
                if (model.isMustInput) {
                    if (model.value.length <= 0) {
                        [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                        return;
                    }
                }
                if ([model.title isEqualToString:@"充值金额"] || [model.title isEqualToString:@"消费金额"]) {
                    addModel.money = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"项目名称"]) {
                    addModel.name = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"充值时间"]) {
                    addModel.top_up_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"充值活动内容"] || [model.title isEqualToString:@"项目内容"] || [model.title isEqualToString:@"购买产品内容"]) {
                    addModel.content = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"消费时间"]) {
                    addModel.expense_date = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"购买次数"]) {
                    addModel.num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送次数"]) {
                    addModel.give_num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"总次数"]) {
                    addModel.total_num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"开卡时间"]) {
                    addModel.open_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"购买时长"]) {
                    addModel.time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送时长"]) {
                    addModel.give_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"总时长"]) {
                    addModel.total_time = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送产品内容"]) {
                    addModel.give_content = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送服务次数"]) {
                    addModel.give_service_num = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送项目"]) {
                    addModel.give_object = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"赠送产品"]) {
                    addModel.give_product = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"充值金划扣要求"]) {
                    addModel.require = kMeUnNilStr(model.value);
                }
                if ([model.title isEqualToString:@"备注"]) {
                    addModel.remark = kMeUnNilStr(model.value);
                }
            }else if ([obj isKindOfClass:[MEExpenseSourceModel class]]) {
                MEExpenseSourceModel *model = (MEExpenseSourceModel *)obj;
                if (model.type == 1) {
                    if (model.isSelected) {
                        [sourceId addObject:[NSString stringWithFormat:@"%@",@(model.idField)]];
                    }
                }else if (model.type == 2) {
                    if (model.isSelected) {
                        [natureId addObject:[NSString stringWithFormat:@"%@",@(model.idField)]];
                    }
                }
            }
        }
    }
    if (self.type != 4) {
        if (self.type == 3) {
            if (natureId.count <= 0) {
                [MECommonTool showMessage:@"请选择产品性质" view:kMeCurrentWindow];
                return;
            }else {
                addModel.product_nature_id = [natureId componentsJoinedByString:@","];
            }
        }
        if (sourceId.count <= 0) {
            [MECommonTool showMessage:@"请选择消费来源" view:kMeCurrentWindow];
            return;
        }else {
            addModel.source_id = [sourceId componentsJoinedByString:@","];
        }
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditCustomerExpenseWithExpenseModel:addModel expenseId:self.expenseModel.expense_id successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"修改成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock,@{});
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id object) {
    }];
}

#pragma mark -- Action
- (void)bottomBtnAction {
    if (self.isEdit) {
        [self editCustomerExpense];
    }else {
        [self saveCustomerExpense];
    }
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.dataSource[indexPath.section];
    return [MECustomerExpenseContentCell getCellHeightWithInfo:info];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerExpenseContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerExpenseContentCell class])];
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

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn setBackgroundColor:kMEPink];
        _bottomBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        _bottomBtn.layer.cornerRadius = 20.0;
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
