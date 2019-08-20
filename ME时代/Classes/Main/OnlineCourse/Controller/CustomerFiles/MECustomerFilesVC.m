//
//  MECustomerFilesVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerFilesVC.h"
#import "MECustomerClassifyListModel.h"
#import "MECustomerFilesBaseVC.h"

@interface MECustomerFilesVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong)NSMutableArray *arrType;
@property (nonatomic, strong)NSMutableArray *arrModel;

@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MECustomerFilesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客档案列表";
    [self getCustomerClassifyListWithNetworking];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}
- (void)setupUI {
    CGFloat categoryViewHeight = kCategoryViewHeight;
    if (self.arrModel.count < 2) {
        categoryViewHeight = 1;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-categoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count, SCREEN_HEIGHT-kMeNavBarHeight-categoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _arrType.count; i++) {
        MECustomerClassifyListModel *mode = _arrModel[i];
        MECustomerFilesBaseVC *VC = [[MECustomerFilesBaseVC alloc] initWithClassifyId:mode.idField];
        VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        VC.view.frame = CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-categoryViewHeight);
        [self addChildViewController:VC];
        [self.scrollView addSubview:VC.view];
    }
    
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, categoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 30 *kMeFrameScaleX();
    lineView.indicatorLineViewColor = kMEPink;
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark ---- Networking
//视频分类
- (void)getCustomerClassifyListWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerClassifyListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.arrModel = [MECustomerClassifyListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            
            [strongSelf->_arrModel enumerateObjectsUsingBlock:^(MECustomerClassifyListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [strongSelf.arrType addObject:model.classify_name];
            }];
        }
        [strongSelf setupUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -- Action
- (void)rightBtnAction {
    
}

#pragma mark -- setter && getter
- (NSMutableArray *)arrType {
    if (!_arrType) {
        _arrType = [[NSMutableArray alloc] init];
    }
    return _arrType;
}

- (NSMutableArray *)arrModel {
    if (!_arrModel) {
        _arrModel = [[NSMutableArray alloc] init];
    }
    return _arrModel;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setTitle:@"新增" forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRight setBackgroundColor:[UIColor colorWithHexString:@"#FFD5D5"]];
        _btnRight.cornerRadius = 12;
        _btnRight.clipsToBounds = YES;
        _btnRight.frame = CGRectMake(0, 0, 65, 25);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
