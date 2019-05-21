//
//  UIView+SetRect.h
//  UIView
//
//  Created by JmoVxia on 2016/10/27.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  UIScreen width.
 */
#define  CLscreenWidth   SCREEN_WIDTH

/**
 *  UIScreen height.
 */
#define  CLscreenHeight  SCREEN_HEIGHT
//
//
///**
// *  Status bar height.
// */
//#define  CLstatusBarHeight      kMeStatusBarHeight
//
//
///**
// *  Tabbar height.
// */
//#define  CLtabbarHeight         kMeTabBarHeight


@interface UIView (CLSetRect)



/**
 控件起点
 */
@property (nonatomic) CGPoint CLviewOrigin;

/**
 控件大小
 */
@property (nonatomic) CGSize  CLviewSize;

/**
 控件起点x
 */
@property (nonatomic) CGFloat CLx;

/**
 控件起点Y
 */
@property (nonatomic) CGFloat CLy;

/**
 控件宽
 */
@property (nonatomic) CGFloat CLwidth;

/**
 控件高
 */
@property (nonatomic) CGFloat CLheight;

/**
 控件顶部
 */
@property (nonatomic) CGFloat CLtop;

/**
 控件底部
 */
@property (nonatomic) CGFloat CLbottom;

/**
 控件左边
 */
@property (nonatomic) CGFloat CLleft;

/**
 控件右边
 */
@property (nonatomic) CGFloat CLright;

/**
 控件中心点X
 */
@property (nonatomic) CGFloat CLcenterX;

/**
 控件中心点Y
 */
@property (nonatomic) CGFloat CLcenterY;

/**
 控件左下
 */
@property(readonly) CGPoint CLbottomLeft ;

/**
 控件右下
 */
@property(readonly) CGPoint CLbottomRight ;

/**
 控件左上
 */
@property(readonly) CGPoint CLtopLeft ;
/**
 控件右上
 */
@property(readonly) CGPoint CLtopRight ;


/**
 屏幕中心点X
 */
@property (nonatomic, readonly) CGFloat CLmiddleX;

/**
 屏幕中心点Y
 */
@property (nonatomic, readonly) CGFloat CLmiddleY;

/**
 屏幕中心点
 */
@property (nonatomic, readonly) CGPoint CLmiddlePoint;

/**
 控件size
 */
@property (nonatomic) CGSize size;



/**
 设置上边圆角
 */
- (void)setCornerOnTop:(CGFloat) conner;

/**
 设置下边圆角
 */
- (void)setCornerOnBottom:(CGFloat) conner;
/**
 设置左边圆角
 */
- (void)setCornerOnLeft:(CGFloat) conner;
/**
 设置右边圆角
 */
- (void)setCornerOnRight:(CGFloat) conner;

/**
 设置左上圆角
 */
- (void)setCornerOnTopLeft:(CGFloat) conner;

/**
 设置右上圆角
 */
- (void)setCornerOnTopRight:(CGFloat) conner;
/**
 设置左下圆角
 */
- (void)setCornerOnBottomLeft:(CGFloat) conner;
/**
 设置右下圆角
 */
- (void)setCornerOnBottomRight:(CGFloat) conner;


/**
 设置所有圆角
 */
- (void)setAllCorner:(CGFloat) conner;


@end
