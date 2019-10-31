//
//  MEMenuHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapIndexBlock)(NSInteger index);
typedef enum : NSInteger {
    MEMenuHeaderViewSimple = 0,   //不带额外的按钮
    MEMenuHeaderViewMiddleM = 1   //带额外的按钮
} MEMenuHeaderViewType;

@interface MEMenuHeaderView : UIView

@property (nonatomic, strong) NSArray *resetTitles;
/**
 初始化
 @param titles 标题
 @param tapIndexBlock 点击Block
 @return 返回:MEMenuHeaderView
 */
- (instancetype)initWithTitle:(NSArray *)titles
                        frame:(CGRect)frame
                         type:(MEMenuHeaderViewType)headerType
                tapIndexBlock:(void (^)(NSInteger index))tapIndexBlock;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
