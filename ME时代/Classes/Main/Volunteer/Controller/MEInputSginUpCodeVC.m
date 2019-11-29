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

@interface MEInputSginUpCodeVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *codeTF;

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
    
    self.codeTF = [[UITextField alloc] init];
    self.codeTF.frame = CGRectMake(0, 0, 0, 0);
    self.codeTF.delegate = self;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.codeTF];
    
    [self.codeTF becomeFirstResponder];
    
    CGFloat height = 30;
    if (IS_iPhone5S || IS_IPHONE_4S) {
        height = 0;
    }
    
    UILabel *titleLbl = [self createLabelWithTitle:@"请输入活动编码" font:[UIFont boldSystemFontOfSize:20] lineNum:1 textAlign:NSTextAlignmentCenter frame:CGRectMake(50, kMeNavBarHeight+43+height, SCREEN_WIDTH-100, 28)];
    [self.view addSubview:titleLbl];
    
    CGFloat itemW = 28;
    CGFloat space = 65;
    if (IS_IPHONE_4S || IS_iPhone5S) {
        space = 20;
    }
    for (int i = 0; i < 6; i++) {
        UITextField *textF = [self createTextFieldWithFrame:CGRectMake(space+(itemW+22)*i, CGRectGetMaxY(titleLbl.frame)+33, itemW, itemW)];
        textF.enabled = NO;
        switch (i) {
            case 0:
            {
                self.tf1 = textF;
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
    space = 77;
    if (IS_IPHONE_4S || IS_iPhone5S) {
        space = 30;
    }
    UILabel *oneLbl = [self createLabelWithTitle:@"1.活动编码为6位数字，由活动发布着告知" font:[UIFont systemFontOfSize:12] lineNum:1 textAlign:NSTextAlignmentLeft frame:CGRectMake(space, CGRectGetMaxY(centerLbl.frame)+18, SCREEN_WIDTH-2*space, 17)];
    [self.view addSubview:oneLbl];
    
    UILabel *twoLbl = [self createLabelWithTitle:@"2.活动编码请勿在公共场合，网络聊天室等渠道公开传播波。" font:[UIFont systemFontOfSize:12] lineNum:2 textAlign:NSTextAlignmentLeft frame:CGRectMake(space, CGRectGetMaxY(oneLbl.frame)+10, SCREEN_WIDTH-2*space, 34)];
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

#pragma mark - 文本框内容发生改变
- (void)textFieldDidChange:(UITextField*) sender {
    UITextField *_field = sender;
    switch (_field.text.length) {
        case 0:
            self.tf1.text = self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 1:
            self.tf1.text = [_field.text substringWithRange:NSMakeRange(0, 1)];
            self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 2:
            self.tf2.text = [_field.text substringWithRange:NSMakeRange(1, 1)];
            self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 3:
            self.tf3.text = [_field.text substringWithRange:NSMakeRange(2, 1)];
            self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 4:
            self.tf4.text = [_field.text substringWithRange:NSMakeRange(3, 1)];
            self.tf5.text = self.tf6.text = @"";
            break;
        case 5:
            self.tf5.text = [_field.text substringWithRange:NSMakeRange(4, 1)];
            self.tf6.text = @"";
            break;
        case 6:
            self.tf6.text = [_field.text substringWithRange:NSMakeRange(5, 1)];
            [self.view endEditing:YES];
            [self checkSignInCodeWithNetWork];
            break;
        default:
            break;
    }
}


#pragma mark -- Networking
//验证活动编码
- (void)checkSignInCodeWithNetWork {
    NSString *code = [NSString stringWithFormat:@"%@",kMeUnNilStr(self.codeTF.text)];
    if (code.length < 6 ) {
        [MECommonTool showMessage:@"您的活动编码格式不正确" view:kMeCurrentWindow];
        self.tf1.text = self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
        self.codeTF.text = @"";
        [self.codeTF becomeFirstResponder];
        return;
    }
    kMeWEAKSELF
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
        kMeSTRONGSELF
        [strongSelf.codeTF becomeFirstResponder];
    }];
}


@end
