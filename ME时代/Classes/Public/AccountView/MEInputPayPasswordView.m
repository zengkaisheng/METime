//
//  MEInputPayPasswordView.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEInputPayPasswordView.h"

#define BGViewWidth (308*(kMeFrameScaleX()>1?kMeFrameScaleX():1))
#define BGViewHeight (224*(kMeFrameScaleX()>1?kMeFrameScaleX():1))

@interface MEInputPayPasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;
@property (nonatomic, copy) kMeBasicBlock forgetBlock;
@property (nonatomic, copy) kMeTextBlock confirmBlock;

@property (nonatomic, strong) UITextField *passTF;

@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UITextField *tf5;
@property (nonatomic, strong) UITextField *tf6;

@end


@implementation MEInputPayPasswordView

- (void)dealloc{
    NSLog(@"MEInputPayPasswordView dealloc");
}

- (instancetype)initWithTitle:(NSString *)title money:(NSString *)money superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithTitle:title money:money];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title money:(NSString *)money{
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 10, 33, 33);
    [cancelBtn setImage:[UIImage imageNamed:@"stortdel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancelBtn];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, BGViewWidth-100, 21)];
    titleLbl.text = @"请输入支付密码";
    titleLbl.textColor = kME333333;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:titleLbl];
    
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 53, BGViewWidth-40, 17)];
    contentLbl.text = title.length>0?title:@"课程购买";
    contentLbl.textColor = kME333333;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    contentLbl.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:contentLbl];
    
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 78, BGViewWidth-40, 26)];
    moneyLbl.text = [NSString stringWithFormat:@"￥%@",kMeUnNilStr(money)];
    moneyLbl.textColor = kMEPink;
    moneyLbl.textAlignment = NSTextAlignmentCenter;
    moneyLbl.font = [UIFont boldSystemFontOfSize:19];
    [self.bgView addSubview:moneyLbl];
    
    _passTF = [[UITextField alloc] init];
    _passTF.frame = CGRectMake(0, 0, 0, 0);
    _passTF.delegate = self;
    _passTF.keyboardType = UIKeyboardTypeNumberPad;
    [_passTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bgView addSubview:_passTF];
    
    CGFloat itemW = 31;
    CGFloat spec = (BGViewWidth-27*2-itemW*6)/5;
    for (int i = 0; i < 6; i++) {
        UITextField *textF = [self createTextFieldWithFrame:CGRectMake(27+(itemW+spec)*i, CGRectGetMaxY(moneyLbl.frame)+9, itemW, itemW)];
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
        [self.bgView addSubview:textF];
    }
    
    UIButton *forgetBtn = [self createButtonWithTitle:@"忘记密码?"];
    forgetBtn.frame = CGRectMake(BGViewWidth-22-78, CGRectGetMaxY(moneyLbl.frame)+47, 78, 31);
    [self.bgView addSubview:forgetBtn];
    
    [_passTF becomeFirstResponder];
}
#pragma mark -- Action
- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)cancelBtnAction {
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick {
    kMeCallBlock(_forgetBlock);
    [self hide];
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
            [self.bgView endEditing:YES];
            break;
        default:
            break;
    }
    if (_field.text.length >= 6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            kMeCallBlock(self.confirmBlock,kMeUnNilStr(_field.text));
            [self hide];
        });
    }
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame {
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.borderStyle = UITextBorderStyleNone;
    [tf setSecureTextEntry:YES];
    tf.enabled = NO;
    tf.layer.cornerRadius = 5;
    
    tf.layer.borderColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:1.0].CGColor;
    tf.layer.borderWidth = 0.2;
    tf.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    tf.layer.shadowOffset = CGSizeMake(0,3);
    tf.layer.shadowRadius = 6;
    tf.layer.shadowOpacity = 1;
    return tf;
}

- (UIButton *)createButtonWithTitle:(NSString *)title  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    [btn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        [_maskView addGestureRecognizer:gesmask];
    }
    return _maskView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-BGViewHeight)/2, BGViewWidth, BGViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 14;
    }
    return _bgView;
}


#pragma mark - Public API
+ (void)showInputPayPasswordViewWithTitle:(NSString *)title money:(NSString *)money confirmBlock:(kMeTextBlock)confirmBlock forgetBlock:(kMeBasicBlock)forgetBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    MEInputPayPasswordView *view = [[MEInputPayPasswordView alloc] initWithTitle:title money:money superView:superView];
    view.confirmBlock = confirmBlock;
    view.forgetBlock = forgetBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
