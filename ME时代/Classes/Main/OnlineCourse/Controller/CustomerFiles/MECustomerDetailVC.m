//
//  MECustomerDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerDetailVC.h"
#import "MEAddCustomerInfoModel.h"

@interface MECustomerDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MECustomerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客档案";
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestDiagnosisQuestionNetWork];
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
    
    //生活习惯信息
    
    //顾客销售信息
    
    //销售跟进
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder andMaxInputWords:(NSInteger)maxInputWords andIsTextField:(BOOL)isTextField andIsMustInput:(BOOL)isMustInput andToastStr:(NSString *)toastStr{
    
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.placeHolder = placeHolder;
    model.maxInputWord = maxInputWords;
    model.isTextField = isTextField;
    model.isMustInput = isMustInput;
    model.toastStr = toastStr;
    model.isEdit = YES;
    return model;
}

#pragma NetWorking
- (void)requestDiagnosisQuestionNetWork{
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

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        MEQuestionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEQuestionHeaderCell class]) forIndexPath:indexPath];
//        MEDiagnosisSubModel *diagnoseModel = self.model.diagnosis[indexPath.section];
//        [cell setUIWithDiagnosisModel:diagnoseModel];
//        return cell;
//    }
//    MEDiagnoseQuestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseQuestionsCell class]) forIndexPath:indexPath];
//    MEDiagnosisSubModel *model = self.model.diagnosis[indexPath.section];
//    [cell setUIWithDiagnosisModel:model];
//    return cell;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
//    MEDiagnosisSubModel *model = self.model.diagnosis[indexPath.section];
//    return [MEDiagnoseQuestionsCell getCellHeightWithModel:model];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-10) style:UITableViewStylePlain];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEQuestionHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEQuestionHeaderCell class])];
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

@end
