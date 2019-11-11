//
//  MEApplyOrganizationCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEApplyOrganizationCell.h"
#import "MEAddCustomerInfoModel.h"

@interface MEApplyOrganizationCell ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *downImageV;

@property (nonatomic, assign) NSInteger maxCount;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLbl;

@end


@implementation MEApplyOrganizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    
    self.downImageV.hidden = YES;
    self.uploadBtn.hidden = YES;
    self.reviewBtn.hidden = YES;
    self.checkBtn.hidden = YES;
    self.textView.hidden = YES;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.placeHolderLbl.hidden = YES;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithCustomerModel:(MEAddCustomerInfoModel *)model {
    _titleLbl.text = kMeUnNilStr(model.title);
    self.downImageV.hidden = model.isHideArrow;
    if (model.isTextView) {
        self.textView.hidden = NO;
        self.textField.hidden = YES;
        self.uploadBtn.hidden = YES;
        self.reviewBtn.hidden = YES;
        self.checkBtn.hidden = YES;
        self.placeHolderLbl.hidden = kMeUnNilStr(model.value).length>0?YES:NO;
        self.placeHolderLbl.text = kMeUnNilStr(model.placeHolder);
        self.textView.text = kMeUnNilStr(model.value);
        self.maxCount = model.maxInputWord>0?model.maxInputWord:50;
    }else {
        self.textView.hidden = YES;
        self.placeHolderLbl.hidden = YES;
        if (model.isTextField) {
            self.textField.hidden = NO;
            self.uploadBtn.hidden = YES;
            self.reviewBtn.hidden = YES;
            self.checkBtn.hidden = YES;
            if (!model.isHideArrow) {
                self.textField.enabled = NO;
            }else {
                self.textField.enabled = YES;
            }
            self.textField.placeholder = kMeUnNilStr(model.placeHolder);
            self.maxCount = model.maxInputWord>0?model.maxInputWord:50;
            if (model.isNumberType) {
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
            }else {
                self.textField.keyboardType = UIKeyboardTypeDefault;
            }
            self.textField.text = kMeUnNilStr(model.value);
            
        }else {
            self.textField.hidden = YES;
            self.uploadBtn.hidden = NO;
            self.reviewBtn.hidden = NO;
            self.checkBtn.hidden = !model.isCanCheck;
            if (model.image != nil) {
                [self.reviewBtn setBackgroundImage:model.image forState:UIControlStateNormal];
            }else {
                [self.reviewBtn setBackgroundImage:[UIImage imageNamed:@"icon_review"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - uitextFiled delegate method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //去除空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    if (textField == self.textField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.textField.text.length >= self.maxCount) {
            [self.textField endEditing:YES];
            self.textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length)];
            if ([_titleLbl.text isEqualToString:@"手机号"]) {
                if (![MECommonTool isValidPhoneNum:self.textField.text]) {
                    [MECommonTool showMessage:@"手机号码格式不正确" view:kMeCurrentWindow];
                    return YES;
                }
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    kMeCallBlock(_reloadBlock);
    return YES;
}
#pragma mark -- textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLbl.hidden = textView.text.length>0?YES:NO;
    kMeCallBlock(_textBlock,self.textView.text);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.placeHolderLbl.hidden = YES;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    if (text.length == 0 && range.location == 0) {
        self.placeHolderLbl.hidden = NO;
    }else{
        self.placeHolderLbl.hidden =YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (text.length == 0 && range.location == 0) {
            self.placeHolderLbl.hidden = NO;
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeHolderLbl.hidden = textView.text.length>0?YES:NO;
    kMeCallBlock(_reloadBlock);
}

#pragma mark - select methods
- (void)textFieldChange {
    kMeCallBlock(_textBlock,self.textField.text);
}

- (IBAction)uploadAction:(id)sender {
    //上传
    kMeCallBlock(_indexBlock,0);
}
- (IBAction)reviewAction:(id)sender {
    //预览
    kMeCallBlock(_indexBlock,1);
}
- (IBAction)checkAction:(id)sender {
    //查看模板
    kMeCallBlock(_indexBlock,2);
}

@end
