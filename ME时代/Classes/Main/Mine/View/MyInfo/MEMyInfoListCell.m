//
//  MEMyInfoListCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyInfoListCell.h"
#import "MEAddCustomerInfoModel.h"

@interface MEMyInfoListCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblConsTrailing;
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation MEMyInfoListCell

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
    
    self.textField.hidden = YES;
    self.arrowImageV.hidden = YES;
    self.headerPic.hidden = YES;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithCustomerModel:(MEAddCustomerInfoModel *)model {
    if (model.isShowImage) {
        self.titleLbl.hidden = NO;
        _titleLbl.text = kMeUnNilStr(model.title);
        self.contentLbl.hidden = YES;
        self.arrowImageV.hidden = YES;
        self.textField.hidden = YES;
        self.headerPic.hidden = NO;
        kSDLoadImg(_headerPic, kMeUnNilStr(model.value));
    }else {
        if (model.isTextField) {
            self.titleLbl.hidden = YES;
            self.contentLbl.hidden = YES;
            self.arrowImageV.hidden = YES;
            self.headerPic.hidden = YES;
            self.textField.hidden = NO;
            self.textField.placeholder = kMeUnNilStr(model.placeHolder);
            self.maxCount = model.maxInputWord>0?model.maxInputWord:50;
            if (model.isNumberType) {
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
            }else {
                self.textField.keyboardType = UIKeyboardTypeDefault;
            }
            self.textField.text = kMeUnNilStr(model.value);
        }else {
            self.titleLbl.hidden = NO;
            self.contentLbl.hidden = NO;
            self.arrowImageV.hidden = model.isHideArrow;
            self.headerPic.hidden = YES;
            self.textField.hidden = YES;
            _titleLbl.text = kMeUnNilStr(model.title);
            self.contentLbl.text = kMeUnNilStr(model.value);
            if (model.isHideArrow) {
                _contentLblConsTrailing.constant = 22.0;
            }else {
                _contentLblConsTrailing.constant = 39.0;
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
            if ([_titleLbl.text isEqualToString:@"手机号码"]) {
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
    return YES;
}

#pragma mark - select methods
- (void)textFieldChange {
    kMeCallBlock(_textBlock,self.textField.text);
}

@end
