//
//  MEOnlineDiagnoseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineDiagnoseVC.h"
#import "MECustomerMessageCollectVC.h"

@interface MEOnlineDiagnoseVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *telephoneTF;
@property (nonatomic, assign) BOOL hasDiagnosed;

@end

@implementation MEOnlineDiagnoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在线诊断";
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diagnose_bg"]];
    imgV.frame = CGRectMake(36, kMeNavBarHeight+22, 50, 49);
    [self.view addSubview:imgV];
    
    [self.view addSubview:self.bgView];
    
    UILabel *nameLbl = [self createLabelWithTitle:@"姓名"];
    nameLbl.frame = CGRectMake(55, 35, 36, 30);
    [self.bgView addSubview:nameLbl];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(108, 35, 180, 30)];
    self.nameTF.placeholder = @" 请输入姓名";
    self.nameTF.font = [UIFont systemFontOfSize:16.0];
    self.nameTF.returnKeyType = UIReturnKeyDone;
    self.nameTF.layer.borderWidth = 1.0;
    self.nameTF.cornerRadius = 5;
    self.nameTF.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    [self.bgView addSubview:self.nameTF];
    
    UILabel *phoneLbl = [self createLabelWithTitle:@"手机号"];
    phoneLbl.frame = CGRectMake(55, 82, 50, 30);
    [self.bgView addSubview:phoneLbl];
    
    self.telephoneTF = [[UITextField alloc] initWithFrame:CGRectMake(108, 82, 180, 30)];
    self.telephoneTF.font = [UIFont systemFontOfSize:16.0];
    self.telephoneTF.layer.borderWidth = 1.0;
    self.telephoneTF.cornerRadius = 5;
    self.telephoneTF.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    self.telephoneTF.placeholder = @" 请输入手机号";
    self.telephoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.bgView addSubview:self.telephoneTF];
    
    UILabel *tipsLbl = [self createLabelWithTitle:@"是否在线咨询过"];
    tipsLbl.frame = CGRectMake(55, 137, 100, 21);
    [self.bgView addSubview:tipsLbl];
    
    UIButton *confirmBtn = [self createButtonWithTitle:@"是" font:12.0 frame:CGRectMake(170*kMeFrameScaleX(), 135, 45, 24) tag:1];
    confirmBtn.selected = YES;
    confirmBtn.backgroundColor = kMEPink;
    [self.bgView addSubview:confirmBtn];
    
    UIButton *denyBtn = [self createButtonWithTitle:@"否" font:12.0 frame:CGRectMake(230*kMeFrameScaleX(), 135, 45, 24) tag:2];
    [self.bgView addSubview:denyBtn];
    
    UIButton *nextBtn = [self createButtonWithTitle:@"下一步" font:15.0 frame:CGRectMake(15, SCREEN_HEIGHT-200-40-kMeNavBarHeight, SCREEN_WIDTH-30, 40) tag:10];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF88A4"]];
    [self.view addSubview:nextBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    [self.nameTF addTarget:self action:@selector(nameTFTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.telephoneTF addTarget:self action:@selector(telephoneTFTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- Action
- (void)tapAction {
    [self.view endEditing:YES];
}
- (void)btnDidClick:(UIButton *)sender {
    if (sender.tag == 10) {
        if ([self.nameTF.text length] <= 0) {
            [MEShowViewTool showMessage:@"姓名不能为空！" view:self.view];
            return;
        }
        if(![MECommonTool isValidPhoneNum:self.telephoneTF.text]){
            [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
            return;
        }
        MECustomerMessageCollectVC *vc = [[MECustomerMessageCollectVC alloc] initWithName:self.nameTF.text phone:self.telephoneTF.text isBeen:self.hasDiagnosed?@"1":@"0"];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        for (id obj in self.bgView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.selected = NO;
                btn.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
            }
        }
        sender.selected = YES;
        sender.backgroundColor = kMEPink;
        if (sender.tag == 1) {
            self.hasDiagnosed = YES;
        }else {
            self.hasDiagnosed = NO;
        }
    }
}
#pragma mark - UITextField Action13168734537
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // text field 上实际字符长度
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (textField == self.telephoneTF) {
        return (strLength <= 11);
    }else if (textField == self.nameTF) {
        return (strLength <= 10);
    }
    return NO;
}

- (void)nameTFTextDidChange:(UITextField *)textField{
    if(textField.text.length > 10){
        textField.text = [textField.text substringWithRange:NSMakeRange(0,10)];
        [self.view endEditing:YES];
    }
}

- (void)telephoneTFTextDidChange:(UITextField *)textField{
    if(textField.text.length > 11){
        textField.text = [textField.text substringWithRange:NSMakeRange(0,11)];
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -- setter&&getter
- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = kME333333;
    label.font = [UIFont boldSystemFontOfSize:14];
    return label;
}

- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font frame:(CGRect)frame tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
    btn.layer.cornerRadius = frame.size.height/2.0;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(26, kMeNavBarHeight + 48, SCREEN_WIDTH-52, 202)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 3;
        _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _bgView.layer.masksToBounds = false;
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = false;
    }
    return _bgView;
}

@end
