//
//  MECustomerAddInfoCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerAddInfoCell.h"
#import "MEAddCustomerInfoModel.h"

@interface MECustomerAddInfoCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) NSInteger maxCount;

@end


@implementation MECustomerAddInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.hidden = YES;
    self.imgArrow.hidden = YES;
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
    _lineView.hidden = model.isLastItem;
    if (model.isTextField) {
        self.contentLbl.hidden = YES;
        self.imgArrow.hidden = YES;
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
        self.textField.hidden = YES;
        self.contentLbl.hidden = NO;
        self.imgArrow.hidden = model.isHideArrow;
        self.contentLbl.text = kMeUnNilStr(model.value);
        self.contentLbl.textColor = kME333333;
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
