//
//  MECustomBuyCourseView.m
//  志愿星
//
//  Created by gao lei on 2019/9/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomBuyCourseView.h"

#define BGViewWidth (270*(kMeFrameScaleX()>1?kMeFrameScaleX():1))
#define BGViewHeight (174*(kMeFrameScaleX()>1?kMeFrameScaleX():1))

@interface MECustomBuyCourseView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeBasicBlock buyBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;
@property (nonatomic, strong) NSString *title;

@end

@implementation MECustomBuyCourseView

- (void)dealloc{
    NSLog(@"MECustomBuyCourseView dealloc");
}
//购买课程
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        self.title = title;
        [self setUIWithTitle:title content:content];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title content:(NSString *)content{
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    CGFloat titleHeight = [[NSString stringWithFormat:@"购买《%@》",title] boundingRectWithSize:CGSizeMake(BGViewWidth-56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.height;
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 15, BGViewWidth-56, titleHeight>28?titleHeight:28)];
    titleLbl.text = [NSString stringWithFormat:@"购买《%@》",title];
    titleLbl.textColor = kME333333;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.numberOfLines = 0;
    [self.bgView addSubview:titleLbl];
    
    UIView *line1 = [self createLineViewWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame)+15, BGViewWidth, 1)];
    [self.bgView addSubview:line1];
    
    UIButton *buyBtn = [self createButtonWithTitle:[NSString stringWithFormat:@"%@元购买本课程",content] color:[UIColor colorWithHexString:@"#FE4B77"] tag:1];
    buyBtn.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), BGViewWidth, 58*kMeFrameScaleX());
    [self.bgView addSubview:buyBtn];
    
    UIView *line2 = [self createLineViewWithFrame:CGRectMake(0, CGRectGetMaxY(buyBtn.frame), BGViewWidth, 1)];
    [self.bgView addSubview:line2];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" color:[UIColor blackColor] tag:2];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(line2.frame), BGViewWidth, 58*kMeFrameScaleX());
    [self.bgView addSubview:cancelBtn];
}

//购买VIP
- (instancetype)initWithTitle:(NSString *)title confirmBtn:(NSString *)confirmBtn superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        self.title = title;
        [self setUIWithTitle:title confirmBtn:confirmBtn];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title confirmBtn:(NSString *)confirmBtn{
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    self.bgView.frame = CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-132)/2, BGViewWidth, 132);
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BGViewWidth, 80)];
    titleLbl.text = title;
    titleLbl.textColor = kME333333;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:20];
    [self.bgView addSubview:titleLbl];
    
    UIView *line1 = [self createLineViewWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame), BGViewWidth, 1)];
    line1.backgroundColor = kME999999;
    [self.bgView addSubview:line1];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" color:[UIColor blackColor] tag:2];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), (BGViewWidth-1)/2, 51);
    [self.bgView addSubview:cancelBtn];
    
    UIView *line2 = [self createLineViewWithFrame:CGRectMake((BGViewWidth-1)/2, CGRectGetMaxY(line1.frame), 1, 51)];
    line2.backgroundColor = kME999999;
    [self.bgView addSubview:line2];
    
    UIButton *buyBtn = [self createButtonWithTitle:confirmBtn.length>0?confirmBtn:@"购买VIP" color:[UIColor colorWithHexString:@"#FE4B77"] tag:1];
    buyBtn.frame = CGRectMake((BGViewWidth-1)/2+1, CGRectGetMaxY(line1.frame), (BGViewWidth-1)/2, 51);
    [self.bgView addSubview:buyBtn];
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
        kMeCallBlock(_buyBlock);
    }else if (sender.tag == 2) {
        kMeCallBlock(_cancelBlock);
    }
    [self hide];
}

- (UIView *)createLineViewWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithHexString:@"#A4A4A4"];
    return line;
}

- (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    btn.tag = tag;
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
        CGFloat titleHeight = [[NSString stringWithFormat:@"购买《%@》",self.title] boundingRectWithSize:CGSizeMake(BGViewWidth-56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.height;
        CGFloat bgViewHeight = titleHeight>28?(BGViewHeight-28+titleHeight):BGViewHeight;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-bgViewHeight)/2, BGViewWidth, bgViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

#pragma mark - Public API
+ (void)showCustomBuyCourseViewWithTitle:(NSString *)title content:(NSString *)content buyBlock:(kMeBasicBlock)buyBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    MECustomBuyCourseView *view = [[MECustomBuyCourseView alloc] initWithTitle:title content:content superView:superView];
    view.buyBlock = buyBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

//购买Vip
+ (void)showCustomBuyVIPViewWithTitle:(NSString *)title confirmBtn:(NSString *)confirmBtn buyBlock:(kMeBasicBlock)buyBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    MECustomBuyCourseView *view = [[MECustomBuyCourseView alloc] initWithTitle:title confirmBtn:confirmBtn superView:superView];
    view.buyBlock = buyBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
