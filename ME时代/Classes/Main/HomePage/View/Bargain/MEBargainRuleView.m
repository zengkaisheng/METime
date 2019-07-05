//
//  MEBargainRuleView.m
//  ME时代
//
//  Created by gao lei on 2019/7/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainRuleView.h"

#define BGViewWidth (270*(kMeFrameScaleY()>1?kMeFrameScaleY():1))
#define BGViewHeight (370*(kMeFrameScaleY()>1?kMeFrameScaleY():1))

@interface MEBargainRuleView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;

@end

@implementation MEBargainRuleView

- (void)dealloc{
    NSLog(@"MEBargainRuleView dealloc");
}

- (instancetype)initWithTitle:(NSString *)title superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithTitle:title];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    UIButton *cancelBtn = [self createButtonWithImage:@"qaj"];
    cancelBtn.frame = CGRectMake((SCREEN_WIDTH-44)/2, CGRectGetMaxY(self.bgView.frame)+16, 44, 44);
    [self.maskView addSubview:cancelBtn];
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 22, BGViewWidth-26, 17)];
    titleLbl.text = @"使用规则";
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleLbl];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.text = title;
    tv.textColor = kME666666;
    tv.font = [UIFont systemFontOfSize:12.0];
    tv.frame = CGRectMake(20, 54, BGViewWidth-40, BGViewHeight-54-31);
    tv.editable = NO;
    [self.bgView addSubview:tv];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick {
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (UIButton *)createButtonWithImage:(NSString *)image  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
        _maskView.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        //        [_maskView addGestureRecognizer:gesmask];
    }
    return _maskView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-BGViewHeight)/2, BGViewWidth, BGViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 4;
    }
    return _bgView;
}

#pragma mark - Public API
+ (void)showBargainRuleViewWithTitle:(NSString *)title cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    MEBargainRuleView *view = [[MEBargainRuleView alloc]initWithTitle:title superView:superView];
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
