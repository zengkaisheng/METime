//
//  MEFiveCategoryView.m
//  ME时代
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveCategoryView.h"
#import "METhridHomeVC.h"
#import "MEProductSearchVC.h"
#import "MERCConversationListVC.h"
//#import "MENoticeTypeVC.h"
#import "MENoticeVC.h"
#import "MEFilterVC.h"
#import "MEStoreModel.h"
#import "MECoupleFilterVC.h"
#import "MEFourHomeVC.h"

@interface MEFiveCategoryView ()<JXCategoryViewDelegate>

@end


@implementation MEFiveCategoryView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        [self addSubUIView];
    }
    return self;
}

- (void)addSubUIView{
    self.userInteractionEnabled = YES;
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEFiveCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor =  [UIColor whiteColor];
    lineView.indicatorLineViewHeight = 1;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = @[@""];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleColor =  [UIColor whiteColor];
    self.categoryView.defaultSelectedIndex = 0;
    [self addSubview:self.categoryView];
}

- (void)setMaterArray:(NSArray *)materArray {
    if (materArray.count <= 0) {
        return;
    }
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < materArray.count; i++) {
        NSDictionary *dic = materArray[i];
        NSString *title = dic[@"title"];
        [titleArray addObject:title];
    }
    self.categoryView.titles = [titleArray copy];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectIndexBlock,index);
}

@end
