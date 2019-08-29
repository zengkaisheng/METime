//
//  MENewTabBarVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewTabBarVC.h"
#import "MENavigationVC.h"
#import "AppDelegate.h"

#import "MEOnlineCourseVC.h"
#import "MEOperateVC.h"
#import "MEStatisticsVC.h"
#import "MENewMineHomeVC.h"

@interface MENewTabBarVC ()<UITabBarControllerDelegate>

@property (nonatomic, strong) MENewMineHomeVC *mine;


@end

@implementation MENewTabBarVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // 1.初始化子控制器
    //在线课程
    MEOnlineCourseVC *course = [[MEOnlineCourseVC alloc] init];
    [self addChildVc:course title:@"课程" image:@"tabbar_course_nor" selectedImage:@"tabbar_course_sel"];
    
    //运营
    MEOperateVC *operate = [[MEOperateVC alloc] init];
    [self addChildVc:operate title:@"运营" image:@"tabbar_operate_nor" selectedImage:@"tabbar_operate_sel"];
    
    //数据统计
    MEStatisticsVC *statistics = [[MEStatisticsVC alloc] init];
    [self addChildVc:statistics title:@"诊断反馈" image:@"tabbar_feedBack_nor" selectedImage:@"tabbar_feedBack_sel"];
    
    self.mine = [[MENewMineHomeVC alloc] init];
    [self addChildVc:self.mine title:@"我的" image:@"tabbar_me_nor" selectedImage:@"tabbar_me_sel"];
    
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
    if([title isEqualToString:@"课程"]){
        childVc.title =@"在线课程";
        childVc.tabBarItem.title=@"课程";
    }
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
