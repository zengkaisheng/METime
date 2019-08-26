//
//  MECustomInputPhoneView.m
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomInputPhoneView.h"
#import "MEBlockTextField.h"

#define BGViewWidth (270*(kMeFrameScaleY()>1?kMeFrameScaleY():1))
#define BGViewHeight (186*(kMeFrameScaleY()>1?kMeFrameScaleY():1))

@interface MECustomInputPhoneView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) MEBlockTextField *textField;
@property (nonatomic, copy) kMeTextBlock saveBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;
@property (nonatomic, strong) NSString *contentTitle;

@end

@implementation MECustomInputPhoneView

- (void)dealloc{
    NSLog(@"MECustomInputPhoneView dealloc");
}

- (instancetype)initWithTitle:(NSString *)title contentTitle:(NSString *)contentTitle superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithTitle:title contentTitle:contentTitle];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title contentTitle:(NSString *)contentTitle{
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 30, BGViewWidth-56, 36)];
    titleLbl.text = title.length>0?title:@"输入手机号调取基本信息";
    titleLbl.textColor = kME333333;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:18];
    [self.bgView addSubview:titleLbl];
    
    self.textField = [[MEBlockTextField alloc] initWithFrame:CGRectMake(20, 73, BGViewWidth-40, 45)];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.borderStyle = UITextBorderStyleLine;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];
    
    UILabel *leftTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 54, 45)];
    leftTitleLbl.text = contentTitle.length>0?contentTitle:@"手机号:";
    leftTitleLbl.font = [UIFont systemFontOfSize:16];
    leftTitleLbl.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:leftTitleLbl];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.contentTitle = leftTitleLbl.text;
    [self.bgView addSubview:self.textField];
    
    UIButton *saveBtn = [self createButtonWithTitle:@"确认"];
    saveBtn.frame = CGRectMake((BGViewWidth-120)/2, CGRectGetMaxY(self.textField.frame) + 18, 120, 32);
    [self.bgView addSubview:saveBtn];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick:(UIButton *)sender {
    kMeCallBlock(_saveBlock,self.textField.text);
    [self hide];
}

- (UIButton *)createButtonWithTitle:(NSString *)title  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setBackgroundColor:kMEPink];
        btn.layer.cornerRadius = 16;
    }
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
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
        }else if (self.textField.text.length >= 11) {
            [self.textField endEditing:YES];
            self.textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length)];
            if ([self.contentTitle isEqualToString:@"手机号:"]) {
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

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
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
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}

#pragma mark - Public API
+ (void)showCustomInputPhoneViewWithTitle:(NSString *)title contentTitle:(NSString *)contentTitle saveBlock:(kMeTextBlock)saveBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    MECustomInputPhoneView *view = [[MECustomInputPhoneView alloc]initWithTitle:title contentTitle:contentTitle superView:superView];
    view.saveBlock = saveBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
