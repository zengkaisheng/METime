//
//  MEDiagnoseQuestionHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseQuestionHeaderView.h"
#import "MEDiagnoseQuestionModel.h"

@interface MEDiagnoseQuestionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation MEDiagnoseQuestionHeaderView

- (void)setUIWithTitle:(NSString *)title {
    _titleLbl.text = title;
}

- (IBAction)downBtnAction:(id)sender {
}

@end
