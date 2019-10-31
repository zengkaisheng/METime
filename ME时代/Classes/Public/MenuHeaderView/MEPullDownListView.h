//
//  MEPullDownListView.h
//  ME时代
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapIndexsBlock)(NSArray *indexs);
typedef enum : NSUInteger {
    MEPulldownListViewSudoku = 0,
    MEPulldownListViewRow = 1
    
} MEPulldownListViewType;

@interface MEPullDownListView : UIView

@property (nonatomic) BOOL isVisible;

/**
 * get MEPulldownMenuView
 */
+ (instancetype)pulldownMenu;

/**
 @param items items标题
 @param isMutiple 是否多选
 @param originY Y轴坐标
 */
- (void)showWithItems:(NSArray *)items
           isMultiple:(BOOL)isMutiple
              originY:(CGFloat)originY
 pulldownMenuViewType:(MEPulldownListViewType)type
        tapIndexBlock:(void (^)(NSArray *indexs))tapIndexBlock;


- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
