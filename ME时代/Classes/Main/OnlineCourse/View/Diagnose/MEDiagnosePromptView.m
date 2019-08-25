//
//  MEDiagnosePromptView.m
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnosePromptView.h"

#define kMEXScale (kMeFrameScaleY()>1?kMeFrameScaleY():1)
#define kMEYScale (kMeFrameScaleY()>1?kMeFrameScaleY():1)
#define PromptViewWidth (285*kMEXScale)
#define PromptViewHeight (185*kMEYScale)

@interface MEDiagnosePromptView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock successBlock;

@end


@implementation MEDiagnosePromptView

- (void)dealloc{
    NSLog(@"MEDiagnosePromptView dealloc");
}

- (instancetype)initWithSuperView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 42, PromptViewWidth-30, 21)];
    titleLbl.text = @"恭喜您！";
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleLbl];
    
    //内容
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 79, PromptViewWidth-30, 21)];
    contentLbl.text = @"今日可免费获取您的专属店铺诊断报告";
    contentLbl.textColor = kME333333;
    contentLbl.font = [UIFont systemFontOfSize:15];
    contentLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:contentLbl];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@"开始诊断" frame:CGRectMake((PromptViewWidth-96*kMEXScale)/2, 117*kMEYScale, 96*kMEXScale, 27*kMEYScale)];
    [self.bgView addSubview:cancelBtn];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    [self hide];
}

- (void)btnDidClick {
    kMeCallBlock(_successBlock);
    [self hide];
}

- (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setBackgroundColor:kMEPink];
    btn.layer.cornerRadius = frame.size.height/2.0;
    [btn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.75;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        [_maskView addGestureRecognizer:gesmask];
    }
    return _maskView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-PromptViewWidth)/2, (SCREEN_HEIGHT-PromptViewHeight)/2, PromptViewWidth, PromptViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}

#pragma mark - Public API
+ (void)showDiagnosePromptViewWithSuccessBlock:(kMeBasicBlock)successBlock superView:(UIView*)superView {
    MEDiagnosePromptView *view = [[MEDiagnosePromptView alloc] initWithSuperView:superView];
    view.successBlock = successBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
