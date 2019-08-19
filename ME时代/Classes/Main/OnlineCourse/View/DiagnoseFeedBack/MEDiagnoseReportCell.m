//
//  MEDiagnoseReportCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseReportCell.h"
#import "MEDiagnoseReportDetailModel.h"

@interface MEDiagnoseReportCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionLbl;
@property (weak, nonatomic) IBOutlet UILabel *answerLbl;

@end

@implementation MEDiagnoseReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

//诊断问题
- (void)setUIWithDiagnosisModel:(MEReportDiagnosisModel *)model {
    _questionLbl.text = kMeUnNilStr(model.question);
    _answerLbl.text = kMeUnNilStr(model.option);
    if (kMeUnArr(model.options).count > 0) {
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        for (int i = 0; i < model.options.count; i++) {
            NSString *string = model.options[i];
            if (i < model.options.count-1) {
                [tempStr appendFormat:@"%@\n",string];
            }else {
                [tempStr appendFormat:@"%@",string];
            }
        }
        _answerLbl.text = [tempStr copy];
    }
    _answerLbl.textColor = kME666666;
}

//诊断分析
- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model {
    _questionLbl.text = kMeUnNilStr(model.analysis);
    _answerLbl.text = kMeUnNilStr(model.suggest);
    _answerLbl.textColor = kME333333;
}

@end
