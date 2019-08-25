//
//  MEDiagnoseQuestionHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseQuestionHeaderView.h"
#import "MEDiagnoseReportDetailModel.h"

@interface MEDiagnoseQuestionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MEDiagnoseQuestionHeaderView

- (void)setUIWithTitle:(NSString *)title font:(CGFloat)font isHiddenBtn:(BOOL)isHidden{
    _arrowBtn.hidden = isHidden;
    _editBtn.hidden = _lineView.hidden = YES;
    _titleLbl.text = title;
    _titleLbl.font = [UIFont systemFontOfSize:font];
}

- (void)setUIWithQuestionModel:(MEReportQuestionsModel *)model {
    _arrowBtn.hidden = NO;
    _editBtn.hidden = _lineView.hidden = YES;
    _arrowBtn.selected = model.isSpread;
    _titleLbl.text = kMeUnNilStr(model.classify_name);
    _titleLbl.font = [UIFont systemFontOfSize:18.0];
}

- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model {
    _arrowBtn.hidden = NO;
    _editBtn.hidden = _lineView.hidden = YES;
    _arrowBtn.selected = model.isSpread;
    _titleLbl.text = kMeUnNilStr(model.classify_name);
    _titleLbl.font = [UIFont systemFontOfSize:18.0];
}

- (void)setUIWithSectionTitle:(NSString *)title isAdd:(BOOL)isAdd{
    _arrowBtn.hidden = YES;
    _editBtn.hidden = isAdd;
    _lineView.hidden = YES;
    _titleLbl.text = title;
    _titleLbl.font = [UIFont systemFontOfSize:18.0];
}

- (IBAction)downBtnAction:(id)sender {
    _arrowBtn.selected = !_arrowBtn.selected;
    kMeCallBlock(_tapBlock,_arrowBtn.selected);
}
- (IBAction)editAction:(id)sender {
    kMeCallBlock(_tapBlock,YES);
}

@end
