//
//  MEFilterClerkView.m
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEFilterClerkView.h"
#import <objc/runtime.h>

static char *const kMEFilterClerkViewKey = "MEFilterClerkViewKey";

@interface MEFilterClerkView()

@property (nonatomic, strong) UICollectionView *collect;

@end

@implementation MEFilterClerkView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
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
    NSArray *titleArr = @[@"转发数",@"阅读数",@"总佣金"];
    for (int i = 0; i < 3; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArr[i] forState:UIControlStateNormal ];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [mainView addSubview:button];
        button.tag = kMeViewBaseTag+i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).offset(SCREEN_WIDTH/3*i);
            make.top.bottom.equalTo(mainView);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        if (i == _defaultSelectIndex) {
            button.selected = YES;
            [button setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateNormal];
            [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
            objc_setAssociatedObject(button, kMEFilterClerkViewKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        }else{
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
            [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
            objc_setAssociatedObject(button, kMEFilterClerkViewKey, @"0", OBJC_ASSOCIATION_ASSIGN);
        }
    }
}

- (void)selectClick:(UIButton *)btn{
    for (int i = 0; i<3 ;i++) {
        UIButton *button = [self viewWithTag:i+kMeViewBaseTag];
        if(button == btn){
            continue;
        }
        button.selected = NO;
        [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
        [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
        objc_setAssociatedObject(button, kMEFilterClerkViewKey, @"0", OBJC_ASSOCIATION_ASSIGN);
    }
    btn.selected = YES;
    ButtonClickType type = ButtonClickTypeNormal;
    NSString *flag = objc_getAssociatedObject(btn, kMEFilterClerkViewKey);
    if ([flag isEqualToString:@"1"]) {
        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateNormal];
        objc_setAssociatedObject(btn, kMEFilterClerkViewKey, @"2", OBJC_ASSOCIATION_ASSIGN);
        type = ButtonClickTypeUp;
    }else if ([flag isEqualToString:@"2"] || [flag isEqualToString:@"0"] ){
        [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateNormal];
        objc_setAssociatedObject(btn, kMEFilterClerkViewKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        type = ButtonClickTypeDown;
    }
    if ([self.delegate respondsToSelector:@selector(selectTopButton:withIndex:withButtonType:)]) {
        [self.delegate selectTopButton:self withIndex:btn.tag-kMeViewBaseTag withButtonType:type];
    }
}


@end
