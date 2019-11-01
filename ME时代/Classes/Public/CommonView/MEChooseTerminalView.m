//
//  MEChooseTerminalView.m
//  志愿星
//
//  Created by gao lei on 2019/5/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEChooseTerminalView.h"

#define kViewHeight 52
#define kLeftOffset 30
#define kRightOffset 42

@interface MEChooseTerminalView ()

@property (nonatomic, strong) UIView *topView;//终端显示
@property (nonatomic, strong) UIView *bottomView;//是否仅店员可见
@property (nonatomic, strong) UIView *chooseView;//是否仅店员可见

@end

@implementation MEChooseTerminalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.topView = [self createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kViewHeight) leftImage:@"icon_mobile" title:@"全部" isShowrightImage:YES];
    self.bottomView = [self createViewWithFrame:CGRectMake(0, kViewHeight, SCREEN_WIDTH, kViewHeight) leftImage:@"icon_visible" title:@"仅店员可见" isShowrightImage:NO];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
}

- (UIView *)createViewWithFrame:(CGRect)frame leftImage:(NSString *)leftImage title:(NSString *)title isShowrightImage:(BOOL)isShow{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    //左图标
    UIImage *img = [UIImage imageNamed:leftImage];
    UIImageView *leftImgV = [[UIImageView alloc] initWithImage:img];
    leftImgV.contentMode = UIViewContentModeCenter;
    
    leftImgV.frame = CGRectMake(kLeftOffset, (kViewHeight - 24)/2, 24, 24);
    [view addSubview:leftImgV];
    //文字
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImgV.frame) + 21, 19, 90 , 14)];
    titleLab.text = title;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    titleLab.attributedText = string;
    [view addSubview:titleLab];
    
    if (isShow) {
        //右图标
        UIImageView *rightImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
        rightImgV.frame = CGRectMake(SCREEN_WIDTH - kRightOffset - 7, 20, 7, 12);
        rightImgV.contentMode = UIViewContentModeCenter;
        [view addSubview:rightImgV];
        
        UIButton *selectedBtn = [[UIButton alloc] init];
        selectedBtn.frame = CGRectMake(63, 0, SCREEN_WIDTH - 63, kViewHeight);
        [selectedBtn addTarget:self action:@selector(chooseTerminalAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:selectedBtn];
    }else {
        self.chooseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kRightOffset - 115, 4, 120, 44)];
        UIButton *chooseBtn = [self createButtonWithTitle:@"是"];
        chooseBtn.selected = YES;
        chooseBtn.frame = CGRectMake(2, 2, 46, 40);
        UIButton *unchooseBtn = [self createButtonWithTitle:@"否"];
        unchooseBtn.frame = CGRectMake(120-46, 2, 46, 40);
        [self.chooseView addSubview:chooseBtn];
        [self.chooseView addSubview:unchooseBtn];
        [view addSubview:self.chooseView];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImgV.frame) + 19, kViewHeight - 1, SCREEN_WIDTH - CGRectGetMaxX(leftImgV.frame) - 19 - 27, 1)];
    lineView.backgroundColor = kMEe3e3e3;
    [view addSubview:lineView];
    
    return view;
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kME333333 forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size: 15]];
    [btn setImage:[UIImage imageNamed:@"goodMangerNoSelect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"goodMangerSelect"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    return btn;
}
//选择是否仅店员可见
- (void)btnDidClicked:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"是"]) {
        if (self.visiableBlock) {
            self.visiableBlock(YES);
        }
    }else if ([btn.titleLabel.text isEqualToString:@"否"]) {
        if (self.visiableBlock) {
            self.visiableBlock(NO);
        }
    }
    for (id obj in self.chooseView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
}

- (void)chooseTerminalAction {
    if (self.chooseBlock) {
        self.chooseBlock();
    }
}

- (void)setTerminalWithIndex:(NSInteger)index {
    for (id obj in self.topView.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *titleLab = (UILabel *)obj;
            switch (index) {
                case 0:
                    titleLab.text = @"全部";
                    break;
                case 1:
                    titleLab.text = @"APP";
                    break;
                case 2:
                    titleLab.text = @"小程序";
                    break;
                default:
                    break;
            }
        }
    }
}

@end
