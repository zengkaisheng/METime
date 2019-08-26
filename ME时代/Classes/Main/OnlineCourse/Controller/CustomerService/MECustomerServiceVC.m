//
//  MECustomerServiceVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceVC.h"
#import "MECustomerClassifyListModel.h"
#import "MECustomerServiceBaseVC.h"
#import "MECustomerServiceDetailVC.h"
#import "MECustomInputPhoneView.h"

@interface MECustomerServiceVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong)NSMutableArray *arrType;
@property (nonatomic, strong)NSMutableArray *arrModel;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation MECustomerServiceVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"顾客服务列表";
    [self getCustomerClassifyListWithNetworking];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    
    kFilesListReload
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
        MECustomerServiceBaseVC *VC = [[MECustomerServiceBaseVC alloc] initWithClassifyId:mode.idField];
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
//顾客分类
- (void)getCustomerClassifyListWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerClassifyListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.arrType removeAllObjects];
        
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            
            strongSelf.arrModel = [MECustomerClassifyListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else {
            strongSelf.arrModel = [NSMutableArray array];
        }
        MECustomerClassifyListModel *model = [[MECustomerClassifyListModel alloc] init];
        model.classify_name = @"全部";
        model.idField = 0;
        [strongSelf.arrModel insertObject:model atIndex:0];
        [strongSelf->_arrModel enumerateObjectsUsingBlock:^(MECustomerClassifyListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [strongSelf.arrType addObject:model.classify_name];
        }];
        [strongSelf setupUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -- Action
- (void)addBtnAction {
    kMeWEAKSELF
    [MECustomInputPhoneView showCustomInputPhoneViewWithTitle:@"" contentTitle:@"" saveBlock:^(NSString *str) {
        kMeSTRONGSELF
        MECustomerServiceDetailVC *vc = [[MECustomerServiceDetailVC alloc] initWithPhone:str];
        vc.finishBlock = ^{
            [strongSelf reloadFilesList];
        };
        [strongSelf.navigationController pushViewController:vc animated:YES];
    } cancelBlock:^{
    } superView:kMeCurrentWindow];
}

- (void)reloadFilesList {
    [self.scrollView removeFromSuperview];
    [self.categoryView removeFromSuperview];
    [self getCustomerClassifyListWithNetworking];
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

- (UIButton *)addBtn{
    if(!_addBtn){
        _addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"新增" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:kMEPink];
        _addBtn.cornerRadius = 12;
        _addBtn.clipsToBounds = YES;
        _addBtn.frame = CGRectMake(0, 0, 65, 25);
        _addBtn.titleLabel.font = kMeFont(15);
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
