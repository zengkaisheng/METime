//
//  MECustomerMessageCollectVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerMessageCollectVC.h"
#import "MEDiagnoseQuestionModel.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MEQuestionHeaderCell.h"
#import "MEDiagnoseQuestionsCell.h"
#import "MEDiagnosedSuccessVC.h"

@interface MECustomerMessageCollectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEDiagnoseQuestionModel *model;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *is_been;

@end

@implementation MECustomerMessageCollectVC

- (instancetype)initWithName:(NSString *)name phone:(NSString *)phone isBeen:(NSString *)is_been {
    if (self = [super init]) {
        self.name = name;
        self.phone = phone;
        self.is_been = is_been;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"诊断问题";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [self requestDiagnosisQuestionNetWork];
}

#pragma NetWorking
- (void)requestDiagnosisQuestionNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetDiagnoseQuestionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.model = [MEDiagnoseQuestionModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.model = [[MEDiagnoseQuestionModel alloc] init];
        }
        [strongSelf.view addSubview:strongSelf.tableView];
        strongSelf.tableView.tableFooterView = strongSelf.bottomView;
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)submitDiagnosisQuestionWithJson:(NSString *)json{
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddDiagnoseQuestionWithName:kMeUnNilStr(self.name) phone:kMeUnNilStr(self.phone) isBeen:kMeUnNilStr(self.is_been) optionsJson:json successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            [kMeUserDefaults setObject:@"1" forKey:kMEHasConsult];
            [kMeUserDefaults synchronize];
            //跳到提交成功页面
            MEDiagnosedSuccessVC *vc = [[MEDiagnosedSuccessVC alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.diagnosis.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MEQuestionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEQuestionHeaderCell class]) forIndexPath:indexPath];
        MEDiagnosisSubModel *diagnoseModel = self.model.diagnosis[indexPath.section];
        [cell setUIWithDiagnosisModel:diagnoseModel];
        return cell;
    }
    MEDiagnoseQuestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseQuestionsCell class]) forIndexPath:indexPath];
    MEDiagnosisSubModel *model = self.model.diagnosis[indexPath.section];
    [cell setUIWithDiagnosisModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 62;
    }
    MEDiagnosisSubModel *model = self.model.diagnosis[indexPath.section];
    return [MEDiagnoseQuestionsCell getCellHeightWithModel:model];
}

#pragma mark -- action
- (void)savBtnDidClick {
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *diagnosis = [NSMutableDictionary dictionary];
    
    for (MEDiagnosisSubModel *diagnoseModel in self.model.diagnosis) {
    
        for (MEQuestionsSubModel *questionModel in diagnoseModel.questions) {
            BOOL isChoose = NO;
            if (questionModel.type == 3) {
                if (questionModel.answer.length > 0) {
                    isChoose = YES;
                    [tempDic setObject:@(diagnoseModel.idField) forKey:@"classify_id"];
                    
                    [diagnosis setObject:@(questionModel.idField) forKey:@"question_id"];
                    [diagnosis setObject:@(questionModel.type) forKey:@"type"];
                    [diagnosis setObject:questionModel.answer forKey:@"content"];
                    [tempDic setObject:@[[diagnosis copy]] forKey:@"diagnosis"];
                    [mutableArr addObject:[tempDic copy]];
                    [tempDic removeAllObjects];
                    [diagnosis removeAllObjects];
                }
            }else {
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (MEOptionsSubModel *optionModel in questionModel.options) {
                    if (optionModel.isSelected) {
                        isChoose = YES;
                        [tempArr addObject:@(optionModel.idField)];
                    }
                }
                if (questionModel.type == 1) {
                    [tempDic setObject:@(diagnoseModel.idField) forKey:@"classify_id"];
                    
                    [diagnosis setObject:@(questionModel.idField) forKey:@"question_id"];
                    [diagnosis setObject:@(questionModel.type) forKey:@"type"];
                    [diagnosis setObject:tempArr.firstObject forKey:@"option_id"];
                    [tempDic setObject:@[[diagnosis copy]] forKey:@"diagnosis"];
                    [mutableArr addObject:[tempDic copy]];
                    [tempDic removeAllObjects];
                    [diagnosis removeAllObjects];
                    [tempArr removeAllObjects];
                }else if (questionModel.type == 2) {
                    [tempDic setObject:@(diagnoseModel.idField) forKey:@"classify_id"];
                    
                    [diagnosis setObject:@(questionModel.idField) forKey:@"question_id"];
                    [diagnosis setObject:@(questionModel.type) forKey:@"type"];
                    [diagnosis setObject:[tempArr copy] forKey:@"option_id"];
                    [tempDic setObject:@[[diagnosis copy]] forKey:@"diagnosis"];
                    [mutableArr addObject:[tempDic copy]];
                    [diagnosis removeAllObjects];
                    [tempDic removeAllObjects];
                    [tempArr removeAllObjects];
                }
            }
            
            if (!isChoose) {
                if (questionModel.type == 3) {
                    [MECommonTool showMessage:[NSString stringWithFormat:@"请回答%@",questionModel.question] view:self.view];
                    return;
                }else {
                    [MECommonTool showMessage:[NSString stringWithFormat:@"请选择%@",questionModel.question] view:self.view];
                    return;
                }
            }
        }
    }
    NSLog(@"填写的数据是:%@",mutableArr);
    NSString *json = [NSString convertToJsonData:mutableArr];
    [self submitDiagnosisQuestionWithJson:json];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-10) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEQuestionHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEQuestionHeaderCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionsCell class])];
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        saveBtn.frame = CGRectMake(71, 17, SCREEN_WIDTH-71*2, 40);
        saveBtn.backgroundColor = kMEPink;
        saveBtn.layer.cornerRadius = 40/2.0;
        [saveBtn addTarget:self action:@selector(savBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:saveBtn];
    }
    return _bottomView;
}

@end

