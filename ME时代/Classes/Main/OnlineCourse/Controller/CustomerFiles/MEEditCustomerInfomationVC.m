//
//  MEEditCustomerInfomationVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEditCustomerInfomationVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerContentCell.h"
#import "MEAddCustomerInformationModel.h"
#import "MECustomerFilesInfoModel.h"
#import "MESetCustomerFileSalesModel.h"
#import "MEEditFollowsVC.h"

@interface MEEditCustomerInfomationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *habitList;
@property (nonatomic, strong) NSArray *followTypeList;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger customerId;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *bottomBtn;
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
    
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
    
    if (self.type == 4) {
        [self.bottomBtn setTitle:@"添加跟进记录" forState:UIControlStateNormal];
    }
}

- (void)addFollowDatas {
    //销售跟进
    //重新组装数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataSource.firstObject];
    
    MECustomerInfoFollowModel *followModel = [[MECustomerInfoFollowModel alloc] init];

    NSMutableArray *followList = [NSMutableArray array];

    MEAddCustomerInfoModel *projectModel = [self creatModelWithTitle:@"项目" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请输入项目"];
    [followList addObject:projectModel];

    MEAddCustomerInfoModel *followTimeModel = [self creatModelWithTitle:@"跟进时间" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请选择跟进时间"];
    [followList addObject:followTimeModel];

    MEAddCustomerInfoModel *followTpyeModel = [self creatModelWithTitle:@"跟进类型" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请选择跟进类型"];
    [followList addObject:followTpyeModel];
    
    [followList addObjectsFromArray:[dict[@"options"] copy]];

    MEAddCustomerInfoModel *resultModel = [self creatModelWithTitle:@"跟进结果" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:NO andToastStr:@"请输入跟进结果"];
    [followList addObject:resultModel];

    followModel.followList = [followList copy];

    [dict setObject:@[followModel] forKey:@"content"];
    
    MEEditFollowsVC *vc = [[MEEditFollowsVC alloc] initWithInfo:[dict copy] customerId:self.customerId];
    kMeWEAKSELF
    vc.finishBlock = ^(MECustomerInfoFollowModel *model) {
        kMeSTRONGSELF
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:strongSelf.dataSource.firstObject];
        NSMutableArray *follows = [NSMutableArray arrayWithArray:(NSArray *)info[@"content"]];
        
        [follows insertObject:model atIndex:0];
        [info setObject:[follows copy] forKey:@"content"];
        
        kMeCallBlock(strongSelf.finishBlock);
        
        [strongSelf.dataSource removeAllObjects];
        [strongSelf.dataSource addObject:[info copy]];
        [strongSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    //销售跟进
    //[self.dataSource addObject:@{@"title":@"销售跟进",@"type":@"4",@"content":self.detailModel.follow,@"options":self.followTypeList}];
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

#pragma mark -- Action
- (void)bottomBtnAction {
    [self.view endEditing:YES];
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
            [self addFollowDatas];
            break;
        default:
            break;
    }
}
//保存销售跟进信息
- (void)rightBtnAction {
    
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
                if ([model.title isEqualToString:@"微信/QQ"]) {
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
    if (self.type == 4) {
        cell.isEditFollow = YES;
        [cell setUIWithInfo:info isAdd:NO isEdit:NO];
    }else {
        cell.isEditFollow = NO;
        [cell setUIWithInfo:info isAdd:NO isEdit:YES];
    }
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        NSArray *content = info[@"content"];
        MECustomerInfoFollowModel *followModel = (MECustomerInfoFollowModel *)content[index];
        NSDictionary *editInfo = @{@"title":@"销售跟进",@"type":@"4",@"content":@[followModel],@"options":info[@"options"]};
        MEEditFollowsVC *editVC = [[MEEditFollowsVC alloc] initWithInfo:editInfo customerId:strongSelf.customerId];
        editVC.isEdit = YES;
        
        editVC.finishBlock = ^(MECustomerInfoFollowModel *model) {
            [strongSelf.tableView reloadData];
        };
        [strongSelf.navigationController pushViewController:editVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[indexPath.section]];
    [dict setObject:@(YES) forKey:@"editFollows"];
    return [MECustomerContentCell getCellHeightWithInfo:dict];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70) style:UITableViewStylePlain];
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
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:kMEPink];
        _rightBtn.cornerRadius = 12;
        _rightBtn.clipsToBounds = YES;
        _rightBtn.frame = CGRectMake(0, 0, 65, 25);
        _rightBtn.titleLabel.font = kMeFont(15);
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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
