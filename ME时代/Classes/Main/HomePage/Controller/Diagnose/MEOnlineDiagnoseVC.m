//
//  MEOnlineDiagnoseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineDiagnoseVC.h"
#import "MEBlockTextField.h"

@interface MEOnlineDiagnoseVC ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) MEBlockTextField *nameTF;
@property (nonatomic, strong) MEBlockTextField *telephoneTF;
@property (nonatomic, assign) BOOL hasDiagnosed;

@end

@implementation MEOnlineDiagnoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在线诊断";
    [self.view addSubview:self.bgView];
    
    UILabel *nameLbl = [self createLabelWithTitle:@"姓名"];
    nameLbl.frame = CGRectMake(15, 10, 24, 17);
    [self.bgView addSubview:nameLbl];
    
    self.nameTF = [[MEBlockTextField alloc] initWithFrame:CGRectMake(68, 10, 135, 18)];
    self.nameTF.placeholder = @" 请输入姓名";
    self.nameTF.font = [UIFont systemFontOfSize:10.0];
    kMeWEAKSELF
    self.nameTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if ([str length] >= 8) {
            str = [str substringToIndex:7];
            [strongSelf.view endEditing:YES];
        }
    };
    self.nameTF.layer.borderWidth = 1.0;
    self.nameTF.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    [self.bgView addSubview:self.nameTF];
    
    UILabel *phoneLbl = [self createLabelWithTitle:@"手机号"];
    phoneLbl.frame = CGRectMake(15, 38, 36, 17);
    [self.bgView addSubview:phoneLbl];
    
    self.telephoneTF = [[MEBlockTextField alloc] initWithFrame:CGRectMake(68, 38, 135, 18)];
    self.telephoneTF.font = [UIFont systemFontOfSize:10.0];
    self.telephoneTF.layer.borderWidth = 1.0;
    self.telephoneTF.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    self.telephoneTF.placeholder = @" 请输入手机号";
    self.telephoneTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if ([str length] >= 11) {
            str = [str substringToIndex:10];
            [strongSelf.view endEditing:YES];
        }
    };
    [self.bgView addSubview:self.telephoneTF];
    
    UILabel *tipsLbl = [self createLabelWithTitle:@"是否在线咨询过"];
    tipsLbl.frame = CGRectMake(15, 65, 84, 17);
    [self.bgView addSubview:tipsLbl];
    
    UIButton *confirmBtn = [self createButtonWithTitle:@"是" font:10.0 frame:CGRectMake(226*kMeFrameScaleX(), 65, 38, 17) tag:1];
    confirmBtn.selected = YES;
    confirmBtn.backgroundColor = [UIColor whiteColor];
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFD5D5"].CGColor;
    [self.bgView addSubview:confirmBtn];
    
    UIButton *denyBtn = [self createButtonWithTitle:@"否" font:10.0 frame:CGRectMake(289*kMeFrameScaleX(), 65, 38, 17) tag:2];
    [self.bgView addSubview:denyBtn];
    
    UIButton *nextBtn = [self createButtonWithTitle:@"下一步" font:15.0 frame:CGRectMake(15, SCREEN_HEIGHT-19-32, SCREEN_WIDTH-30, 32) tag:10];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFD5D5"]];
    [self.view addSubview:nextBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark -- Action
- (void)tapAction {
    [self.view endEditing:YES];
}
- (void)btnDidClick:(UIButton *)sender {
    if (sender.tag == 10) {
        if(![MECommonTool isValidPhoneNum:self.telephoneTF.text]){
            [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
        }else {
            
        }
    }else {
        for (id obj in self.bgView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.selected = NO;
                btn.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
            }
        }
        sender.selected = YES;
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = [UIColor colorWithHexString:@"#FFD5D5"].CGColor;
        if (sender.tag == 1) {
            self.hasDiagnosed = YES;
        }else {
            self.hasDiagnosed = NO;
        }
    }
}

#pragma mark -- setter&&getter
- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = kME333333;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font frame:(CGRect)frame tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFD5D5"] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
    btn.layer.cornerRadius = frame.size.height/2.0;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, kMeNavBarHeight + 20, SCREEN_WIDTH-30, 92)];
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
