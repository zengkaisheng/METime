//
//  MESginUpProtocolView.m
//  ME时代
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESginUpProtocolView.h"

#define BGViewWidth (256*(kMeFrameScaleX()>1?kMeFrameScaleX():1))
#define BGViewHeight (374)

@interface MESginUpProtocolView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock confirmBlock;
@property (nonatomic, strong) UIImageView *selectedImgV;
@property (nonatomic, strong) UIButton *protocolBtn;

@end

@implementation MESginUpProtocolView

- (void)dealloc{
    NSLog(@"MESginUpProtocolView dealloc");
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithTitle:title content:content];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title content:(NSString *)content {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 22, BGViewWidth-26, 28)];
    titleLbl.text = title;
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont boldSystemFontOfSize:20];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleLbl];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.text = content;
    tv.textColor = kME333333;
    tv.font = [UIFont systemFontOfSize:13.0];
    tv.frame = CGRectMake(22, 72, BGViewWidth-44, BGViewHeight-72-146);
    tv.editable = NO;
    [self.bgView addSubview:tv];
    
    self.selectedImgV = [[UIImageView alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(tv.frame)+31, 11, 11)];
    self.selectedImgV.image = [UIImage imageNamed:@"icon_delCollection_nor"];
    [self.bgView addSubview:self.selectedImgV];
    
    UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedImgV.frame)+7, CGRectGetMaxY(tv.frame)+29, 165, 16)];
    tipLbl.text = @"我已阅读，并同意签到诚信协议";
    tipLbl.font = [UIFont systemFontOfSize:11];
    tipLbl.textColor = kME333333;
    [self.bgView addSubview:tipLbl];
    
    self.protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.protocolBtn.frame = CGRectMake(42, CGRectGetMaxY(tv.frame)+24, BGViewWidth-84, 21);
    [self.protocolBtn addTarget:self action:@selector(protocolBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.protocolBtn];
    
    UIButton *sginUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(tipLbl.frame)+11, BGViewWidth-84, 37)];
    sginUpBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
    [sginUpBtn setTitle:@"签到" forState:UIControlStateNormal];
    [sginUpBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [sginUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sginUpBtn.layer.cornerRadius = 7;
    [sginUpBtn addTarget:self action:@selector(sginUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:sginUpBtn];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_confirmBlock);
    [self hide];
}

- (void)sginUpAction {
    if (self.protocolBtn.selected) {
        kMeCallBlock(_confirmBlock);
        [self hide];
    }else {
        [MECommonTool showMessage:@"请阅读并同意签到诚信协议" view:kMeCurrentWindow];
    }
}

- (void)protocolBtnDidClick:(UIButton *)sender {
    self.protocolBtn.selected = !self.protocolBtn.selected;
    if (self.protocolBtn.selected) {
        self.selectedImgV.image = [UIImage imageNamed:@"icon_diagnoseSuccess"];
    }else {
        self.selectedImgV.image = [UIImage imageNamed:@"icon_delCollection_nor"];
    }
}

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
//        _maskView.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        //        [_maskView addGestureRecognizer:gesmask];
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
+ (void)showSginUpProtocolViewWithTitle:(NSString *)title content:(NSString *)content confirmBlock:(kMeBasicBlock)confirmBlock superView:(UIView *)superView {
    MESginUpProtocolView *view = [[MESginUpProtocolView alloc]initWithTitle:title content:content superView:superView];
    view.confirmBlock = confirmBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
