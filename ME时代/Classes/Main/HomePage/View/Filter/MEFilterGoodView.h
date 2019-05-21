//
//  MEFilterGoodView.h
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>


const static CGFloat kMEFilterGoodViewHeight = 40;

@class MEFilterGoodView;


@protocol FilterSelectViewDelegate <NSObject>
@optional
//选中最上方的按钮的点击事件
- (void)selectTopButton:(MEFilterGoodView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType )type;
//选中分类中按钮的点击事件
- (void)selectItme:(MEFilterGoodView *)selectView withIndex:(NSInteger)index;
@end

@interface MEFilterGoodView : UIView

@property (nonatomic, weak) id<FilterSelectViewDelegate>delegate;
//默认选中，默认是第一个
@property (nonatomic, assign) int defaultSelectIndex;
//默认选中项，默认是第一个
@property (nonatomic, assign) int defaultSelectItmeIndex;

//是否能点击 默认可以
//@property (nonatomic, assign) BOOL canSelect;
@end
