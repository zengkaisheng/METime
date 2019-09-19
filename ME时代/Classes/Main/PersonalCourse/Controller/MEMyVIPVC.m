//
//  MEMyVIPVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyVIPVC.h"
#import "MEMyVIPDetailView.h"
#import "MEMyCourseVIPInfoModel.h"

#import "MEVIPViewController.h"
#import "MEMyVIPPayRecordVC.h"

@interface MEMyVIPVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) MEMyVIPDetailView *vipView;
@property (nonatomic, strong) MEMyCourseVIPInfoModel *model;

@end

@implementation MEMyVIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"VIP详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.vipView];
    
    [self requestMyCourseVIPDetailWithNetWork];
}

- (void)reloadUI {
    self.vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:self.model.ruleHeight]);
    self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:self.model.ruleHeight]);

    [self.vipView setUIWithModel:self.model];
    kMeWEAKSELF
    self.vipView.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 1) {//开通或续费
            MEVIPViewController *vc = [[MEVIPViewController alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 2) {//查看交易记录
            MEMyVIPPayRecordVC *vc = [[MEMyVIPPayRecordVC alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

#pragma mark -- Networking
//我的VIP信息
- (void)requestMyCourseVIPDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetMyCourseVIPDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEMyCourseVIPInfoModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark -- setter&&getter
- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        _scrollerView.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:0]);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
        _scrollerView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollerView;
}

- (MEMyVIPDetailView *)vipView {
    if (!_vipView) {
        _vipView = [[[NSBundle mainBundle]loadNibNamed:@"MEMyVIPDetailView" owner:nil options:nil] lastObject];
        _vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:0]);
    }
    return _vipView;
}

@end
