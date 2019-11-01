//
//  MEDiagnoseOptionsCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseOptionsCell.h"
#import "MEDiagnoseQuestionModel.h"
#import "MEBlockTextView.h"
#import "MELivingHabitListModel.h"
#import "MECustomerFollowTypeModel.h"
#import "MEExpenseSourceModel.h"

@interface MEDiagnoseOptionsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet MEBlockTextView *textView;


@end

@implementation MEDiagnoseOptionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEOptionsSubModel *)model{
    _selectImageView.hidden = NO;
    _titleLbl.hidden = NO;
    _textView.hidden = YES;
    if (model.isSelected) {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionSelected"];
    }else {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionNormal"];
    }
    _titleLbl.text = kMeUnNilStr(model.option);
}

- (void)setUIWithContent:(NSString *)content {
    _selectImageView.hidden = YES;
    _titleLbl.hidden = YES;
    _textView.hidden = NO;
    _textView.text = content;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.contentBlock = ^(NSString *str) {
        kMeCallBlock(self->_contentBlock,str);
    };
}

- (void)setUIWithHabitsModel:(MELivingHabitsOptionModel *)model {
    _selectImageView.hidden = NO;
    _titleLbl.hidden = NO;
    _textView.hidden = YES;
    if (model.isSelected) {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionSelected"];
    }else {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionNormal"];
    }
    _titleLbl.text = kMeUnNilStr(model.habit);
}

- (void)setUIWithFollowTypeModel:(MECustomerFollowTypeModel *)model {
    _selectImageView.hidden = NO;
    _titleLbl.hidden = NO;
    _textView.hidden = YES;
    if (model.isSelected) {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionSelected"];
    }else {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionNormal"];
    }
    _titleLbl.text = kMeUnNilStr(model.follow_type_title);
}

- (void)setUIWithExpenseSourceModel:(MEExpenseSourceModel *)model {
    _selectImageView.hidden = NO;
    _titleLbl.hidden = NO;
    _textView.hidden = YES;
    if (model.isSelected) {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionSelected"];
    }else {
        _selectImageView.image = [UIImage imageNamed:@"icon_questionNormal"];
    }
    if (kMeUnNilStr(model.option).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.option);
    }
    if (kMeUnNilStr(model.nature).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.nature);
    }
}

@end
