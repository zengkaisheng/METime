//
//  MEFilterClerkView.h
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, kMEFilterClerkViewType) {
    kMEFilterClerkViewZfType=0,
    kMEFilterClerkViewReadType,
    kMEFilterClerkViewMoneyType,
};

const static CGFloat kMEFilterClerkViewHeight = 40;

@class MEFilterClerkView;


@protocol FilterClerkViewDelegate <NSObject>
@optional
//选中最上方的按钮的点击事件
- (void)selectTopButton:(MEFilterClerkView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType )type;
//选中分类中按钮的点击事件
- (void)selectItme:(MEFilterClerkView *)selectView withIndex:(NSInteger)index;
@end

@interface MEFilterClerkView : UIView

@property (nonatomic, weak) id<FilterClerkViewDelegate>delegate;
//默认选中，默认是第一个
@property (nonatomic, assign) int defaultSelectIndex;
//默认选中项，默认是第一个
@property (nonatomic, assign) int defaultSelectItmeIndex;

@end

NS_ASSUME_NONNULL_END
