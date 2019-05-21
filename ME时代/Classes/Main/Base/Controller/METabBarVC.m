//
//  METabBarVC.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "METabBarVC.h"
#import "MENavigationVC.h"
//#import "MEHomePageVC.h"
#import "METhridHomeVC.h"
#import "MEStoreHomeVC.h"
#import "MEMemberHomeVC.h"
#import "MEShoppingCartVC.h"
//#import "MEMineHomeVC.h"
#import "MENewMineHomeVC.h"
#import "ZLWebVC.h"
#import "MEProductShoppingCartVC.h"
#import "MELoginVC.h"
#import "MEIMageVC.h"
#import "AppDelegate.h"
#import "MEMemberHomeVC.h"

#import "MESNewHomePageVC.h"
#import "MEBynamicHomeVC.h"
//#import "MEShoppingMallVC.h"
#import "MEFilterGoodVC.h"

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
    METhridHomeVC *home = [[METhridHomeVC alloc] init];
    [self addChildVc:home title:@"首页" image:@"home" selectedImage:@"home_s"];
    
//    MEStoreHomeVC *store = [[MEStoreHomeVC alloc] init];
    MEFilterGoodVC *filter = [[MEFilterGoodVC alloc]initWithcategory_id:@"0" title:@"优选"];
    filter.isHome = YES;
    //    MEIMageVC *store = [[MEIMageVC alloc]initWithType:MEMainStoreStyle];
    [self addChildVc:filter title:@"优选" image:@"store" selectedImage:@"store_s"];
    
    
    MEBynamicHomeVC *dynamic = [[MEBynamicHomeVC alloc] init];
    //    MEIMageVC *store = [[MEIMageVC alloc]initWithType:MEMainStoreStyle];
    [self addChildVc:dynamic title:@"动态" image:@"dynamic" selectedImage:@"dynamic_s"];
    //    MEMemberHomeVC *member = [[MEMemberHomeVC alloc]init];
    ////    MEIMageVC *member = [[MEIMageVC alloc]initWithType:MEMainMemberStyle];
    ////    member.isNeedH5Title = NO;
    //    //[self.navigationController pushViewController:webVC animated:YES];
    //    //MEMemberHomeVC *member = [[MEMemberHomeVC alloc] init];
    //    [self addChildVc:member title:@"超级会员" image:@"hat" selectedImage:@"hat"];
    
    MEProductShoppingCartVC *shopcart = [[MEProductShoppingCartVC alloc] init];
    [self addChildVc:shopcart title:@"购物车" image:@"shopcart" selectedImage:@"shopcart_s"];
    
    self.mine = [[MENewMineHomeVC alloc] init];
    [self addChildVc:self.mine  title:@"我的" image:@"mine" selectedImage:@"mine_s"];
    [self getUnMeaasge];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName :kMEPink
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
    childVc.title=title;
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:childVc];
    if([title isEqualToString:@"首页"]){
        childVc.title =@"ME时代会员优选";
        childVc.tabBarItem.title=@"首页";
    }
//    if([title isEqualToString:@"店铺"]){
//        childVc.title =@"店铺";
//        childVc.tabBarItem.title=@"店铺";
//    }
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{//每次点击都会执行的方法
    if([viewController.tabBarItem.title isEqualToString:@"购物车"]||[viewController.tabBarItem.title isEqualToString:@"我的"]||[viewController.tabBarItem.title isEqualToString:@"动态"]){
        if([MEUserInfoModel isLogin]){
            return YES;
        }
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            
        } failHandler:^(id object) {
            
        }];
        return NO;
        
    }
    return YES;
    
}
@end
