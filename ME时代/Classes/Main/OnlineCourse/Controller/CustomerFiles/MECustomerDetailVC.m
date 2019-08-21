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

@interface MECustomerDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *habitList;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MECustomerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客档案";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self requestHabitlistWithNetWork];
    
}

- (void)loadDatas {
    //基本资料
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"姓名" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *sexModel = [self creatModelWithTitle:@"性别" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *birthdayModel = [self creatModelWithTitle:@"生日" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *WeChatModel = [self creatModelWithTitle:@"微信/QQ" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *phoneModel = [self creatModelWithTitle:@"手机号码" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *bestTimeModel = [self creatModelWithTitle:@"最佳致电时间" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *tailModel = [self creatModelWithTitle:@"身高" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *bloodModel = [self creatModelWithTitle:@"血型" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *hobbyModel = [self creatModelWithTitle:@"兴趣爱好" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *natureModel = [self creatModelWithTitle:@"性格特征" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *marriedModel = [self creatModelWithTitle:@"婚否" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *jobModel = [self creatModelWithTitle:@"职业" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *incomeModel = [self creatModelWithTitle:@"月均收入" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *consumeModel = [self creatModelWithTitle:@"消费习惯" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *adressModel = [self creatModelWithTitle:@"地址" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    
    MEAddCustomerInfoModel *cTypeModel = [self creatModelWithTitle:@"顾客分类" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@""];
    cTypeModel.isLastItem = YES;
    
    [self.dataSource addObject:@{@"title":@"基本资料",@"type":@"1",@"content":@[nameModel,sexModel,birthdayModel,WeChatModel,phoneModel,bestTimeModel,tailModel,bloodModel,hobbyModel,natureModel,marriedModel,jobModel,incomeModel,consumeModel,adressModel,cTypeModel]}];
    //生活习惯信息
    [self.dataSource addObject:@{@"title":@"生活习惯信息",@"type":@"2",@"content":self.habitList}];
    //顾客销售信息
    
    //销售跟进
    
    [self.tableView reloadData];
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder andMaxInputWords:(NSInteger)maxInputWords andIsTextField:(BOOL)isTextField andIsMustInput:(BOOL)isMustInput andToastStr:(NSString *)toastStr{
    
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = @" ";
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
- (void)requestDiagnosisQuestionWithNetWork{
//    kMeWEAKSELF
//    [MEPublicNetWorkTool postGetDiagnoseQuestionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
//        kMeSTRONGSELF
//        if([responseObject.data isKindOfClass:[NSDictionary class]]){
//            strongSelf.model = [MEDiagnoseQuestionModel mj_objectWithKeyValues:responseObject.data];
//        }else {
//            strongSelf.model = [[MEDiagnoseQuestionModel alloc] init];
//        }
//        [strongSelf.view addSubview:strongSelf.tableView];
//        strongSelf.tableView.tableFooterView = strongSelf.bottomView;
//        [strongSelf.tableView reloadData];
//    } failure:^(id object) {
//        kMeSTRONGSELF
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//    }];
}

- (void)requestHabitlistWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetLivingHabitListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSArray class]]){
            strongSelf.habitList = [MELivingHabitListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else {
            strongSelf.habitList = [[NSArray alloc] init];
        }
        [strongSelf loadDatas];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.habitList = [[NSArray alloc] init];
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
//    if (indexPath.row == 0) {
//        MEQuestionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEQuestionHeaderCell class]) forIndexPath:indexPath];
//        MEDiagnosisSubModel *diagnoseModel = self.model.diagnosis[indexPath.section];
//        [cell setUIWithDiagnosisModel:diagnoseModel];
//        return cell;
//    }
    MECustomerContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info];
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
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionsCell class])];
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
