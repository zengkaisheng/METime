//
//  MEDiagnoseReportVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseReportVC.h"
#import "MEDiagnoseReportDetailModel.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MEDiagnoseQuestionsCell.h"
#import "MEReportFooterView.h"
#import "MEFeedBackVC.h"

@interface MEDiagnoseReportVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *reportId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEDiagnoseReportDetailModel *model;

@property (nonatomic, strong) MEReportFooterView *footerView;

@end

@implementation MEDiagnoseReportVC

- (instancetype)initWithReportId:(NSString *)reportId {
    if (self = [super init]) {
        _reportId = reportId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"诊断报告";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    
    [self requestDiagnoseReport];
}

#pragma netWorking
- (void)requestDiagnoseReport {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetDiagnoseReportWithReportId:kMeUnNilStr(self.reportId) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.model = [MEDiagnoseReportDetailModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.model = [[MEDiagnoseReportDetailModel alloc] init];
        }
        [strongSelf.view addSubview:strongSelf.tableView];
        [strongSelf.footerView setUIWithContent:kMeUnNilStr(strongSelf.model.desc) phone:kMeUnNilStr(strongSelf.model.telephone)];
        strongSelf.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEReportFooterView getHeightWithContent:kMeUnNilStr(strongSelf.model.desc)]);
        strongSelf.tableView.tableFooterView = strongSelf.footerView;
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)consultAction {
//    MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc] initWithType:1];
//    [self.navigationController pushViewController:feedbackVC animated:YES];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",kMeUnNilStr(self.model.telephone)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.model.questions.count;
    }
    return self.model.analyse.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEDiagnoseQuestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseQuestionsCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        MEReportQuestionsModel *questionsModel = self.model.questions[indexPath.row];
        [cell setUIWithQuestionModel:questionsModel];
        cell.tapBlock = ^(BOOL isSpread){
            questionsModel.isSpread = isSpread;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [tableView reloadData];
        };
    }else {
        if (indexPath.row > self.model.analyse.count-1) {
            [cell setUIWithArray:kMeUnArr(self.model.suggests)];
        }else {
            MEReportAnalyseModel *analyseModel = self.model.analyse[indexPath.row];
            [cell setUIWithAnalyseModel:analyseModel];
            cell.tapBlock = ^(BOOL isSpread){
                analyseModel.isSpread = isSpread;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                //            [tableView reloadData];
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MEReportQuestionsModel *questionsModel = self.model.questions[indexPath.row];
        return [MEDiagnoseQuestionsCell getCellHeightWithQuestionModel:questionsModel];
    }
    if (indexPath.row > self.model.analyse.count-1) {
        return [MEDiagnoseQuestionsCell getCellHeightWithArray:kMeUnArr(self.model.suggests)];
    }
    MEReportAnalyseModel *analyseModel = self.model.analyse[indexPath.row];
    return [MEDiagnoseQuestionsCell getCellHeightWithAnalyseModel:analyseModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    NSString *title = @"";
    if (section == 0) {
        title = @"诊断问题";
    }else {
        title = @"诊断分析";
    }
    [headerView setUIWithTitle:title font:18.0 isHiddenBtn:YES];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (section == 0) {
        height = 30;
    }
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    footer.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionsCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEReportFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle]loadNibNamed:@"MEReportFooterView" owner:nil options:nil] lastObject];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEReportFooterView getHeightWithContent:@"...."]);
        kMeWEAKSELF
        _footerView.tapBlock = ^{
            kMeSTRONGSELF
            [strongSelf consultAction];
        };
    }
    return _footerView;
}

@end
