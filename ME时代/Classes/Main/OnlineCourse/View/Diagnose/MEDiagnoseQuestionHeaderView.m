//
//  MEDiagnoseQuestionHeaderView.m
//  志愿星
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
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowBtn;

@end

@implementation MEDiagnoseQuestionHeaderView

- (void)setUIWithTitle:(NSString *)title font:(CGFloat)font isHiddenBtn:(BOOL)isHidden{
    _arrowBtn.hidden = isHidden;
    _editBtn.hidden = _lineView.hidden = YES;
    _titleLbl.text = title;
    _titleLbl.font = [UIFont boldSystemFontOfSize:font];
    _arrowImageV.hidden = _rightArrowBtn.hidden = YES;
}

- (void)setUIWithQuestionModel:(MEReportQuestionsModel *)model {
    _arrowBtn.hidden = NO;
    _editBtn.hidden = _lineView.hidden = YES;
    _arrowBtn.selected = model.isSpread;
    _titleLbl.text = kMeUnNilStr(model.classify_name);
    _titleLbl.font = [UIFont boldSystemFontOfSize:18.0];
    _arrowImageV.hidden = _rightArrowBtn.hidden = YES;
}

- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model {
    _arrowBtn.hidden = NO;
    _editBtn.hidden = _lineView.hidden = YES;
    _arrowBtn.selected = model.isSpread;
    _titleLbl.text = kMeUnNilStr(model.classify_name);
    _titleLbl.font = [UIFont boldSystemFontOfSize:18.0];
    _arrowImageV.hidden = _rightArrowBtn.hidden = YES;
}

- (void)setUIWithSectionTitle:(NSString *)title isAdd:(BOOL)isAdd{
    _arrowBtn.hidden = YES;
    _editBtn.hidden = isAdd;
    _lineView.hidden = YES;
    _titleLbl.text = title;
    _titleLbl.font = [UIFont systemFontOfSize:18.0];
    _arrowImageV.hidden = _rightArrowBtn.hidden = YES;
}

- (void)setIsShowArrow:(BOOL)isShowArrow{
    _isShowArrow = isShowArrow;
    _arrowImageV.hidden = _rightArrowBtn.hidden = !isShowArrow;
}

- (void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    _lineView.hidden = !isShowLine;
}

- (void)setUIWithSectionTitle:(NSString *)title isHeader:(BOOL)isHeader {
    _arrowBtn.hidden = YES;
    if (isHeader) {
        _titleLbl.text = title;
        _titleLbl.font = [UIFont systemFontOfSize:18.0];
        _editBtn.hidden = YES;
        if ([title isEqualToString:@"基本资料"]) {
            _arrowImageV.hidden = _rightArrowBtn.hidden = YES;
        }else {
            _arrowImageV.hidden = _rightArrowBtn.hidden = NO;
        }
        _lineView.hidden = NO;
    }else {
        _titleLbl.text = @" ";
        _editBtn.hidden = NO;
        _arrowImageV.hidden = _rightArrowBtn.hidden = YES;
        [_editBtn setTitle:title.length>0?title:@"添加" forState:UIControlStateNormal];
        _lineView.hidden = YES;
    }
}

- (IBAction)downBtnAction:(id)sender {
    _arrowBtn.selected = !_arrowBtn.selected;
    kMeCallBlock(_tapBlock,_arrowBtn.selected);
}
- (IBAction)editAction:(id)sender {
    kMeCallBlock(_tapBlock,YES);
}
- (IBAction)rightArrowBtnAction:(id)sender {
    kMeCallBlock(_tapBlock,YES);
}

@end
