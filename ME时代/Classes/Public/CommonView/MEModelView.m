//
//  MEModelView.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEModelView.h"

@implementation MEModelBackGroudView


@end

@implementation MEModelView

+(void)tapActionForBGView:(UITapGestureRecognizer *)sender{
    
    MEModelBackGroudView *aView = (MEModelBackGroudView *)sender.view;
    UIView *subView = [aView.subviews firstObject];
    if (subView) {
        CGPoint point = [sender locationInView:subView];
        if (CGRectContainsPoint(subView.bounds, point)) {
            return;
        }
    }
    MEModelBackGroudView *viewBg = (MEModelBackGroudView *)aView;
    if ([viewBg isKindOfClass:[MEModelBackGroudView class]]) {
        if (viewBg.blockCloseHandle) {
            viewBg.blockCloseHandle();
        }
        if (viewBg.blockCloseAnimate) {
            if (viewBg.animateWithDuration<=0.0) {
                viewBg.animateWithDuration = 0.25;
            }
            [UIView animateWithDuration:viewBg.animateWithDuration animations:^{
                viewBg.blockCloseAnimate();
            } completion:^(BOOL finished) {
                [viewBg removeFromSuperview];
            }];
            return;
        }
    }
    [viewBg removeFromSuperview];
}

+(void)showWithContentView:(UIView *)v_content fromRect:(CGRect)rt bgColor:(UIColor *)c_bg bgAlpha:(CGFloat)a_bg{
    [self showWithContentView:v_content fromRect:rt bgColor:c_bg bgAlpha:a_bg editBgViewHandle:nil];
}

+(void)showWithContentView:(UIView *)v_content fromRect:(CGRect)rt bgColor:(UIColor *)c_bg bgAlpha:(CGFloat)a_bg editBgViewHandle:(void (^)(MEModelBackGroudView *))editHandle{
    MEModelBackGroudView *v_bg = [[MEModelBackGroudView alloc]initWithFrame:kIsIOS7?[[UIScreen mainScreen] bounds]:[[UIScreen mainScreen] applicationFrame]];
    v_bg.backgroundColor = [c_bg colorWithAlphaComponent:a_bg];
    if (editHandle) {
        editHandle(v_bg);
    }
    [kMeCurrentWindow addSubview:v_bg];
    
    v_content.frame = rt;
    [v_bg addSubview:v_content];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForBGView:)];
    [v_bg addGestureRecognizer:tap];
}

+(void)btnCloseAtModelAction:(UIButton *)sender{
    [sender.superview.superview removeFromSuperview];
}


+(void)showWithContentView:(UIView *)v fromRect:(CGRect)rt{
    [self showWithContentView:v fromRect:rt bgColor:[UIColor blackColor] bgAlpha:0.5];
}

+(void)showWithContentView:(UIView *)v{
    [self showWithContentView:v fromRect:v.frame];
}

+(void)showWithContentView:(UIView *)v_content bgAlpha:(CGFloat)a_bg{
    [self showWithContentView:v_content fromRect:v_content.frame bgColor:[UIColor blackColor] bgAlpha:a_bg];
}


+(void)showInView:(UIView *)superView contentVIew:(UIView *)aView editBgViewHandle:(void (^)(MEModelBackGroudView *))editHandle{
    [self closeModelViewFromView:superView];
    MEModelBackGroudView *viewBg = [[MEModelBackGroudView alloc]initWithFrame:CGRectMake(0, 0, superView.width, superView.height)];
    viewBg.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [viewBg addSubview:aView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForBGView:)];
    tap.cancelsTouchesInView = NO;
    [viewBg addGestureRecognizer:tap];
    
    if (editHandle) {
        editHandle(viewBg);
    }
    
    [superView addSubview:viewBg];
}

#pragma mark - close


//关闭modelView，aView为内容视图或内容视图的子视图
+(void)closeModelViewWithContentView:(UIView *)aView{
    if (![aView isKindOfClass:[UIView class]]) {
        return;
    }
    UIView *viewModelRoot = aView.superview;
    while (![viewModelRoot isKindOfClass:[MEModelBackGroudView class]]) {
        viewModelRoot = viewModelRoot.superview;
    }
    MEModelBackGroudView *viewBg = (MEModelBackGroudView *)viewModelRoot;
    if ([viewBg isKindOfClass:[MEModelBackGroudView class]]) {
        if (viewBg.blockCloseHandle) {
            viewBg.blockCloseHandle();
        }
        if (viewBg.blockCloseAnimate) {
            if (viewBg.animateWithDuration<=0.0) {
                viewBg.animateWithDuration = 0.25;
            }
            [UIView animateWithDuration:viewBg.animateWithDuration animations:^{
                viewBg.blockCloseAnimate();
            } completion:^(BOOL finished) {
                [viewBg removeFromSuperview];
            }];
            return;
        }
    }
    [viewBg removeFromSuperview];
}


+(void)closeModelViewFromView:(UIView *)aView{
    if (![aView isKindOfClass:[UIView class]]) {
        return;
    }
    MEModelBackGroudView *viewBg = (MEModelBackGroudView *)[aView subViewOfClass:[MEModelBackGroudView class]];
    //    if (bgView) {
    //        [bgView removeFromSuperview];
    //    }
    if ([viewBg isKindOfClass:[MEModelBackGroudView class]]) {
        if (viewBg.blockCloseHandle) {
            viewBg.blockCloseHandle();
        }
        if (viewBg.blockCloseAnimate) {
            if (viewBg.animateWithDuration<=0.0) {
                viewBg.animateWithDuration = 0.25;
            }
            [UIView animateWithDuration:viewBg.animateWithDuration animations:^{
                viewBg.blockCloseAnimate();
            } completion:^(BOOL finished) {
                [viewBg removeFromSuperview];
            }];
            return;
        }
    }
    [viewBg removeFromSuperview];
}

+(void)close{
    [self closeModelViewFromView:kMeCurrentWindow];
}


@end
