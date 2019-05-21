//
//  MECoupleFilterVC.m
//  ME时代
//
//  Created by hank on 2018/12/24.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MECoupleFilterVC.h"
#import "MECoupleFilterModel.h"
#import "MECoupleFilterFlowLayout.h"
#import "MECoupleFileCell.h"
#import "MECoupleFilterHederView.h"
#import "MeCoupleFilterLeftCell.h"
#import "MECoupleFilterNavView.h"
#import "MECoupleMailVC.h"
#import "MECouponSearchVC.h"
#import "MENavigationVC.h"

static float kCollectionViewMargin = 3.f;

@interface MECoupleFilterVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *collectionDatas;
@property (nonatomic, strong) MECoupleFilterFlowLayout *flowLayout;
@property (nonatomic, strong) MECoupleFilterNavView *navView;
@end

@implementation MECoupleFilterVC
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddressTaobaokeGetCategoryWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.dataSource addObjectsFromArray:[MECoupleFilterModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
        for (MECoupleFilterModel *model in strongSelf.dataSource){
            NSMutableArray *datas = [NSMutableArray array];
            for (MECoupleFilterSubModel *sModel in model.subcategories){
                [datas addObject:sModel];
            }
            [strongSelf.collectionDatas addObject:datas];
        }
        [strongSelf.tableView reloadData];
        [strongSelf.collectionView reloadData];
        [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:@"liwushuo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *categories = dict[@"data"][@"categories"];
    for (NSDictionary *dict in categories)
    {
        MECoupleFilterModel *model =
        [MECoupleFilterModel mj_objectWithKeyValues:dict];
        [self.dataSource addObject:model];
        
        NSMutableArray *datas = [NSMutableArray array];
        for (MECoupleFilterSubModel *sModel in model.subcategories)
        {
            [datas addObject:sModel];
        }
        [self.collectionDatas addObject:datas];
    }
    */
    

}


#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeCoupleFilterLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeCoupleFilterLeftCell class]) forIndexPath:indexPath];
    MECoupleFilterModel *model = self.dataSource[indexPath.row];
    cell.name.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self scrollToTopOfSection:_selectIndex animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleFilterSubModel *model = self.collectionDatas[indexPath.section][indexPath.row];
    MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithQuery:kMeUnNilStr(model.name)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MECoupleFilterModel *model = self.dataSource[section];
    return model.subcategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MECoupleFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleFileCell class]) forIndexPath:indexPath];
    MECoupleFilterSubModel *model = self.collectionDatas[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - kLeftTableViewWidth - 4 * kCollectionViewMargin) / 3,
                      (SCREEN_WIDTH - kLeftTableViewWidth - 4 * kCollectionViewMargin) / 3 + 32);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = NSStringFromClass([MECoupleFilterHederView class]);
    }
    MECoupleFilterHederView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    //    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    //    {
    //        CollectionCategoryModel *model = self.dataSource[indexPath.section];
    //        view.title.text = model.name;
    //    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 1);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)searchCoupon{
    MECouponSearchVC *searchViewController = [MECouponSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索优惠券" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MECoupleMailVC *dataVC = [[MECoupleMailVC alloc]initWithQuery:searchText];
        [searchViewController.navigationController pushViewController:dataVC animated:YES];
    }];
    [searchViewController setSearchHistoriesCachePath:kMECouponSearchVCSearchHistoriesCachePath];
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma mark - Getters

- (NSMutableArray *)dataSource{
    if (!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)collectionDatas{
    if (!_collectionDatas){
        _collectionDatas = [NSMutableArray array];
    }
    return _collectionDatas;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, kLeftTableViewWidth, SCREEN_HEIGHT-kMeNavBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = kLeftTableViewHeight;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[MeCoupleFilterLeftCell class] forCellReuseIdentifier:NSStringFromClass([MeCoupleFilterLeftCell class])];
    }
    return _tableView;
}

- (MECoupleFilterFlowLayout *)flowLayout{
    if (!_flowLayout){
        _flowLayout = [[MECoupleFilterFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCollectionViewMargin + kLeftTableViewWidth, kCollectionViewMargin+kMeNavBarHeight, SCREEN_WIDTH - kLeftTableViewWidth - 2 * kCollectionViewMargin, SCREEN_HEIGHT - 2 * kCollectionViewMargin-kMeNavBarHeight) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerClass:[MECoupleFileCell class] forCellWithReuseIdentifier:NSStringFromClass([MECoupleFileCell class])];
        //注册分区头标题
        [_collectionView registerClass:[MECoupleFilterHederView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass([MECoupleFilterHederView class])];
    }
    return _collectionView;
}

- (MECoupleFilterNavView *)navView{
    if(!_navView){
        _navView = [[[NSBundle mainBundle]loadNibNamed:@"MECoupleFilterNavView" owner:nil options:nil] lastObject];
        _navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight);
        kMeWEAKSELF
        _navView.backBlock = ^{
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _navView.searchBlock = ^{
            kMeSTRONGSELF
            [strongSelf searchCoupon];
        };
    }
    return _navView;
}

@end
