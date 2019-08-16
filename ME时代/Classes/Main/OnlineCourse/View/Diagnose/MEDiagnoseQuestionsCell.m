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

@interface MEDiagnoseQuestionsCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MEDiagnosisSubModel *model;

@end


@implementation MEDiagnoseQuestionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseOptionsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseOptionsCell class])];
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
    return self.model.questions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MEQuestionsSubModel *questionModel = self.model.questions[section];
    if (questionModel.type == 3) {
        return 1;
    }
    return questionModel.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEQuestionsSubModel *questionModel = self.model.questions[indexPath.section];
    if (questionModel.type == 3) {
        return 50;
    }
    MEOptionsSubModel *optionModel = questionModel.options[indexPath.row];
    return optionModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MEQuestionsSubModel *questionModel = self.model.questions[section];
    return questionModel.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    MEQuestionsSubModel *questionModel = self.model.questions[section];
    NSString *title = [NSString stringWithFormat:@"%ld、%@",section+1,kMeUnNilStr(questionModel.question)];
    [headerView setUIWithTitle:title];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [footerView setUIWithTitle:@""];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)setUIWithDiagnosisModel:(MEDiagnosisSubModel *)model {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
