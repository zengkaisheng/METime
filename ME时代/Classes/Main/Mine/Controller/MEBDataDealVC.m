//
//  MEBDataDealVC.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBDataDealVC.h"
//#import "MEBDataDealView.h"
#import "MEBDataDealModel.h"
#import "MEBNewDataDealView.h"
#import "MEBDataDealStoreAchievementVC.h"
#import "MEDataDealStoreCustomerVC.h"

@interface MEBDataDealVC ()<UIScrollViewDelegate>{
    MEBDataDealModel *_model;
}

@property (nonatomic, strong) MEBNewDataDealView *cview;
@property (nonatomic, strong) UIScrollView *scrollerView;

@end

@implementation MEBDataDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据统计";
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"fbfbfb"];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.cview];
    self.scrollerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNetWork)];
    [self.scrollerView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetBstatisticsWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if(![responseObject.data isKindOfClass:[NSDictionary class]]){
            [strongSelf.scrollerView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        strongSelf->_model = [MEBDataDealModel mj_objectWithKeyValues:responseObject.data ];
        [strongSelf.cview setUIWithModel:strongSelf->_model];
        [strongSelf.scrollerView.mj_header endRefreshing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.scrollerView.mj_header endRefreshing];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        _scrollerView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"fbfbfb"];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, kMEBNewDataDealViewHeight);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}

- (MEBNewDataDealView *)cview{
    if(!_cview){
        _cview = [[[NSBundle mainBundle]loadNibNamed:@"MEBNewDataDealView" owner:nil options:nil] lastObject];
        _cview.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEBNewDataDealViewHeight);
        kMeWEAKSELF
        _cview.StructBlock = ^{
            kMeSTRONGSELF
            if(strongSelf->_model){
                MEBDataDealStoreAchievementVC *vc = [[MEBDataDealStoreAchievementVC alloc]initWithModel:strongSelf->_model];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        _cview.storeCustomer = ^{
            kMeSTRONGSELF
            MEDataDealStoreCustomerVC *vc = [[MEDataDealStoreCustomerVC alloc]initWithModel:strongSelf->_model];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _cview;
}

@end
