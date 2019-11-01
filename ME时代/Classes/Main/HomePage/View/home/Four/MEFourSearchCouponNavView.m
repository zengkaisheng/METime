//
//  MEFourSearchCouponNavView.m
//  志愿星
//
//  Created by gao lei on 2019/6/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourSearchCouponNavView.h"

@interface MEFourSearchCouponNavView ()<UITextFieldDelegate>{
    CGFloat _top;
}

@property (nonatomic, strong)UIButton *backBtn;

@end

@implementation MEFourSearchCouponNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        [self addSubUIView];
    }
    return self;
}

- (void)addSubUIView{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    _top = ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 49 : 25);

    [self addSubview:self.backBtn];
    [self addSubview:self.searchTF];
    [self addSubview:self.cancelBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = kMEf5f4f4;
    [self addSubview:line];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        [self.cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    }else {
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        [self.cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    }else {
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        [self.cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    }else {
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.searchBlock) {
        self.searchBlock(str);
    }
    return YES;
}

- (void)cancelBtnAction{
    if ([self.cancelBtn.titleLabel.text isEqualToString:@"搜索"]) {
        [self.searchTF resignFirstResponder];
        NSString *str = [self.searchTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (self.searchBlock) {
            self.searchBlock(str);
        }
    }else {
        if (self.backBlock) {
            self.backBlock();
        }
    }
}

- (void)backBtnAction{
    if (self.backBlock) {
        self.backBlock();
    }
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10+32+10, _top, self.width-104, 36)];
        _searchTF.placeholder = @"搜索商品";
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.backgroundColor = kMEeeeeee;
        _searchTF.layer.cornerRadius = 18;
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 36)];
        leftV.backgroundColor = kMEeeeeee;
        leftV.layer.cornerRadius = 18;
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_nav_btn_search"]];
        imgV.frame = CGRectMake(18, 9, 18, 18);
        [leftV addSubview:imgV];
        _searchTF.leftView = leftV;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}

- (UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [MEView btnWithFrame:CGRectMake(10, self.searchTF.top, 32, 32) Img:[UIImage imageNamed:@"inc-xz"]];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [MEView btnWithFrame:CGRectMake(self.searchTF.right, self.searchTF.top, 46, 36) Img:nil title:@"取消" target:self Action:@selector(cancelBtnAction)];
        [_cancelBtn setTitleColor:kMEPink forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancelBtn;
}


@end
