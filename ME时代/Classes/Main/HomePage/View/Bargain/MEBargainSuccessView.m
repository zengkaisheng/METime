//
//  MEBargainSuccessView.m
//  志愿星
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainSuccessView.h"

#define BGViewWidth (241*(kMeFrameScaleY()>1?kMeFrameScaleY():1))
#define BGViewHeight (315*(kMeFrameScaleY()>1?kMeFrameScaleY():1))

@interface MEBargainSuccessView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock shareBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;

@end

@implementation MEBargainSuccessView

- (void)dealloc{
    NSLog(@"MEBargainSuccessView dealloc");
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
    [self addSubview:self.bgImgView];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@""];
    cancelBtn.frame = CGRectMake(BGViewWidth - 44, 0, 44, 44);
    [self.bgImgView addSubview:cancelBtn];
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 179*kMeFrameScaleY(), BGViewWidth-26, 17)];
    titleLbl.text = @"砍价成功";
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgImgView addSubview:titleLbl];
    
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(34, CGRectGetMaxY(titleLbl.frame) + 13, BGViewWidth-68, 34)];
    contentLbl.text = title;
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.textAlignment = NSTextAlignmentCenter;
    contentLbl.textColor = kME333333;
    contentLbl.numberOfLines = 2;
    [self.bgImgView addSubview:contentLbl];
    
    UIButton *shareBtn = [self createButtonWithTitle:@"分享好友，一起砍价"];
    shareBtn.frame = CGRectMake(22, CGRectGetMaxY(contentLbl.frame) + 22, BGViewWidth-44, 30);
    [self.bgImgView addSubview:shareBtn];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"分享好友，一起砍价"]) {
        kMeCallBlock(_shareBlock);
    }else {
        kMeCallBlock(_cancelBlock);
    }
    [self hide];
}

- (UIButton *)createButtonWithTitle:(NSString *)title  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#FE5337"]];
        btn.layer.cornerRadius = 5;
    }
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
//        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
//        [_maskView addGestureRecognizer:gesmask];
    }
    return _maskView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bargainBGImage"]];
        _bgImgView.frame = CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-BGViewHeight)/2, BGViewWidth, BGViewHeight);
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

#pragma mark - Public API
+ (void)showBargainSuccessWithTitle:(NSString *)title shareBlock:(kMeBasicBlock)shareBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView{
    MEBargainSuccessView *view = [[MEBargainSuccessView alloc]initWithTitle:title superView:superView];
    view.shareBlock = shareBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
