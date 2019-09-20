//
//  MEPersonalCourseVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseVC.h"
#import "MEPersonalCourseSearchNavView.h"
#import "MEPersonalCourseHeaderView.h"
#import "MEPersonalCourseFreeCell.h"
#import "MEPersonalCourseListCell.h"
#import "MEPersonalCourseHeader.h"

#import "MEAdModel.h"
#import "MEFilterMainModel.h"
#import "MEPersonalCourseListModel.h"

#import "MESearchCourseVC.h"
#import "MEPersionalCourseListVC.h"
#import "MEPersionalCourseDetailVC.h"

@interface MEPersonalCourseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,JXCategoryViewDelegate>{
    NSInteger _selectedIndex;
    NSArray *_filterArr;//分类
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) MEPersonalCourseHeaderView *headerView;
@property (nonatomic, strong) MEPersonalCourseSearchNavView *navView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSArray *filterArr;
@property (nonatomic, assign) CGFloat scrollHeight;

@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) BOOL isSelectedTop;;

@end

@implementation MEPersonalCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    [self.view addSubview:self.navView];
    _filterArr = [NSArray array];
    _selectedIndex = 0;
    self.scrollHeight = (166*kMeFrameScaleY()+36+260);
    self.originalHeight = 0;
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithBannerImages:@[] titleArray:@[]];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
//    NSLog(@"index:%ld",(long)index);
    self.isSelectedTop = YES;
    [self reloadProductsWithIndex:index];
}
//刷新优选商品
- (void)reloadProductsWithIndex:(NSInteger)index{
    [self.headerView reloadTitleViewWithIndex:index];
    self.categoryView.defaultSelectedIndex = index;
    [self.categoryView reloadData];
    CGFloat height = 0;
    BOOL hasFree = NO;
    if ([self.filterArr containsObject:@"推荐"]) {
        hasFree = YES;
    }
    if (index == 0) {
        height = 166*kMeFrameScaleY();
    }else {
        height = 166*kMeFrameScaleY()+36+260;
        for (int i = 1; i < index; i++) {
            MEPersonalCourseListModel *model = self.refresh.arrData[i];
            height += (36+130*model.courses.count);
        }
    }
    [self.tableView setContentOffset:CGPointMake(0, height) animated:YES];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"member_id":kMeUnNilStr(kCurrentUser.uid)};
}

- (void)handleResponse:(id)data{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *dict = (NSDictionary *)data;
    
    if ([dict.allKeys containsObject:@"banner"]) {
        self.banners = [MEAdModel mj_objectArrayWithKeyValuesArray:kMeUnArr(dict[@"banner"])];
    }
    if ([dict.allKeys containsObject:@"navbar"]) {
        NSArray *navBar = [MEFilterMainModel mj_objectArrayWithKeyValuesArray:kMeUnArr(dict[@"navbar"])];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [navBar enumerateObjectsUsingBlock:^(MEFilterMainModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:kMeUnNilStr(model.title)];
        }];
        self.filterArr = [titles mutableCopy];
        [titles removeAllObjects];
    }
    if ([dict.allKeys containsObject:@"courseList"]) {
        self.refresh.arrData = [MEPersonalCourseListModel mj_objectArrayWithKeyValuesArray:kMeUnArr(dict[@"courseList"])];
    }
    _selectedIndex = 0;
    self.scrollHeight = (166*kMeFrameScaleY()+36+260);
    self.originalHeight = 0;
    [self.headerView setUIWithBannerImages:self.banners titleArray:self.filterArr];
    self.categoryView.titles = self.filterArr;
    [self.categoryView reloadData];
    [self.tableView reloadData];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.refresh.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    MEPersonalCourseListModel *model = self.refresh.arrData[section];
    return model.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEPersonalCourseListModel *model = self.refresh.arrData[indexPath.section];
    if (indexPath.section == 0) {
        MEPersonalCourseFreeCell *freeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPersonalCourseFreeCell class]) forIndexPath:indexPath];
        [freeCell setUIWithArray:kMeUnArr(model.courses)];
        kMeWEAKSELF
        freeCell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            NSArray *course = kMeUnArr(model.courses);
            MECourseListModel *model = (MECourseListModel *)course[index];
            MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.idField];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        return freeCell;
    }
    MEPersonalCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPersonalCourseListCell class]) forIndexPath:indexPath];
    NSArray *courses = kMeUnArr(model.courses);
    MECourseListModel *listModel = courses[indexPath.row];
    [cell setUIWithModel:listModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 260;
    }
    return kMEPersonalCourseListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEPersonalCourseHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
    MEPersonalCourseListModel *model = self.refresh.arrData[section];
    [header setUIWithTitle:kMeUnNilStr(model.classify_name)];
    kMeWEAKSELF
    header.tapBlock = ^{
        kMeSTRONGSELF
        MEPersionalCourseListVC *vc = [[MEPersionalCourseListVC alloc] initWithClassifyId:model.classify_id];
        vc.title = kMeUnNilStr(model.classify_name);
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEPersonalCourseListModel *model = self.refresh.arrData[indexPath.section];
    NSArray *courses = kMeUnArr(model.courses);
    MECourseListModel *listModel = courses[indexPath.row];
    
    MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:listModel.idField];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        if (self.filterArr.count > 0) {
            if (scrollView.contentOffset.y >= 166*kMeFrameScaleY()) {
                self.categoryView.hidden = NO;
                if (!self.isSelectedTop) {
                    
                    if (scrollView.contentOffset.y >= self.scrollHeight) {
                        _selectedIndex++;
                        MEPersonalCourseListModel *model = self.refresh.arrData[_selectedIndex];
                        self.originalHeight = self.scrollHeight;
                        self.scrollHeight += 36+130*model.courses.count;
                    } else {
                        if (_selectedIndex > 1) {
                            if (scrollView.contentOffset.y < self.originalHeight) {
                                _selectedIndex--;
                                MEPersonalCourseListModel *model = self.refresh.arrData[_selectedIndex];
                                self.scrollHeight = self.originalHeight;
                                self.originalHeight -= 36+130*model.courses.count;
                            }
                        }else {
                            if (scrollView.contentOffset.y < self.originalHeight) {
                                _selectedIndex = 0;
                                self.scrollHeight = (166*kMeFrameScaleY()+36+260);
                                self.originalHeight = 0;
                            }
                        }
                    }
                    [self.headerView reloadTitleViewWithIndex:_selectedIndex];
                    self.categoryView.defaultSelectedIndex = _selectedIndex;
                    [self.categoryView reloadData];
                }
            }else {
                [self.headerView reloadTitleViewWithIndex:0];
                self.categoryView.defaultSelectedIndex = 0;
                [self.categoryView reloadData];
                self.categoryView.hidden = YES;
            }
        }else {
            self.categoryView.hidden = YES;
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        if (self.isSelectedTop) {
            self.isSelectedTop = NO;
        }
    }
}
//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
//    if (model.is_need_login == 1) {
//        if(![MEUserInfoModel isLogin]){
//            kMeWEAKSELF
//            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
//                kMeSTRONGSELF
//                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
//            } failHandler:^(id object) {
//                return;
//            }];
//            return;
//        }
//    }
//
//    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
//    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
        case 21:
        {//C端视频
            MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.video_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 22:
        {//C端音频
            MEPersionalCourseDetailVC *vc = [[MEPersionalCourseDetailVC alloc] initWithCourseId:model.audio_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma setter && getter
- (MEPersonalCourseSearchNavView *)navView{
    if(!_navView){
        _navView = [[MEPersonalCourseSearchNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight)];
        kMeWEAKSELF
        _navView.searchBlock = ^{
            kMeSTRONGSELF
            MESearchCourseVC *searchVC = [[MESearchCourseVC alloc] init];
            [strongSelf.navigationController pushViewController:searchVC animated:YES];
        };
    }
    return _navView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseFreeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPersonalCourseFreeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPersonalCourseListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCoursesGetCourses)];
        _refresh.delegate = self;
        _refresh.isDataInside = NO;
//        _refresh.showMaskView = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

- (MEPersonalCourseHeaderView *)headerView {
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEPersonalCourseHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MEPersonalCourseHeaderViewHeight);
        kMeWEAKSELF
        _headerView.titleSelectedIndexBlock = ^(NSInteger index) {
            [weakSelf reloadProductsWithIndex:index];
        };
        _headerView.selectedIndexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            MEAdModel *model = strongSelf.banners[index];
            [strongSelf cycleScrollViewDidSelectItemWithModel:model];
        };
    }
    return _headerView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, 46)];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor =  kMEPink;
        lineView.indicatorLineViewHeight = 1;
        _categoryView.titles = self.filterArr;
        _categoryView.indicators = @[lineView];
        _categoryView.delegate = self;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleColor =  [UIColor blackColor];
        _categoryView.titleSelectedColor = kMEPink;
        [self.view addSubview:_categoryView];
        _categoryView.hidden = YES;
    }
    return _categoryView;
}

@end
