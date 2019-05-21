//
//  MEShoppingMallVC.m
//  ME时代
//
//  Created by hank on 2018/12/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingMallVC.h"
#import "MEFilterMainModel.h"
#import "MEMidelButton.h"
#import "MEFilterVC.h"
#import "MEProductSearchVC.h"
#import "MEShoppingMallContentVC.h"


@interface MEShoppingMallVC ()<UIScrollViewDelegate,JXCategoryViewDelegate>{
    NSMutableArray *_arrType;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMarin;
@property (weak, nonatomic) IBOutlet UIView *ccategoryView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *arrVC;
@property (weak, nonatomic) IBOutlet UIView *serachView;

@end

@implementation MEShoppingMallVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    _consTopMarin.constant = kMeStatusBarHeight;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)];
    _serachView.userInteractionEnabled = YES;
    [_serachView addGestureRecognizer:ges];
    _arrType = [NSMutableArray array];
    [self requestNetWork];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGoodFilterWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf->_arrType addObjectsFromArray:[MEFilterMainModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
        MEFilterMainModel *allModel = [MEFilterMainModel new];
        allModel.category_name = @"全部分类";
        allModel.idField = 0;
        [strongSelf->_arrType insertObject:allModel atIndex:0];
        [strongSelf initSomeThing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)initSomeThing{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeStatusBarHeight+kCategoryViewHeight+kSerachHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeStatusBarHeight-kCategoryViewHeight-kSerachHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeStatusBarHeight-kCategoryViewHeight-kSerachHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    NSMutableArray *arrTitle = [NSMutableArray array];
    for (NSInteger i=0;i<_arrType.count;i++) {
        MEFilterMainModel *model = _arrType[i];
        [arrTitle addObject:kMeUnNilStr(model.category_name)];
        MEShoppingMallContentVC *vc = [[MEShoppingMallContentVC alloc]initWithModel:model];
        vc.view.frame = CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeStatusBarHeight-kCategoryViewHeight-kSerachHeight);
        vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:vc];
        [self.arrVC addObject:vc];
        [self.scrollView addSubview:vc.view];
    }
    
    [self.view addSubview:self.scrollView];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, kCategoryViewHeight)];
    //1、初始化JXCategoryTitleView
//    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 20;
    lineView.indicatorLineViewColor = kMEPink;
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = arrTitle;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"080808"];
    self.categoryView.contentScrollView = self.scrollView;
//    self.categoryView.indicatorLineViewColor = kMEPink;
//    self.categoryView.indicatorLineWidth = 20;
//    self.categoryView.indicatorLineViewHeight = 2;
    [self.ccategoryView addSubview:self.categoryView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kCategoryViewHeight-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = kMeColor(222, 222, 222);
    [self.ccategoryView addSubview:line];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark - Action

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filterAction:(MEMidelBigImageButton *)sender {
    MEFilterVC *svc = [[MEFilterVC alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)searchAction:(UITapGestureRecognizer *)ges{
    MEProductSearchVC *svc = [[MEProductSearchVC alloc]init];
    [self.navigationController pushViewController:svc animated:NO];
}

- (NSMutableArray *)arrVC{
    if(!_arrVC){
        _arrVC = [NSMutableArray array];
    }
    return _arrVC;
}

@end
