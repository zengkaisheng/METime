//
//  MECustomerDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerDetailVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MELivingHabitListModel.h"
#import "MECustomerContentCell.h"
#import "MEAddCustomerInformationModel.h"
#import "MECustomerFilesInfoModel.h"
#import "MECustomerFollowTpyeModel.h"

#import "MEEditCustomerInfomationVC.h"

@interface MECustomerDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *habitList;
@property (nonatomic, strong) NSArray *followTypeList;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger customerId;

@property (nonatomic, strong) MEAddCustomerInformationModel *addInfoModel; //新增Model
@property (nonatomic, strong) MECustomerFilesInfoModel *detailModel; //详情Model
@property (nonatomic, strong) UIView *footerView;

@end

@implementation MECustomerDetailVC

- (instancetype)initWithCustomerId:(NSInteger)customerId {
    if (self = [super init]) {
        self.customerId = customerId;
        self.isAdd = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客档案";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    if (self.isAdd) {
        self.title = @"新增客户档案";
        [self loadBaseInformation];
        self.tableView.tableFooterView = self.footerView;
    }else {
        [self getCustomerInformationsWithNetWork];
    }
}

- (void)loadBaseInformation {
    //基本资料
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"姓名" andPlaceHolder:@"请输入姓名" andMaxInputWords:20 andIsTextField:self.isAdd?YES:NO andIsMustInput:YES andToastStr:@"请输入姓名"];
    
    MEAddCustomerInfoModel *sexModel = [self creatModelWithTitle:@"性别" andPlaceHolder:@"请选择性别" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请选择性别"];
    sexModel.isHideArrow = self.isAdd?NO:YES;
    
    MEAddCustomerInfoModel *birthdayModel = [self creatModelWithTitle:@"生日" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    birthdayModel.isHideArrow = self.isAdd?NO:YES;
    
    MEAddCustomerInfoModel *WeChatModel = [self creatModelWithTitle:@"微信/QQ" andPlaceHolder:@"" andMaxInputWords:20 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
//    MEAddCustomerInfoModel *qqModel = [self creatModelWithTitle:@"QQ" andPlaceHolder:@"" andMaxInputWords:20 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *phoneModel = [self creatModelWithTitle:@"手机号码" andPlaceHolder:@"请输入手机号码" andMaxInputWords:11 andIsTextField:self.isAdd?YES:NO andIsMustInput:YES andToastStr:@"请输入手机号码"];
    phoneModel.isNumberType = YES;
    
    MEAddCustomerInfoModel *bestTimeModel = [self creatModelWithTitle:@"最佳致电时间" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    bestTimeModel.isHideArrow = self.isAdd?NO:YES;
    
    MEAddCustomerInfoModel *tailModel = [self creatModelWithTitle:@"身高" andPlaceHolder:@"" andMaxInputWords:10 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *weightModel = [self creatModelWithTitle:@"体重" andPlaceHolder:@"" andMaxInputWords:10 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *bloodModel = [self creatModelWithTitle:@"血型" andPlaceHolder:@"" andMaxInputWords:10 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *hobbyModel = [self creatModelWithTitle:@"兴趣爱好" andPlaceHolder:@"" andMaxInputWords:30 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *natureModel = [self creatModelWithTitle:@"性格特征" andPlaceHolder:@"" andMaxInputWords:30 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *marriedModel = [self creatModelWithTitle:@"婚否" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    marriedModel.isHideArrow = self.isAdd?NO:YES;
    
    MEAddCustomerInfoModel *jobModel = [self creatModelWithTitle:@"职业" andPlaceHolder:@"" andMaxInputWords:30 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *incomeModel = [self creatModelWithTitle:@"月均收入" andPlaceHolder:@"" andMaxInputWords:30 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *consumeModel = [self creatModelWithTitle:@"消费习惯" andPlaceHolder:@"" andMaxInputWords:30 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *adressModel = [self creatModelWithTitle:@"地址" andPlaceHolder:@"" andMaxInputWords:40 andIsTextField:self.isAdd?YES:NO andIsMustInput:NO andToastStr:@""];
    
    MEAddCustomerInfoModel *cTypeModel = [self creatModelWithTitle:@"顾客分类" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    cTypeModel.isHideArrow = self.isAdd?NO:YES;
    cTypeModel.isLastItem = YES;
    
    if (!self.isAdd) {
        nameModel.value = kMeUnNilStr(self.detailModel.name);
        sexModel.value = self.detailModel.sex==1?@"男":self.detailModel.sex==2?@"女":@" ";
        sexModel.valueId = [NSString stringWithFormat:@"%@",@(self.detailModel.sex)];
        birthdayModel.value = kMeUnNilStr(self.detailModel.birthday);
        WeChatModel.value = kMeUnNilStr(self.detailModel.wechat);
//        qqModel.value = kMeUnNilStr(self.detailModel.qq);
        phoneModel.value = kMeUnNilStr(self.detailModel.phone);
        bestTimeModel.value = kMeUnNilStr(self.detailModel.best_communication_time);
        tailModel.value = [NSString stringWithFormat:@"%@",@(self.detailModel.tall)];
        weightModel.value = [NSString stringWithFormat:@"%@",@(self.detailModel.weight)];
        bloodModel.value = kMeUnNilStr(self.detailModel.blood_type);
        hobbyModel.value = kMeUnNilStr(self.detailModel.interest);
        natureModel.value = kMeUnNilStr(self.detailModel.traits_of_character);
        marriedModel.valueId = [NSString stringWithFormat:@"%@",@(self.detailModel.married)];
        marriedModel.value = self.detailModel.married==1?@"已婚":@"未婚";
        jobModel.value = kMeUnNilStr(self.detailModel.job);
        incomeModel.value = kMeUnNilStr(self.detailModel.month_earning);
        consumeModel.value = kMeUnNilStr(self.detailModel.consumption_habit);
        adressModel.value = kMeUnNilStr(self.detailModel.address);
        cTypeModel.value = kMeUnNilStr(self.detailModel.classify_name);
    }
    
    [self.dataSource addObject:@{@"title":@"基本资料",@"type":@"1",@"content":@[nameModel,sexModel,birthdayModel,WeChatModel,phoneModel,bestTimeModel,tailModel,weightModel,bloodModel,hobbyModel,natureModel,marriedModel,jobModel,incomeModel,consumeModel,adressModel,cTypeModel]}];
}

- (void)loadHabitDatas {
    for (MELivingHabitListModel *listModel in self.habitList) {
        for (MELivingHabitsOptionModel *optionModel in listModel.habit) {
            for (MECustomerInfoHabitModel *habitModel in self.detailModel.habit) {
                if (habitModel.classify_id == optionModel.classify_id) {
                    if (habitModel.habit_arr.count > 0) {
                        for (MECustomerInfoHabitSubModel *subModel in habitModel.habit_arr) {
                            if (subModel.idField == optionModel.idField) {
                                optionModel.isSelected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    //生活习惯信息
    [self.dataSource addObject:@{@"title":@"生活习惯信息",@"type":@"2",@"content":self.habitList}];
}

- (void)loadSalesDatas {
    //顾客销售信息
    MEAddCustomerInfoModel *requirmentsModel = [self creatModelWithTitle:@"到店目的及要求" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    requirmentsModel.value = kMeUnNilStr(self.detailModel.objectives_and_requirements);
    
    MEAddCustomerInfoModel *interestModel = [self creatModelWithTitle:@"兴趣项目" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    interestModel.value = kMeUnNilStr(self.detailModel.interest_object);
    
    MEAddCustomerInfoModel *mainModel = [self creatModelWithTitle:@"主推项目" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    mainModel.value = kMeUnNilStr(self.detailModel.main_projects);
    
    MEAddCustomerInfoModel *consumptionModel = [self creatModelWithTitle:@"预计年消费" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@""];
    consumptionModel.value = [NSString stringWithFormat:@"%@",@(self.detailModel.consumption)];
    consumptionModel.isLastItem = YES;
    
    [self.dataSource addObject:@{@"title":@"顾客销售信息",@"type":@"3",@"content":@[requirmentsModel,interestModel,mainModel,consumptionModel]}];
}

- (void)loadFollowDatas {
    for (MECustomerInfoFollowModel *followModel in self.detailModel.follow) {
        followModel.followList = [self.followTypeList copy];
        for (NSString *string in followModel.follow_type) {
            for (MECustomerFollowTpyeModel *typeModel in followModel.followList) {
                if ([string integerValue] == typeModel.idField) {
                    typeModel.isSelected = YES;
                }
            }
        }
    }
    
    //销售跟进
    [self.dataSource addObject:@{@"title":@"销售跟进",@"type":@"4",@"content":self.detailModel.follow,@"options":self.followTypeList}];
}

#pragma mark -- Action
- (void)saveBtnAction {
    [self addCustomerInformationsWithNetWork];
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

#pragma NetWorking
- (void)getCustomerInformationsWithNetWork{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.label.text = @"获取详情中...";
    hud.userInteractionEnabled = YES;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{//生活习惯列表
        [MEPublicNetWorkTool postGetLivingHabitListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSArray class]]){
                strongSelf.habitList = [MELivingHabitListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            }else {
                strongSelf.habitList = [[NSArray alloc] init];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.habitList = [[NSArray alloc] init];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetFollowTypeListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSArray class]]){
                strongSelf.followTypeList = [MECustomerFollowTpyeModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            }else {
                strongSelf.followTypeList = [[NSArray alloc] init];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.followTypeList = [[NSArray alloc] init];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{//顾客详情资料
        [MEPublicNetWorkTool postGetCustomerInformationWithCustomerId:self.customerId successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf.detailModel = [MECustomerFilesInfoModel mj_objectWithKeyValues:responseObject.data];
            }else {
                strongSelf.detailModel = nil;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.detailModel = nil;
            if([object isKindOfClass:[ZLRequestResponse class]]){
                ZLRequestResponse *res = (ZLRequestResponse*)object;
                [MEShowViewTool SHOWHUDWITHHUD:hud test:kMeUnNilStr(res.message)];
            }else{
                [MEShowViewTool SHOWHUDWITHHUD:hud test:kApiError];
            }
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            kMeSTRONGSELF
            if (strongSelf.detailModel == nil) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }else {
                if (strongSelf.dataSource.count > 0) {
                    [strongSelf.dataSource removeAllObjects];
                }
                [strongSelf loadBaseInformation];
                [strongSelf loadHabitDatas];
                [strongSelf loadSalesDatas];
                [strongSelf loadFollowDatas];
                [strongSelf.tableView reloadData];
            }
        });
    });
}
/*
- (void)requestCustomerInfomationWithNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerInformationWithCustomerId:self.customerId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.detailModel = [MECustomerFilesInfoModel mj_objectWithKeyValues:responseObject.data];
        }
        [strongSelf requestHabitlistWithNetWork];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//获取生活习惯
- (void)requestHabitlistWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetLivingHabitListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSArray class]]){
            strongSelf.habitList = [MELivingHabitListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else {
            strongSelf.habitList = [[NSArray alloc] init];
        }
        [strongSelf loadBaseInformation];
        [strongSelf loadHabitDatas];
        [strongSelf loadSalesDatas];
        [strongSelf loadFollowDatas];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.habitList = [[NSArray alloc] init];
    }];
}
 */
//添加客户基本信息
- (void)addCustomerInformationsWithNetWork {
    MEAddCustomerInformationModel *addModel = [[MEAddCustomerInformationModel alloc] init];
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
    [MEPublicNetWorkTool postAddCustomerInformationWithInformationModel:addModel successBlock:^(ZLRequestResponse *responseObject) {
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
    [cell setUIWithInfo:info isAdd:self.isAdd isEdit:NO];
    kMeWEAKSELF
    cell.tapBlock = ^{
        kMeSTRONGSELF
        MEEditCustomerInfomationVC *editVC = [[MEEditCustomerInfomationVC alloc] initWithInfo:info customerId:self.customerId];
        kMeWEAKSELF
        editVC.finishBlock = ^{
            kMeSTRONGSELF
            [strongSelf getCustomerInformationsWithNetWork];
        };
        [strongSelf.navigationController pushViewController:editVC animated:YES];
    };
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
