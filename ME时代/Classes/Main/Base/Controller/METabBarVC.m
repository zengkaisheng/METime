//
//  METabBarVC.m
//  志愿星
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "METabBarVC.h"
#import "MENavigationVC.h"
//#import "MEHomePageVC.h"
//#import "METhridHomeVC.h"
//#import "MEStoreHomeVC.h"
//#import "MEMemberHomeVC.h"
//#import "MEShoppingCartVC.h"
//#import "MEMineHomeVC.h"
#import "MENewMineHomeVC.h"
//#import "ZLWebVC.h"
#import "MEProductShoppingCartVC.h"
//#import "MELoginVC.h"
//#import "MEIMageVC.h"
#import "AppDelegate.h"

//#import "MESNewHomePageVC.h"
#import "MEBynamicHomeVC.h"
//#import "MEShoppingMallVC.h"
//#import "MEFilterGoodVC.h"

#import "MENewFilterGoodVC.h"
#import "MEFourHomeVC.h"
#import "MEPersonalCourseVC.h"

#import "MEFiveHomeVC.h"

@interface METabBarVC ()<UITabBarControllerDelegate>

@property (nonatomic, strong) MENewMineHomeVC *mine;
@end

@implementation METabBarVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // 1.初始化子控制器
//    METhridHomeVC *home = [[METhridHomeVC alloc] init];
//    第四版
//    MEFourHomeVC *home = [[MEFourHomeVC alloc] init];
//    第五版
    MEFiveHomeVC *home = [[MEFiveHomeVC alloc] init];
    [self addChildVc:home title:@"首页" image:@"home" selectedImage:@"icon_Home_sel"];
    
    //课程
    MEPersonalCourseVC *courseVC = [[MEPersonalCourseVC alloc] init];
    [self addChildVc:courseVC title:@"课堂" image:@"course" selectedImage:@"course_s"];
    
//    MEIMageVC *store = [[MEIMageVC alloc]initWithType:MEMainStoreStyle];
//    MEStoreHomeVC *store = [[MEStoreHomeVC alloc] init];
//    MEFilterGoodVC *filter = [[MEFilterGoodVC alloc]initWithcategory_id:@"0" title:@"优选"];
//    filter.isHome = YES;
//    [self addChildVc:filter title:@"优选" image:@"store" selectedImage:@"store_s"];
    
    MEBynamicHomeVC *dynamic = [[MEBynamicHomeVC alloc] init];
    //    MEIMageVC *store = [[MEIMageVC alloc]initWithType:MEMainStoreStyle];
    [self addChildVc:dynamic title:@"动态" image:@"dynamic" selectedImage:@"dynamic_s"];
    //    MEMemberHomeVC *member = [[MEMemberHomeVC alloc]init];
    ////    MEIMageVC *member = [[MEIMageVC alloc]initWithType:MEMainMemberStyle];
    ////    member.isNeedH5Title = NO;
    //    //[self.navigationController pushViewController:webVC animated:YES];
    //    //MEMemberHomeVC *member = [[MEMemberHomeVC alloc] init];
    //    [self addChildVc:member title:@"超级会员" image:@"hat" selectedImage:@"hat"];
    
//    MEProductShoppingCartVC *shopcart = [[MEProductShoppingCartVC alloc] init];
//    [self addChildVc:shopcart title:@"购物车" image:@"shopcart" selectedImage:@"shopcart_s"];
    MENewFilterGoodVC *filter = [[MENewFilterGoodVC alloc] init];
    [self addChildVc:filter title:@"福利" image:@"store" selectedImage:@"store_s"];
    
    self.mine = [[MENewMineHomeVC alloc] init];
    [self addChildVc:self.mine title:@"我的" image:@"mine" selectedImage:@"mine_s"];
    [self getUnMeaasge];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName :[UIColor colorWithHexString:@"#ff88a4"]
                                                        } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName :kMEblack
                                                        } forState:UIControlStateNormal];
    if([MEUserInfoModel isLogin]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnMeaasge) name:kUnMessage object:nil];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
}
- (void)userLogout{
    self.mine.tabBarItem.badgeValue = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kUnMessage object:nil];
}

- (void)userLogin{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnMeaasge) name:kUnMessage object:nil];
}

- (void)getUnMeaasge{
    if([MEUserInfoModel isLogin]){
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSInteger unmessgae = appDelegate.unMessageCount;
            NSString *str = @(unmessgae).description;
            if(appDelegate.unMessageCount>99){
                str = @"99+";
            }
            self.mine.tabBarItem.badgeValue = unmessgae==0?nil:str;
        });
    }
}

#pragma mark - Private Method
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    childVc.title = title;
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:childVc];
    if([title isEqualToString:@"首页"]){
        childVc.title =@"志愿星";
        childVc.tabBarItem.title = @"";
        childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{//每次点击都会执行的方法
    if([viewController.tabBarItem.title isEqualToString:@"我的"]||[viewController.tabBarItem.title isEqualToString:@"动态"]){
        for (UIViewController *vc in tabBarController.viewControllers) {
            if ([vc.title isEqualToString:@"志愿星"]) {
                vc.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                vc.tabBarItem.title = @"首页";
                [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        }
        if([MEUserInfoModel isLogin]){
            return YES;
        }
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            
        } failHandler:^(id object) {
            
        }];
        return NO;
        
    }else if ([viewController.tabBarItem.title isEqualToString:@"课堂"] || [viewController.tabBarItem.title isEqualToString:@"福利"]) {
        for (UIViewController *vc in tabBarController.viewControllers) {
            if ([vc.title isEqualToString:@"志愿星"]) {
                vc.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                vc.tabBarItem.title = @"首页";
                [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        }
        return YES;
    }else if ([viewController.title isEqualToString:@"志愿星"]) {
        viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_Home_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.title = @"";
        [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        return YES;
    }
    return YES;
}

@end
