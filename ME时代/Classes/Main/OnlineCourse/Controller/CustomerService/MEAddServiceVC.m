//
//  MEAddServiceVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddServiceVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerServiceContentCell.h"
#import "MEAddServiceModel.h"

@interface MEAddServiceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger filesId;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, assign) NSInteger type;

@end

@implementation MEAddServiceVC

- (instancetype)initWithInfo:(NSDictionary *)info filesId:(NSInteger)filesId{
    if (self = [super init]) {
        if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"次卡服务详情"]) {
            self.type = 1;
            self.title = @"添加次卡服务";
        }else if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"时间卡服务详情"]) {
            self.type = 2;
            self.title = @"添加时间卡服务";
        }else if ([kMeUnNilStr(info[@"title"]) isEqualToString:@"套盒产品服务详情"]) {
            self.type = 3;
            self.title = @"添加套盒产品服务";
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
    
    [self addServicesRecords];
}
//服务数据组装
- (void)addServicesRecords {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    MEAddCustomerInfoModel *projectModel = [self creatModelWithTitle:@"项目名称" andPlaceHolder:@"请输入项目名称" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入项目名称"];
    
    MEAddCustomerInfoModel *totalModel = [self creatModelWithTitle:@"总次数" andPlaceHolder:@"请输入总次数" andMaxInputWords:10 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入总次数"];
    
    MEAddCustomerInfoModel *residueModel = [self creatModelWithTitle:@"剩余次数" andPlaceHolder:@"请输入剩余次数" andMaxInputWords:10 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入剩余次数"];
    if (self.type == 1) {
        totalModel.title = @"总次数";
        totalModel.isTextField = YES;
        totalModel.isHideArrow = YES;
        totalModel.isNumberType = YES;
        
        residueModel.title = @"剩余次数";
        residueModel.isNumberType = YES;
    }else if (self.type == 2) {
        totalModel.title = @"开卡时间";
        totalModel.isTextField = NO;
        totalModel.isHideArrow = NO;
        totalModel.toastStr = @"请选择开卡时间";
        
        residueModel.title = @"剩余时间";
        residueModel.isTextField = YES;
        residueModel.placeHolder = @"请输入剩余时间";
        residueModel.toastStr = @"请输入剩余时间";
    }else if (self.type == 3) {
        totalModel.title = @"总服务次数";
        totalModel.isTextField = YES;
        totalModel.isHideArrow = YES;
        totalModel.toastStr = @"请输入总服务次数";
        totalModel.isNumberType = YES;
        
        residueModel.title = @"剩余次数";
        residueModel.isNumberType = YES;
    }
    
    if (!self.isAddService) {
        if (self.datas.count > 0) {
            MEAddCustomerInfoModel *proModel = self.datas[0];
            projectModel.value = proModel.value;
            projectModel.isTextField = NO;
            
            MEAddCustomerInfoModel *tolModel = self.datas[1];
            totalModel.value = tolModel.value;
            totalModel.isTextField = NO;
            if (self.type == 2) {
                totalModel.isHideArrow = YES;
            }
            
            MEAddCustomerInfoModel *resiModel = self.datas[2];
            residueModel.value = resiModel.value;
            residueModel.isTextField = NO;
            if (self.type == 2) {
                residueModel.isHideArrow = YES;
                residueModel.isTextField = YES;
            }
        }
    }
    
    [self.dataSource addObject:@{@"title":@"",@"type":@"1",@"isAdd":@(YES),@"isHiddenHeaderV":@(YES),@"content":@[projectModel,totalModel,residueModel]}];
    
    MEAddCustomerInfoModel *oneModel = [self creatModelWithTitle:@"服务次数" andPlaceHolder:@"请输入服务次数" andMaxInputWords:10 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入服务次数"];
    oneModel.value = @"1";
    oneModel.isNumberType = YES;
    
    MEAddCustomerInfoModel *timeModel = [self creatModelWithTitle:@"服务时间" andPlaceHolder:@"请选择服务时间" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择服务时间"];
    timeModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *personModel = [self creatModelWithTitle:@"服务人员" andPlaceHolder:@"请选择服务人员" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择服务人员"];
    personModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *improveModel = [self creatModelWithTitle:@"改善情况" andPlaceHolder:@"请输入" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入改善情况"];
    
    MEAddCustomerInfoModel *confirmModel = [self creatModelWithTitle:@"顾客确认" andPlaceHolder:@"请输入" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请顾客确认"];
    
    MEAddCustomerInfoModel *remarkModel = [self creatModelWithTitle:@"备注" andPlaceHolder:@"请输入备注" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    
    if (!self.isAddService) {
        [self.dataSource addObject:@{@"title":@"",@"type":@"1",@"isAdd":@(YES),@"isHiddenHeaderV":@(YES),@"content":@[oneModel,timeModel,personModel,improveModel,confirmModel,remarkModel]}];
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
//添加服务
- (void)saveCustomerServices {
    MEAddServiceModel *addModel = [[MEAddServiceModel alloc] init];
    addModel.type = self.type;
    addModel.customer_files_id = [NSString stringWithFormat:@"%@",@(self.filesId)];
    
    for (NSDictionary *info in self.dataSource) {
        NSArray *content = info[@"content"];
        for (MEAddCustomerInfoModel *model in content) {
            if (model.isMustInput) {
                if (model.value.length <= 0) {
                    [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                    return;
                }
            }
            if ([model.title isEqualToString:@"项目名称"]) {
                addModel.service_name = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"总次数"] || [model.title isEqualToString:@"总服务次数"]) {
                addModel.total_num = kMeUnNilStr(model.value);
            }
//            if ([model.title isEqualToString:@"剩余次数"]) {
//                addModel.residue_num = kMeUnNilStr(model.value);
//            }
            if ([model.title isEqualToString:@"开卡时间"]) {
                addModel.open_card_time = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"剩余时间"]) {
                addModel.residue_time = kMeUnNilStr(model.value);
            }
        }
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddCustomerServiceWithServiceModel:addModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"添加服务成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock,@{});
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id object) {
    }];
}
//添加服务记录
- (void)addCustomerServicesRecords {
    MEAddServiceModel *addModel = [[MEAddServiceModel alloc] init];
    addModel.type = self.type;
    addModel.service_id = [NSString stringWithFormat:@"%@",@(self.filesId)];
    
    for (NSDictionary *info in self.dataSource) {
        NSArray *content = info[@"content"];
        for (MEAddCustomerInfoModel *model in content) {
            if (model.isMustInput) {
                if (model.value.length <= 0) {
                    [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                    return;
                }
            }
            if ([model.title isEqualToString:@"项目名称"]) {
                addModel.service_name = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"总次数"] || [model.title isEqualToString:@"总服务次数"]) {
                addModel.total_num = [NSString stringWithFormat:@"%d",[kMeUnNilStr(model.value) intValue]];
            }
//            if ([model.title isEqualToString:@"剩余次数"]) {
//                addModel.residue_num = kMeUnNilStr(model.value);
//            }
            if ([model.title isEqualToString:@"开卡时间"]) {
                addModel.open_card_time = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"剩余时间"]) {
                addModel.residue_time = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"服务次数"]) {
                addModel.come_in_count = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"服务时间"]) {
                addModel.service_time = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"服务人员"]) {
                addModel.member = kMeUnNilStr(model.valueId);
            }
            if ([model.title isEqualToString:@"改善情况"]) {
                addModel.change = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"顾客确认"]) {
                addModel.customer_check = kMeUnNilStr(model.value);
            }
            if ([model.title isEqualToString:@"备注"]) {
                addModel.remark = kMeUnNilStr(model.value);
            }
        }
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddCustomerServiceRecordsWithServiceModel:addModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"添加服务记录成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock,@{});
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id object) {
    }];
}

#pragma mark -- Action
- (void)bottomBtnAction {
    if (self.isAddService) {
        [self saveCustomerServices];
    }else {
        [self addCustomerServicesRecords];
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
    MECustomerServiceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerServiceContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info];
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
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
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
