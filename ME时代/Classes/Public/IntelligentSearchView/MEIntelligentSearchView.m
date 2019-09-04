//
//  MEIntelligentSearchView.m
//  ME时代
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEIntelligentSearchView.h"

#define BGViewWidth (256*(kMeFrameScaleY()>1?kMeFrameScaleY():1))
#define BGViewHeight (310*(kMeFrameScaleY()>1?kMeFrameScaleY():1))

@interface MEIntelligentSearchView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *btnCaner;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeIndexBlock tapBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;

@end

@implementation MEIntelligentSearchView

- (void)dealloc{
    NSLog(@"MEIntelligentSearchView dealloc");
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
    //图片
    UIImageView *topImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intelligentSearch"]];
    topImgV.frame = CGRectMake(0, 0, BGViewWidth, 135*(kMeFrameScaleY()>1?kMeFrameScaleY():1));
    [self.bgView addSubview:topImgV];
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(topImgV.frame)+15, BGViewWidth-26, 36)];
    titleLbl.text = title;
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.numberOfLines = 2;
    [self.bgView addSubview:titleLbl];
    
    UILabel *searchLbl = [[UILabel alloc] initWithFrame:CGRectMake((BGViewWidth-64)/2, CGRectGetMaxY(topImgV.frame) + 71, 64, 12)];
    searchLbl.text = @"搜索平台";
    searchLbl.font = [UIFont systemFontOfSize:12];
    searchLbl.textAlignment = NSTextAlignmentCenter;
    searchLbl.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self.bgView addSubview:searchLbl];
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(searchLbl.frame)-66, CGRectGetMidY(searchLbl.frame)-0.5, 66, 1)];
    leftV.backgroundColor = [UIColor colorWithHexString:@"#969696"];
    [self.bgView addSubview:leftV];
    
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchLbl.frame), CGRectGetMidY(searchLbl.frame)-0.5, 66, 1)];
    rightV.backgroundColor = [UIColor colorWithHexString:@"#969696"];
    [self.bgView addSubview:rightV];
    
    CGFloat itemW = BGViewWidth / 3;
    CGFloat itemH = 81;
    NSArray *btns = @[@{@"title":@"淘宝",@"image":@"thirdHomeTbC"},@{@"title":@"拼多多",@"image":@"thirdHomePdd"},@{@"title":@"京东",@"image":@"thirdHomeJd"}];
    for (int i = 0; i < btns.count; i++) {
        NSDictionary *dict = btns[i];
        UIButton *btn = [self createButtonWithTitle:dict[@"title"] image:dict[@"image"] tag:10+i];
        btn.frame = CGRectMake(itemW*i, CGRectGetMaxY(searchLbl.frame)+1, itemW, itemH);
        [btn setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:6];
        [self.bgView addSubview:btn];
    }
    
    [self addSubview:self.btnCaner];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideAction:(UIButton *)btn{
    [self hide];
    kMeCallBlock(self.tapBlock,100);
//    kMeCallBlock(_cancelBlock);
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    [self hide];
    kMeCallBlock(_cancelBlock);
}

- (void)btnDidClick:(UIButton *)sender {
    [self hide];
    if (self.tapBlock) {
        self.tapBlock(sender.tag-10);
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kME333333 forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTag:tag];
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
        _bgView.layer.cornerRadius = 6;
    }
    return _bgView;
}

- (UIButton *)btnCaner{
    if(!_btnCaner){
        _btnCaner = [MEView btnWithImg:kMeGetAssetImage(@"icon_cancel") title:@"" target:self Action:@selector(hideAction:)];
        _btnCaner.frame = CGRectMake(CGRectGetMaxX(self.bgView.frame)-24, CGRectGetMinY(self.bgView.frame)-47, 24, 47);
        _btnCaner.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _btnCaner;
}

#pragma mark - Public API

+ (void)ShowWithTitle:(NSString *)title tapBlock:(kMeIndexBlock)tapBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView{
    MEIntelligentSearchView *view = [[MEIntelligentSearchView alloc]initWithTitle:title superView:superView];
    view.tapBlock = tapBlock;
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
