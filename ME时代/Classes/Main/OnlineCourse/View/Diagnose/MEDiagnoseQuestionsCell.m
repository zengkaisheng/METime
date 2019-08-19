//
//  MEDiagnoseQuestionsCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseQuestionsCell.h"
#import "MEDiagnoseQuestionModel.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MEDiagnoseOptionsCell.h"

#import "MEDiagnoseReportDetailModel.h"
#import "MEDiagnoseReportCell.h"
#import "MEReportSuggestsCell.h"

@interface MEDiagnoseQuestionsCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MEDiagnosisSubModel *model;
//诊断报告相关
@property (nonatomic, strong) MEReportQuestionsModel *questionModel;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) MEReportAnalyseModel *analyseModel;

@end


@implementation MEDiagnoseQuestionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseOptionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseReportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseReportCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEReportSuggestsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEReportSuggestsCell class])];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
    
    _tableView.layer.shadowOffset = CGSizeMake(0, 1);
    _tableView.layer.shadowOpacity = 1;
    _tableView.layer.shadowRadius = 3;
    _tableView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _tableView.layer.masksToBounds = false;
    _tableView.layer.cornerRadius = 10;
    _tableView.clipsToBounds = false;
}

#pragma mark -- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return self.model.questions.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model) {
        MEQuestionsSubModel *questionModel = self.model.questions[section];
        if (questionModel.type == 3) {
            return 1;
        }
        return questionModel.options.count;
    }
    if (self.questionModel) {
        if (self.questionModel.isSpread) {
            return 0;
        }
        return self.questionModel.diagnosis.count;
    }
    if (self.analyseModel) {
        if (self.analyseModel.isSpread) {
            return 0;
        }
        return 1;
    }
    if (self.datas) {
        return self.datas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model) {
        MEDiagnoseOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class]) forIndexPath:indexPath];
        MEQuestionsSubModel *questionModel = self.model.questions[indexPath.section];
        if (questionModel.type == 3) {
            [cell setUIWithContent:kMeUnNilStr(questionModel.answer)];
            cell.contentBlock = ^(NSString *str) {
                questionModel.answer = str;
            };
        }else {
            MEOptionsSubModel *optionModel = questionModel.options[indexPath.row];
            [cell setUIWithModel:optionModel];
        }
        return cell;
    }
    
    if (self.questionModel) {
        MEDiagnoseReportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseReportCell class]) forIndexPath:indexPath];
        
        MEReportDiagnosisModel *diagnosisModel = self.questionModel.diagnosis[indexPath.row];
        [cell setUIWithDiagnosisModel:diagnosisModel];
        return cell;
    }
    
    if (self.analyseModel) {
        MEDiagnoseReportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDiagnoseReportCell class]) forIndexPath:indexPath];
        
        [cell setUIWithAnalyseModel:self.analyseModel];
        return cell;
    }
    if (self.datas) {
        MEReportSuggestsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEReportSuggestsCell class]) forIndexPath:indexPath];
        NSString *str = self.datas[indexPath.row];
        cell.titleLbl.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row+1,str];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model) {
        MEQuestionsSubModel *questionModel = self.model.questions[indexPath.section];
        if (questionModel.type == 3) {
            return 50;
        }
        MEOptionsSubModel *optionModel = questionModel.options[indexPath.row];
        return optionModel.cellHeight;
    }
    
    if (self.questionModel) {
        MEReportDiagnosisModel *diagnosisModel = self.questionModel.diagnosis[indexPath.row];
        return diagnosisModel.cellHeight;
    }
    
    if (self.analyseModel) {
        return self.analyseModel.cellHeight;
    }
    if (self.datas) {
        NSString *str = [NSString stringWithFormat:@"%ld、%@",indexPath.row+1,self.datas[indexPath.row]];
        return [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.model) {
        MEQuestionsSubModel *questionModel = self.model.questions[section];
        return questionModel.cellHeight;
    }
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    if (self.model) {
        MEQuestionsSubModel *questionModel = self.model.questions[section];
        NSString *title = [NSString stringWithFormat:@"%ld、%@",section+1,kMeUnNilStr(questionModel.question)];
        [headerView setUIWithTitle:title font:15.0 isHiddenBtn:YES];
    }
    
    if (self.questionModel) {
        [headerView setUIWithQuestionModel:self.questionModel];
        kMeWEAKSELF
        headerView.tapBlock = ^(BOOL isSpread){
           kMeSTRONGSELF
            strongSelf.questionModel.isSpread = !strongSelf.questionModel.isSpread;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            kMeCallBlock(strongSelf.tapBlock,isSpread);
        };
    }
    
    if (self.analyseModel) {
        [headerView setUIWithAnalyseModel:self.analyseModel];
        kMeWEAKSELF
        headerView.tapBlock = ^(BOOL isSpread){
            kMeSTRONGSELF
            strongSelf.analyseModel.isSpread = !strongSelf.analyseModel.isSpread;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            kMeCallBlock(strongSelf.tapBlock,isSpread);
        };
    }
    if (self.datas && self.datas.count > 0) {
        [headerView setUIWithTitle:@"总体建议汇总" font:18.0 isHiddenBtn:NO];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [footerView setUIWithTitle:@"" font:0.0 isHiddenBtn:YES];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model) {
        MEQuestionsSubModel *questionModel = self.model.questions[indexPath.section];
        if (questionModel.type == 1) {
            for (MEOptionsSubModel *optionModel in questionModel.options) {
                optionModel.isSelected = NO;
            }
            MEOptionsSubModel *optionModel = questionModel.options[indexPath.row];
            optionModel.isSelected = YES;
        }else if (questionModel.type == 2) {
            MEOptionsSubModel *optionModel = questionModel.options[indexPath.row];
            optionModel.isSelected = !optionModel.isSelected;
        }
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}
//诊断问题提问
- (void)setUIWithDiagnosisModel:(MEDiagnosisSubModel *)model {
    self.questionModel = nil;
    self.analyseModel = nil;
    self.datas = nil;
    self.model = model;
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithModel:(MEDiagnosisSubModel *)model {
    CGFloat height = 0.0;
    for (MEQuestionsSubModel *questionModel in model.questions) {
        height += questionModel.cellHeight;
        if (questionModel.type == 3) {
            height += 50;
        }
        for (MEOptionsSubModel *optionsModel in questionModel.options) {
            height += optionsModel.cellHeight;
        }
        height += 10;
    }
    return height>0?height+10:0;
}
//诊断问题回答
- (void)setUIWithQuestionModel:(MEReportQuestionsModel *)model {
    self.questionModel = model;
    self.analyseModel = nil;
    self.datas = nil;
    self.model = nil;
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithQuestionModel:(MEReportQuestionsModel *)model {
    CGFloat height = 49.0;
    if (model.isSpread) {
        return height+10;
    }
    for (MEReportDiagnosisModel *diagnosisModel in model.diagnosis) {
        height += diagnosisModel.cellHeight;
    }
    return height+20;
}
//诊断分析
- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model {
    self.analyseModel = model;
    self.questionModel = nil;
    self.datas = nil;
    self.model = nil;
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithAnalyseModel:(MEReportAnalyseModel *)model {
    if (model.isSpread) {
        return 49+10;
    }
    return model.cellHeight+49+20;
}
//建议
- (void)setUIWithArray:(NSArray *)array {
    self.questionModel = nil;
    self.model = nil;
    self.analyseModel = nil;
    self.datas = [array copy];
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithArray:(NSArray *)array {
    CGFloat height = 49.0;
    for (int i = 0; i < array.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d、%@",i+1,array[i]];
        height += [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
    }
    return height+20;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
