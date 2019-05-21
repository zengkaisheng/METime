//
//  MEModelView.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MEModelBackGroudView;

@interface MEModelView : NSObject

+(void)showWithContentView:(UIView *)v;
+(void)showWithContentView:(UIView *)v fromRect:(CGRect)rt;
+(void)showWithContentView:(UIView *)v_content bgAlpha:(CGFloat)a_bg;

+(void)showWithContentView:(UIView *)v_content fromRect:(CGRect)rt bgColor:(UIColor *)c_bg bgAlpha:(CGFloat)a_bg editBgViewHandle:(void (^)(MEModelBackGroudView *))editHandle;

+(void)showInView:(UIView *)superView contentVIew:(UIView *)aView editBgViewHandle:(void (^)(MEModelBackGroudView *viewBg))editHandle;

//关闭modelView，aView为内容视图或内容视图的子视图
+(void)closeModelViewWithContentView:(UIView *)aView;
/**
 *  关闭modelView
 *
 *  @param aView modelView的父视图，不知道父视图可以传windows
 */
+(void)closeModelViewFromView:(UIView *)aView;
/**
 *  关闭modelView,  说明：调用的是[self closeModelViewFromView:kCurrentWindow];，缺点是可能更耗性能；
 */
+(void)close;

@end

@interface MEModelBackGroudView : UIView

@property (nonatomic,assign) CGFloat animateWithDuration;
@property (nonatomic,strong) kMeBasicBlock blockCloseAnimate;
@property (nonatomic,strong) kMeBasicBlock blockCloseHandle;

@end
