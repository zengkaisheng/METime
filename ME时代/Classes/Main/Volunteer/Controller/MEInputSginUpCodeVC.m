//
//  MEInputSginUpCodeVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEInputSginUpCodeVC.h"
#import "MESginUpActivityInfoModel.h"
#import "MESignUpDetailVC.h"
#import "MESignInTimerVC.h"
#import "MESignOutVC.h"

@interface MEInputSginUpCodeVC ()

@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UITextField *tf5;
@property (nonatomic, strong) UITextField *tf6;
@property (nonatomic, strong) MESginUpActivityInfoModel *model;

@end

@implementation MEInputSginUpCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动编码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = 30;
    if (IS_iPhone5S || IS_IPHONE_4S) {
        height = 0;
    }
    
    UILabel *titleLbl = [self createLabelWithTitle:@"请输入活动编码" font:[UIFont boldSystemFontOfSize:20] lineNum:1 textAlign:NSTextAlignmentCenter frame:CGRectMake(100, kMeNavBarHeight+43+height, SCREEN_WIDTH-200, 28)];
    [self.view addSubview:titleLbl];
    
    CGFloat itemW = 28;
    for (int i = 0; i < 6; i++) {
        UITextField *textF = [self createTextFieldWithFrame:CGRectMake(65+(itemW+22)*i, CGRectGetMaxY(titleLbl.frame)+33, itemW, itemW)];
        [textF addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        switch (i) {
            case 0:
            {
                self.tf1 = textF;
                [self.tf1 becomeFirstResponder];
            }
                break;
            case 1:
            {
                self.tf2 = textF;
            }
                break;
            case 2:
            {
                self.tf3 = textF;
            }
                break;
            case 3:
            {
                self.tf4 = textF;
            }
                break;
            case 4:
            {
                self.tf5 = textF;
            }
                break;
            case 5:
            {
                self.tf6 = textF;
            }
                break;
            default:
                break;
        }
        [self.view addSubview:textF];
    }
    
    UILabel *centerLbl = [self createLabelWithTitle:@"温馨提示" font:[UIFont boldSystemFontOfSize:20] lineNum:1 textAlign:NSTextAlignmentCenter frame:CGRectMake(100, CGRectGetMaxY(titleLbl.frame)+92+height, SCREEN_WIDTH-200, 21)];
    [self.view addSubview:centerLbl];
    
    UILabel *oneLbl = [self createLabelWithTitle:@"1.活动编码为6位数字，由活动发布着告知" font:[UIFont systemFontOfSize:12] lineNum:1 textAlign:NSTextAlignmentLeft frame:CGRectMake(77, CGRectGetMaxY(centerLbl.frame)+18, SCREEN_WIDTH-154, 17)];
    [self.view addSubview:oneLbl];
    
    UILabel *twoLbl = [self createLabelWithTitle:@"2.活动编码请勿在公共场合，网络聊天室等渠道公开传播波。" font:[UIFont systemFontOfSize:12] lineNum:2 textAlign:NSTextAlignmentLeft frame:CGRectMake(77, CGRectGetMaxY(oneLbl.frame)+10, SCREEN_WIDTH-154, 34)];
    [self.view addSubview:twoLbl];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volunteerSignImage"]];
    imgV.frame = CGRectMake(43, CGRectGetMaxY(twoLbl.frame)+49, SCREEN_WIDTH-86, 164*kMeFrameScaleX());
    [self.view addSubview:imgV];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font lineNum:(NSInteger)lineNum textAlign:(NSTextAlignment)textAlign frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.numberOfLines = lineNum;
    label.textAlignment = textAlign;
    label.textColor = [UIColor blackColor];
    return label;
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame {
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.borderStyle = UITextBorderStyleNone;
    tf.layer.cornerRadius = 5;
    
    tf.layer.borderColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:1.0].CGColor;
    tf.layer.borderWidth = 0.2;
    tf.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    tf.layer.shadowOffset = CGSizeMake(0,3);
    tf.layer.shadowRadius = 6;
    tf.layer.shadowOpacity = 1;
    return tf;
}

- (void)tfCodeTextDidChange:(UITextField *)textField {
    if (textField.text.length >= 1) {
        if ([textField isEqual:self.tf1]) {
            [self.tf2 becomeFirstResponder];
        }else if ([textField isEqual:self.tf2]) {
            [self.tf3 becomeFirstResponder];
        }else if ([textField isEqual:self.tf3]) {
            [self.tf4 becomeFirstResponder];
        }else if ([textField isEqual:self.tf4]) {
            [self.tf5 becomeFirstResponder];
        }else if ([textField isEqual:self.tf5]) {
            [self.tf6 becomeFirstResponder];
        }else if ([textField isEqual:self.tf6]) {
            self.tf6.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
            [self.view endEditing:YES];
            [self checkSignInCodeWithNetWork];
        }
    }else {
        if ([textField isEqual:self.tf6]) {
            [self.tf5 becomeFirstResponder];
        }else if ([textField isEqual:self.tf5]) {
            [self.tf4 becomeFirstResponder];
        }else if ([textField isEqual:self.tf4]) {
            [self.tf3 becomeFirstResponder];
        }else if ([textField isEqual:self.tf3]) {
            [self.tf2 becomeFirstResponder];
        }else if ([textField isEqual:self.tf2]) {
            [self.tf1 becomeFirstResponder];
        }
    }
}

#pragma mark -- Networking
//验证活动编码
- (void)checkSignInCodeWithNetWork {
    if (self.tf1.text <= 0 || self.tf2.text <= 0 || self.tf3.text <= 0 || self.tf4.text <= 0 || self.tf5.text <= 0 || self.tf6.text <= 0) {
        [MECommonTool showMessage:@"您的活动编码格式不正确" view:kMeCurrentWindow];
        self.tf1.text = self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
        [self.tf1 becomeFirstResponder];
        return;
    }
    kMeWEAKSELF
    NSString *code = [NSString stringWithFormat:@"%@%@%@%@%@%@",kMeUnNilStr(self.tf1.text),kMeUnNilStr(self.tf2.text),kMeUnNilStr(self.tf3.text),kMeUnNilStr(self.tf4.text),kMeUnNilStr(self.tf5.text),kMeUnNilStr(self.tf6.text)];
    [MEPublicNetWorkTool postCheckSignInCodeWithCode:code successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MESginUpActivityInfoModel mj_objectWithKeyValues:responseObject.data];
            if (strongSelf.model.is_sign_in == 1) {
                if (strongSelf.model.member_info.status == 2) {//已签退
                    MESignOutVC *vc = [[MESignOutVC alloc] initWithModel:strongSelf.model];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else {
                    MESignInTimerVC *vc = [[MESignInTimerVC alloc] initWithModel:strongSelf.model];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            }else {
                MESignUpDetailVC *vc = [[MESignUpDetailVC alloc] initWithModel:strongSelf.model];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }else{
            strongSelf.model = nil;
        }
    } failure:^(id object) {
    }];
}


@end
