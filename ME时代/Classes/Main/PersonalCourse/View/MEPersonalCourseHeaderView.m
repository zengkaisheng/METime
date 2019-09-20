//
//  MEPersonalCourseHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseHeaderView.h"
#import "MEAdModel.h"

@interface MEPersonalCourseHeaderView ()<SDCycleScrollViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsHeight;

@end


@implementation MEPersonalCourseHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _sdViewConsHeight.constant = 166*kMeFrameScaleY();
}

- (void)setUIWithBannerImages:(NSArray *)images titleArray:(NSArray *)titles {
    
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.imageURLStringsGroup = arrImage;
    
    if (arrImage.count <= 1) {
        _sdView.infiniteLoop = NO;
        _sdView.autoScroll = NO;
    }else {
        _sdView.infiniteLoop = YES;
        _sdView.autoScroll = YES;
        _sdView.autoScrollTimeInterval = 4;
    }
    
    self.categoryView.titles = titles;
    self.categoryView.defaultSelectedIndex = 0;
    [self.categoryView reloadData];
}

- (void)reloadTitleViewWithIndex:(NSInteger)index {
    self.categoryView.defaultSelectedIndex = index;
    [self.categoryView reloadData];
}

//SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //    NSLog(@"index:%ld",(long)index);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedIndexBlock,index);
}

//JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    kMeCallBlock(_titleSelectedIndexBlock,index);
    //    NSLog(@"index:%ld",(long)index);
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 46)];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor =  kMEPink;
        lineView.indicatorLineViewHeight = 1;
        
        _categoryView.indicators = @[lineView];
        _categoryView.delegate = self;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleColor =  [UIColor blackColor];
        _categoryView.titleSelectedColor = kMEPink;
        [_titleView addSubview:_categoryView];
    }
    return _categoryView;
}

@end
