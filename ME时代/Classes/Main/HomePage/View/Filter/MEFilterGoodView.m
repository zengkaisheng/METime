//
//  MEFilterGoodView.m
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEFilterGoodView.h"
#import <objc/runtime.h>

static char *const btnKey = "btnKey";

@interface MEFilterGoodView()

@property (nonatomic, strong) UICollectionView *collect;

@end

@implementation MEFilterGoodView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
//    _canSelect = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    UIView *mainView = [UIView new];
    mainView.backgroundColor = kMeColor(255, 255, 255);
    [self addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.top.equalTo(self);
    }];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = kMeColor(222, 222, 222);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(mainView);
        make.top.mas_equalTo(mainView.mas_bottom);
    }];
    NSArray *titleArr = @[@"全部",@"推荐",@"新品",@"价格"];
    for (int i = 0; i < 4; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArr[i] forState:UIControlStateNormal ];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [mainView addSubview:button];
        button.tag = kMeViewBaseTag+i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).offset(SCREEN_WIDTH/4*i);
            make.top.bottom.equalTo(mainView);
            make.width.mas_equalTo(SCREEN_WIDTH/4);
        }];
        if (i == _defaultSelectIndex) {
            button.selected = YES;
        }
        if (i == 3) {
            [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
            [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
            objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        }
    }
}

- (void)selectClick:(UIButton *)btn{
//    if(!_canSelect){
//        return;
//    }
    for (int i = 0; i<4 ;i++) {
        UIButton *button = [self viewWithTag:i+kMeViewBaseTag];
        button.selected = NO;
    }
    btn.selected = YES;
    ButtonClickType type = ButtonClickTypeNormal;
    if (btn.tag == kMeViewBaseTag + 3) {
        NSString *flag = objc_getAssociatedObject(btn, btnKey);
        if ([flag isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeUp;
        }else if ([flag isEqualToString:@"2"]){
            [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeDown;
        }
    }else{
        UIButton *button = [self viewWithTag:kMeViewBaseTag + 3];
        [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
        objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        type = ButtonClickTypeNormal;
    }
    if ([self.delegate respondsToSelector:@selector(selectTopButton:withIndex:withButtonType:)]) {
        [self.delegate selectTopButton:self withIndex:btn.tag-kMeViewBaseTag withButtonType:type];
    }
}

@end
