//
//  MEAddAppointmentVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddAppointmentVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerExpenseContentCell.h"
#import "MEAddCustomerAppointmentModel.h"
#import "MEAppointmentListModel.h"

@interface MEAddAppointmentVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger appointmentId;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) MEAppointmentListModel *detailModel;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation MEAddAppointmentVC

- (instancetype)initWithAppointmentId:(NSInteger)appointmentId {
    if (self = [super init]) {
        self.appointmentId = appointmentId;
        self.isEdit = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    
    if (self.isEdit) {
        self.title = @"编辑顾客预约";
        [self getAppointmentDetail];
        [self.bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    }else {
        if (self.isAddProject) {
            self.title = @"添加项目";
            [self reloadProjectDatas];
            [self.bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
        }else {
            self.title = @"顾客预约";
            [self reloadAppointmentDatas];
            [self.bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
        }
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    [self.view endEditing:YES];
}

//添加项目
- (void)reloadProjectDatas {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    MEAddCustomerInfoModel *projectModel = [self creatModelWithTitle:@"项目名称" andPlaceHolder:@"请输入项目名称" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入项目名称"];
    
    [self.dataSource addObject:@{@"title":self.title,@"type":@"1",@"isHiddenHeaderV":@(YES),@"content":@[projectModel]}];
    
    [self.tableView reloadData];
}
//预约数据组装
- (void)reloadAppointmentDatas {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"顾客姓名" andPlaceHolder:@"请选择顾客" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择顾客"];
    nameModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *saleModel = [self creatModelWithTitle:@"销售顾问" andPlaceHolder:@"请选择销售顾问" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择销售顾问"];
    saleModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *beauticianModel = [self creatModelWithTitle:@"美容师" andPlaceHolder:@"请选择美容师" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择美容师"];
    beauticianModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *timeModel = [self creatModelWithTitle:@"预约时间" andPlaceHolder:@"请选择预约时间" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请选择预约时间"];
    timeModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *projectModel = [self creatModelWithTitle:@"预约项目" andPlaceHolder:@"请选择预约项目" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请选择预约项目"];
    projectModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *feeModel = [self creatModelWithTitle:@"手工费" andPlaceHolder:@"请输入手工费" andMaxInputWords:0 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入手工费"];
    feeModel.isNumberType = YES;
    
    if (self.isEdit) {
        nameModel.value = kMeUnNilStr(self.detailModel.name);
        saleModel.value = kMeUnNilStr(self.detailModel.sales_consultant_name);
        saleModel.valueId = [NSString stringWithFormat:@"%@",@(self.detailModel.sales_consultant)];
        beauticianModel.value = kMeUnNilStr(self.detailModel.cosmetologist_name);
        beauticianModel.valueId = [NSString stringWithFormat:@"%@",@(self.detailModel.cosmetologist)];
        timeModel.value = [NSString stringWithFormat:@"%@ %@",kMeUnNilStr(self.detailModel.appointment_date),kMeUnNilStr(self.detailModel.appointment_time)];
        projectModel.value = kMeUnNilStr(self.detailModel.object_name);
        projectModel.valueId = [NSString stringWithFormat:@"%@",@(self.detailModel.object_id)];
        feeModel.value = [NSString stringWithFormat:@"%@",@(self.detailModel.workmanship_charge)];
    }
    
    [self.dataSource addObject:@{@"title":self.title,@"type":@"1",@"isHiddenHeaderV":@(YES),@"content":@[nameModel,saleModel,beauticianModel,timeModel,projectModel,feeModel]}];
    
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

- (void)bottomBtnAction {
    NSDictionary *info = self.dataSource[0];
    NSArray *content = info[@"content"];
    if (self.isEdit) {
        [self EditCustomerAppointmentWithDatas:content];
    }else {
        if (self.isAddProject) {
            [self addAppointmentObjectWithDatas:content];
        }else {
            [self addCustomerAppointmentWithDatas:content];
        }
    }
}
#pragma mark -- Networking
//获取预约详情
- (void)getAppointmentDetail {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetAppointmentDetailWithAppointmentId:[NSString stringWithFormat:@"%@",@(self.appointmentId)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.detailModel = [MEAppointmentListModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.detailModel = nil;
        }
        [strongSelf reloadAppointmentDatas];
    } failure:^(id object) {
        kMeSTRONGSELF strongSelf.detailModel = nil;
    }];
}
//添加项目
- (void)addAppointmentObjectWithDatas:(NSArray *)content {
    MEAddCustomerInfoModel *model = content[0];
    if (kMeUnNilStr(model.value).length <= 0) {
        [MECommonTool showMessage:@"请输入项目名称" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddAppointmentObjectWithObjectName:kMeUnNilStr(model.value) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            [MECommonTool showMessage:@"添加成功" view:kMeCurrentWindow];
            kMeCallBlock(strongSelf.finishBlock);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
    }];
}
//添加预约
- (void)addCustomerAppointmentWithDatas:(NSArray *)content {
    MEAddCustomerAppointmentModel *addModel = [[MEAddCustomerAppointmentModel alloc] init];
    for (MEAddCustomerInfoModel *model in content) {
        if (model.value.length <= 0) {
            [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
            return;
        }
        if ([model.title isEqualToString:@"顾客姓名"]) {
            addModel.customer_files_id = model.valueId;
        }
        if ([model.title isEqualToString:@"销售顾问"]) {
            addModel.sales_consultant = model.valueId;
        }
        if ([model.title isEqualToString:@"美容师"]) {
            addModel.cosmetologist = model.valueId;
        }
        if ([model.title isEqualToString:@"预约时间"]) {
            NSArray *timeArr = [model.value componentsSeparatedByString:@" "];
            addModel.appointment_date = kMeUnNilStr(timeArr.firstObject);
            addModel.appointment_time = kMeUnNilStr(timeArr.lastObject);
        }
        if ([model.title isEqualToString:@"预约项目"]) {
            addModel.object_id = model.valueId;
        }
        if ([model.title isEqualToString:@"手工费"]) {
            addModel.workmanship_charge = model.value;
        }
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddCustomerAppointmentWithModel:addModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            [MECommonTool showMessage:@"添加成功" view:kMeCurrentWindow];
            kMeCallBlock(strongSelf.finishBlock);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
    }];
}
//编辑预约
- (void)EditCustomerAppointmentWithDatas:(NSArray *)content {
    MEAddCustomerAppointmentModel *addModel = [[MEAddCustomerAppointmentModel alloc] init];
    for (MEAddCustomerInfoModel *model in content) {
        if (model.value.length <= 0) {
            [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
            return;
        }
        if ([model.title isEqualToString:@"顾客姓名"]) {
            addModel.customer_files_id = model.valueId;
        }
        if ([model.title isEqualToString:@"销售顾问"]) {
            addModel.sales_consultant = model.valueId;
        }
        if ([model.title isEqualToString:@"美容师"]) {
            addModel.cosmetologist = model.valueId;
        }
        if ([model.title isEqualToString:@"预约时间"]) {
            NSArray *timeArr = [model.value componentsSeparatedByString:@" "];
            addModel.appointment_date = kMeUnNilStr(timeArr.firstObject);
            addModel.appointment_time = kMeUnNilStr(timeArr.lastObject);
        }
        if ([model.title isEqualToString:@"预约项目"]) {
            addModel.object_id = model.valueId;
        }
        if ([model.title isEqualToString:@"手工费"]) {
            addModel.workmanship_charge = model.value;
        }
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditCustomerAppointmentWithModel:addModel appointmentId:[NSString stringWithFormat:@"%@",@(self.appointmentId)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            [MECommonTool showMessage:@"修改成功" view:kMeCurrentWindow];
            kMeCallBlock(strongSelf.finishBlock);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
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
    MECustomerExpenseContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerExpenseContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70) style:UITableViewStylePlain];
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
