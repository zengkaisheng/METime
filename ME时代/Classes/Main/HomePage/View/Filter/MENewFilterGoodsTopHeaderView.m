//
//  MENewFilterGoodsTopHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/5/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterGoodsTopHeaderView.h"
#import "MEAdModel.h"

@interface MENewFilterGoodsTopHeaderView ()<SDCycleScrollViewDelegate,JXCategoryViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *BGImageV;
@property (weak, nonatomic) IBOutlet UIView *titleButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewConsHeight;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end


@implementation MENewFilterGoodsTopHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithBackgroundImage:(NSString *)bgImage bannerImage:(nonnull NSArray *)bannerImages {
    
    kSDLoadImg(_BGImageV,kMeUnNilStr(bgImage));
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    
    __block NSMutableArray *arrImage =[NSMutableArray array];
    [bannerImages enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.imageURLStringsGroup = arrImage;
    
    if (arrImage.count <= 1) {
        _sdView.infiniteLoop = NO;
        _sdView.autoScroll = NO;
    }else {
        _sdView.infiniteLoop = YES;
        _sdView.autoScroll = YES;
    }
}

- (void)setUIWithTitleArray:(NSArray *)titles {
    if (titles.count > 1) {
        self.titleViewConsHeight.constant = 46;
        self.categoryView.titles = titles;
        self.categoryView.defaultSelectedIndex = 0;
        [self.categoryView reloadData];
    }else {
        self.titleViewConsHeight.constant = 0;
    }
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
        [_titleButtonView addSubview:_categoryView];
    }
    return _categoryView;
}

@end
