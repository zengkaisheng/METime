//
//  MENavigationVC.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENavigationVC.h"
#import "MEEnlargeTouchButton.h"

#define kTOP_VIEW kMeKeyWindow.rootViewController.view
const float kMargin = 60;

@interface MENavigationVC ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    CGPoint startTouch;
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) NSMutableArray *screenShotsList;
@property (nonatomic,assign) BOOL isMoving;

@end

@implementation MENavigationVC

#pragma mark - LEFT CRICY

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    self.canDragBack = YES;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:(BOOL)animated];
    if (self.screenShotsList.count == 0) {
        UIImage *capturedImage = [MENavigationVC capture];
        if (capturedImage) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
}

- (void)viewDidLayoutSubviews{
    UIView *bgVIew = [self.navigationBar subViewOfContainDescription:@"UINavigationBarBackground"];
    if (bgVIew) {
        UIImageView *imgv = (UIImageView *)[bgVIew subViewOfClass:[UIImageView class]];
        if (imgv && imgv.height==0.5) {
            imgv.image = nil;
            imgv.backgroundColor = [UIColor blackColor];
            imgv.alpha = 0.1;
        }
    }
}


#pragma mark - Father Class

- (void)setNormalState{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.translucent = YES ;
    //navigationBar.translucent = YES;
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kMeColor(48, 48, 48),
                                          NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] =[UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];;
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)setImgvState{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark -
#pragma mark - Utility Methods -

+ (UIImage *)capture{
    UIView *aView = kMeCurrentWindow;
    if (!aView) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 0.0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)moveViewWithX:(float)x{
    x = x>SCREEN_WIDTH?SCREEN_WIDTH:x;
    x = x<0?0:x;
    CGRect frame = kTOP_VIEW.frame;
    frame.origin.x = x;
    kTOP_VIEW.frame = frame;
    
    float scale = 1.0;//
    float alpha = 0.4 - (x/800);
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1 || !self.canDragBack) return NO;
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count >1) {
        return YES;
    }
    return NO;
}

#pragma mark - Action

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    CGPoint touchPoint = [recoginzer locationInView:kMeKeyWindow];
    BOOL shouldPop = [recoginzer velocityInView:self.view].x>0?YES:NO;
    CGFloat trans = [recoginzer translationInView:self.view].x;
    if (fabs(trans)<kMargin) {
        shouldPop = NO;
    }
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        if (touchPoint.x>SCREEN_WIDTH) {
            return;
        }
        _isMoving = YES;
        startTouch = touchPoint;
        if (!self.backgroundView){
            CGRect frame = kTOP_VIEW.frame;
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [kTOP_VIEW.superview insertSubview:self.backgroundView belowSubview:kTOP_VIEW];
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        if (!_isMoving) {
            return;
        }
        if (shouldPop){
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:SCREEN_WIDTH];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = kTOP_VIEW.frame;
                frame.origin.x = 0;
                kTOP_VIEW.frame = frame;
                
                _isMoving = NO;
                self.backgroundView.hidden = YES;
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIImage *capturedImage = [MENavigationVC capture];
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem enlargeTouchitemWithTarget:self action:@selector(popBackAction:) image:@"icon-tmda" highImage:@"icon-tmda"];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)popBackAction:(UIButton *)btn{
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self moveViewWithX:0];
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

- (MEEnlargeTouchButton *)btnRight{
    MEEnlargeTouchButton *btnRight= [MEEnlargeTouchButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 70, 25);
    [btnRight setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
    [btnRight setTitle:@"返回" forState:UIControlStateNormal];
    btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 26);
    btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [btnRight setTitleColor:[UIColor colorWithHexString:@"e3e3e3"] forState:UIControlStateNormal];
    btnRight.titleLabel.font = kMeFont(15);
    [btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(popBackAction:) forControlEvents:UIControlEventTouchUpInside];
    return btnRight;
}



@end
