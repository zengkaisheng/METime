//
//  MECareerVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECareerVC.h"
#import "MEAdModel.h"
#import "MECareerHomeCategoryModel.h"
#import "MENewOnlineCourseHeaderView.h"
#import "MECareerBaseVC.h"
#import "MECourseDetailVC.h"

@interface MECareerVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) MENewOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSArray *banner;
@property (nonatomic, strong) NSArray *categorys;

@end

@implementation MECareerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    
    [self getCareerHomeDatas];
}

#pragma mark ---- Networking
- (void)getCareerHomeDatas {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetBannerWithAdType:23 successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSArray class]]) {
                strongSelf.banner = [MEAdModel mj_objectArrayWithKeyValuesArray:kMeUnArr(responseObject.data)];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetCareerCategoryWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = responseObject.data;
                if ([data.allKeys containsObject:@"data"]) {
                    if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                        strongSelf.categorys = [MECareerHomeCategoryModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
                    }
                }
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf.hud hideAnimated:YES];
            [strongSelf setupUI];
        });
    });
}

- (void)setupUI {
    self.navBarHidden = YES;
    [self.view addSubview:self.headerView];
    [self.headerView setUIWithArray:kMeUnArr(self.banner)];
    
    CGFloat categoryViewHeight = kCategoryViewHeight;
    if (self.categorys.count < 2) {
        categoryViewHeight = 1;
    }
    
    NSMutableArray *categoryTitles = [[NSMutableArray alloc] init];
    [self.categorys enumerateObjectsUsingBlock:^(MECareerHomeCategoryModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [categoryTitles addObject:model.name];
    }];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, (kMeStatusBarHeight-20) + kMENewOnlineCourseHeaderViewHeight + categoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT- kMENewOnlineCourseHeaderViewHeight - categoryViewHeight-kMeTabBarHeight-(kMeStatusBarHeight-20))];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *self.categorys.count, SCREEN_HEIGHT-kMENewOnlineCourseHeaderViewHeight - categoryViewHeight-kMeTabBarHeight-(kMeStatusBarHeight-20));
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < self.categorys.count; i++) {
        MECareerHomeCategoryModel *model = self.categorys[i];
        MECareerBaseVC *VC = [[MECareerBaseVC alloc] initWithCategoryId:model.idField categorys:self.categorys];
        VC.title = kMeUnNilStr(model.name);
        VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        VC.view.frame = CGRectMake( SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMENewOnlineCourseHeaderViewHeight - categoryViewHeight-kMeTabBarHeight-(kMeStatusBarHeight-20));
        [self addChildViewController:VC];
        [self.scrollView addSubview:VC.view];
    }
    
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake( 0, (kMeStatusBarHeight-20)+kMENewOnlineCourseHeaderViewHeight, SCREEN_WIDTH, categoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 30 *kMeFrameScaleX();
    lineView.indicatorLineViewColor = kMEPink;
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = [categoryTitles copy];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
    switch (model.show_type) {//18视频 19音频
        case 18:
        {
            MECourseDetailVC *dvc = [[MECourseDetailVC alloc] initWithId:model.video_id type:0];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 19:
        {
            MECourseDetailVC *dvc = [[MECourseDetailVC alloc] initWithId:model.audio_id type:1];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma setter&&getter
- (MENewOnlineCourseHeaderView *)headerView {
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MENewOnlineCourseHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, kMeStatusBarHeight-20, SCREEN_WIDTH, kMENewOnlineCourseHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (index < 100) {
                MEAdModel *model = strongSelf.banner[index];
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            }
        };
    }
    return _headerView;
}

- (NSArray *)banner {
    if (!_banner) {
        _banner = [[NSArray alloc] init];
    }
    return _banner;
}

- (NSArray *)categorys {
    if (!_categorys) {
        _categorys = [[NSArray alloc] init];
    }
    return _categorys;
}

@end
