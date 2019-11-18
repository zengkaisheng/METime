//
//  METopUpTipsView.m
//  志愿星
//
//  Created by gao lei on 2019/9/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "METopUpTipsView.h"

#define BGViewWidth (310*(kMeFrameScaleX()>1?kMeFrameScaleX():1))
#define BGViewHeight (251*(kMeFrameScaleX()>1?kMeFrameScaleX():1))

@interface METopUpTipsView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock successBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;

@end

@implementation METopUpTipsView

- (void)dealloc{
    NSLog(@"METopUpTipsView dealloc");
}
//联通充值
- (instancetype)initWithPhone:(NSString *)phone money:(NSString *)money superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithPhone:phone money:money];
    }
    return self;
}

- (void)setUIWithPhone:(NSString *)phone money:(NSString *)money {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    CGFloat bgViewWidth = 270*(kMeFrameScaleY()>1?kMeFrameScaleY():1);
    CGFloat bgViewHeight = 194*(kMeFrameScaleY()>1?kMeFrameScaleY():1);
    self.bgView.frame = CGRectMake((SCREEN_WIDTH-bgViewWidth)/2, (SCREEN_HEIGHT-bgViewHeight)/2, bgViewWidth, bgViewHeight);
    //标题
    UILabel *titleLbl = [self createLabelWithTitle:@"充值" color:kME333333 font:18 textAlignment:NSTextAlignmentCenter frame:CGRectMake(30, 15, bgViewWidth-60, 25)];
    [self.bgView addSubview:titleLbl];
    
    UIView *line = [self createLineWithFrame:CGRectMake(0, 55, bgViewWidth, 1)];
    [self.bgView addSubview:line];
    //手机
    UILabel *phoneLbl = [self createLabelWithTitle:[NSString stringWithFormat:@"女神卡手机号：%@",phone] color:kME333333 font:16 textAlignment:NSTextAlignmentLeft frame:CGRectMake(20, CGRectGetMaxY(line.frame)+15, BGViewWidth-40, 25)];
    [self.bgView addSubview:phoneLbl];
    //提示
    UILabel *moneyLbl = [self createLabelWithTitle:[NSString stringWithFormat:@"充值金额：%@",money] color:kME333333 font:16 textAlignment:NSTextAlignmentLeft frame:CGRectMake(20, CGRectGetMaxY(phoneLbl.frame)+10, BGViewWidth-40, 25)];
    [self.bgView addSubview:moneyLbl];
    
    CGFloat btnWidth = (bgViewWidth-60)/2;
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" color:[UIColor blackColor] tag:1];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.borderWidth = 1.0;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelBtn.frame = CGRectMake(20, CGRectGetMaxY(moneyLbl.frame)+15, btnWidth, 32);
    [self.bgView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [self createButtonWithTitle:@"立即充值" color:[UIColor whiteColor] tag:2];
    confirmBtn.frame = CGRectMake(20+btnWidth+20, CGRectGetMaxY(moneyLbl.frame)+15, btnWidth, 32);
    [self.bgView addSubview:confirmBtn];
    
}


//联通订单支付
- (instancetype)initWithName:(NSString *)name phone:(NSString *)phone tips:(NSString *)tips superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithName:name phone:phone tips:tips];
    }
    return self;
}

- (void)setUIWithName:(NSString *)name phone:(NSString *)phone tips:(NSString *)tips {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    //标题
    UILabel *titleLbl = [self createLabelWithTitle:@"充值提示" color:[UIColor colorWithHexString:@"#313131"] font:18 textAlignment:NSTextAlignmentCenter frame:CGRectMake(30, 19, BGViewWidth-60, 25)];
    [self.bgView addSubview:titleLbl];
    //姓名
    UILabel *nameLbl = [self createLabelWithTitle:[NSString stringWithFormat:@"体验中心：%@",name] color:kME333333 font:18 textAlignment:NSTextAlignmentLeft frame:CGRectMake(28, CGRectGetMaxY(titleLbl.frame)+18, BGViewWidth-56, 25)];
    [self.bgView addSubview:nameLbl];
    //手机
    UILabel *phoneLbl = [self createLabelWithTitle:[NSString stringWithFormat:@"手机号：%@",phone] color:kME333333 font:18 textAlignment:NSTextAlignmentLeft frame:CGRectMake(28, CGRectGetMaxY(nameLbl.frame)+10, BGViewWidth-56, 25)];
    [self.bgView addSubview:phoneLbl];
    //提示
    UILabel *tipsLbl = [self createLabelWithTitle:tips color:kME333333 font:18 textAlignment:NSTextAlignmentLeft frame:CGRectMake(28, CGRectGetMaxY(phoneLbl.frame)+10, BGViewWidth-56, 25)];
    [self.bgView addSubview:tipsLbl];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@"知道了" color:[UIColor whiteColor] tag:1];
    cancelBtn.frame = CGRectMake(12, CGRectGetMaxY(tipsLbl.frame)+35, BGViewWidth-24, 40*kMeFrameScaleX());
    [self.bgView addSubview:cancelBtn];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick:(UIButton *)sender {
    if (sender.tag == 1) {
        kMeCallBlock(_cancelBlock);
    }else {
        kMeCallBlock(_successBlock);
    }
    [self hide];
}

- (UILabel *)createLabelWithTitle:(NSString *)title color:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment frame:(CGRect)frame{
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:frame];
    titleLbl.text = title;
    titleLbl.textColor = color;
    titleLbl.textAlignment = textAlignment;
    titleLbl.font = [UIFont systemFontOfSize:font];
    return titleLbl;
}

- (UIView *)createLineWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithHexString:@"#707070"];
    return line;
}

- (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    btn.tag = tag;
    btn.backgroundColor = kMEPink;
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
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
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

#pragma mark - Public API
+ (void)showTopUpTipsViewWithName:(NSString *)name phone:(NSString *)phone tips:(NSString *)tips cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    METopUpTipsView *view = [[METopUpTipsView alloc] initWithName:name phone:phone tips:tips superView:superView];
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

//充值操作
+ (void)showTopUpTipsViewWithPhone:(NSString *)phone money:(NSString *)money successBlock:(kMeBasicBlock)successBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    METopUpTipsView *view = [[METopUpTipsView alloc] initWithPhone:phone money:money superView:superView];
    view.successBlock = successBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
