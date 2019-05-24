//
//  MEChooseTerminalVC.m
//  ME时代
//
//  Created by gao lei on 2019/5/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEChooseTerminalVC.h"

#define kViewHeight 66

@interface MEChooseTerminalVC ()

@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MEChooseTerminalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.title = @"显示终端";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    
    [self setupUI];
}

- (void)setupUI {
    UIView *firstView = [self createButtonViewWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, kViewHeight) title:@"全部" subTitle:@"显示APP端和小程序端" tag:0];
    
    UIView *secondView = [self createButtonViewWithFrame:CGRectMake(0, kMeNavBarHeight + kViewHeight , SCREEN_WIDTH, kViewHeight) title:@"APP" subTitle:@"只在APP端显示" tag:1];
    
    UIView *thirdView = [self createButtonViewWithFrame:CGRectMake(0, kMeNavBarHeight + kViewHeight * 2, SCREEN_WIDTH, kViewHeight) title:@"小程序" subTitle:@"只有小程序端显示" tag:2];
    
    [self.view addSubview:firstView];
    [self.view addSubview:secondView];
    [self.view addSubview:thirdView];
    
    self.viewArray = @[firstView,secondView,thirdView];
    
    for (UIView *view in self.viewArray) {
        for (id obj in view.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                if (btn.tag >= 100) {
                    btn.selected = NO;
                    if (!self.tag) {
                        if (btn.tag - 100 == 0) {
                            btn.selected = YES;
                        }
                    }else {
                        if (btn.tag - 100 == self.tag) {
                            btn.selected = YES;
                        }
                    }
                }
            }
        }
    }
}

- (UIView *)createButtonViewWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle tag:(NSInteger)tag{
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.tag = tag;
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn setImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
    imgBtn.tag = tag+100;
    imgBtn.frame = CGRectMake(21, 26, 16, 16);
    [bgView addSubview:imgBtn];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(42, 12, 50, 14)];
    titleLab.text = title;
    titleLab.textColor = kME333333;
    titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    [bgView addSubview:titleLab];
    
    UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(43, 36, SCREEN_WIDTH - 43 - 7, 12)];
    subTitleLab.text = subTitle;
    subTitleLab.textColor = kME999999;
    subTitleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 12];
    [bgView addSubview:subTitleLab];
    
    UIButton *fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fontBtn addTarget:self action:@selector(fontBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    fontBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    fontBtn.tag = tag;
    [bgView addSubview:fontBtn];
    
    return bgView;
}

- (void)fontBtnDidClicked:(UIButton *)sender {
    UIButton *fontBtn = (UIButton *)sender;
    for (UIView *view in self.viewArray) {
        for (id obj in view.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                if (btn.tag >= 100) {
                    btn.selected = NO;
                    if (btn.tag - 100 == fontBtn.tag) {
                        btn.selected = YES;
                    }
                }
            }
        }
    }
}

- (void)finishAction {
    for (UIView *view in self.viewArray) {
        for (id obj in view.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                if (btn.tag >= 100 && btn.selected == YES) {
                    if (self.indexBlock) {
                        self.indexBlock(btn.tag - 100);
                    }
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setTitle:@"完成" forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRight.backgroundColor = kMEFinish;
        _btnRight.cornerRadius = 4;
        _btnRight.clipsToBounds = YES;
        _btnRight.frame = CGRectMake(0, 0, 57, 30);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
