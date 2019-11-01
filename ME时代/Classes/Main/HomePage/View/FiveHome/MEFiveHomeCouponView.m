//
//  MEFiveHomeCouponView.m
//  志愿星
//
//  Created by gao lei on 2019/10/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveHomeCouponView.h"
#import "MEFiveHomeNavView.h"
#import "MEFiveCouponListView.h"

@interface MEFiveHomeCouponView ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;

@end

@implementation MEFiveHomeCouponView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor whiteColor];
//    [UIColor colorWithHexString:@"#2ED9A4"];
    lineView.indicatorLineViewHeight = 10;
    lineView.indicatorLineWidth = 30;
    [lineView setLineFontImage:@"icon_categoryViewImage"];
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = @[@""];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#2ED9A4"];
    self.categoryView.titleColor =  kME333333;
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)setUIWithMaterialArray:(NSArray *)materialArray {
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[MEFiveCouponListView class]]) {
            [view removeFromSuperview];
        }
    }
    if (materialArray.count > 0) {
        NSMutableArray *titleArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < materialArray.count; i++) {
            NSDictionary *dic = materialArray[i];
            NSString *title = dic[@"title"];
            [titleArray addObject:title];
        }
        self.categoryView.titles = [titleArray copy];
        [self.categoryView reloadData];
        
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * materialArray.count, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-52);
        self.scrollView.bounces = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < materialArray.count; i++) {
            MEFiveCouponListView *view = [[MEFiveCouponListView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-52) type:i materialArray:materialArray];
            kMeWEAKSELF
            view.scrollBlock = ^{
                kMeSTRONGSELF
                kMeCallBlock(strongSelf.scrollBlock);
            };
//            int R = (arc4random() % 256);
//            int G = (arc4random() % 256);
//            int B = (arc4random() % 256);
//            view.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
            [self.scrollView addSubview:view];
        }
        
        self.categoryView.contentScrollView = self.scrollView;
    }
}

- (void)setScrollViewCanScroll:(BOOL)canScroll {
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[MEFiveCouponListView class]]) {
            MEFiveCouponListView *listView = (MEFiveCouponListView *)view;
            BOOL isHide = NO;
            for (id obj in listView.subviews) {
                if ([obj isKindOfClass:[UICollectionView class]]) {
                    UICollectionView *collectionV = (UICollectionView *)obj;
                    if (canScroll) {
                        if (collectionV.contentOffset.y < 0) {
                            collectionV.contentSize = CGSizeMake(self.frame.size.width, 0);
                            isHide = YES;
                        }else if (collectionV.contentOffset.y < 100) {
                            isHide = YES;
                        }else {
                            isHide = NO;
                        }
                    }else {
                        collectionV.contentSize = CGSizeMake(self.frame.size.width, 0);
                        isHide = YES;
                    }
                }
            }
            [listView viewHideFooterView:isHide];
        }
    }
}

- (void)reloadCategoryTitlesWithIndex:(NSInteger)index {
    self.categoryView.defaultSelectedIndex = index;
    [self.categoryView reloadData];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectIndexBlock,index);
}

@end
