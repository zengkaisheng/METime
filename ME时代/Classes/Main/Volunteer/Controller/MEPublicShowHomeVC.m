//
//  MEPublicShowHomeVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowHomeVC.h"
#import "MECustomerClassifyListModel.h"
#import "MEPublicShowBaseVC.h"

@interface MEPublicShowHomeVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong)NSMutableArray *arrType;
@property (nonatomic, strong)NSMutableArray *arrModel;

@end

@implementation MEPublicShowHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"公益秀";
    
    [self requestMaterialData];
}

- (void)requestMaterialData {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetUsefulactivityClassifyListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.arrType removeAllObjects];
        
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            
            strongSelf.arrModel = [MECustomerClassifyListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else {
            strongSelf.arrModel = [NSMutableArray array];
        }
        
        [strongSelf->_arrModel enumerateObjectsUsingBlock:^(MECustomerClassifyListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [strongSelf.arrType addObject:model.classify_name];
        }];
        [strongSelf setUpUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUpUI {
    CGFloat categoryViewHeight = kCategoryViewHeight;
    if (self.arrModel.count < 2) {
        categoryViewHeight = 0.1;
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
        MEPublicShowBaseVC *VC = [[MEPublicShowBaseVC alloc] initWithClassifyId:mode.idField categoryHeight:categoryViewHeight];
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
    lineView.indicatorLineViewColor = [UIColor colorWithHexString:@"#2ED9A4"];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#2ED9A4"];
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
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

@end
