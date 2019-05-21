//
//  MEAIHomeVC.m
//  ME时代
//
//  Created by hank on 2019/4/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAIHomeVC.h"
#import "MENavigationVC.h"
#import "MERCConversationListVC.h"
#import "MEEnlargeTouchButton.h"
#import "MEAIDataHomeVC.h"
#import "MEAICustomerHomeVC.h"

@interface MEAIHomeVC ()

@property (strong, nonatomic) MEEnlargeTouchButton *btnRight;


@end

@implementation MEAIHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.delegate = self;
//    self.tabBar.translucent = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    // 1.初始化子控制器
    MEAIDataHomeVC *aiVC = [[MEAIDataHomeVC alloc] init];
    aiVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
    [self addChildVc:aiVC title:@"雷达" image:@"Aiai" selectedImage:@"Aiai_s"];
    
    MERCConversationListVC *message = [[MERCConversationListVC alloc] init];
    message.isAi = YES;
    message.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
    [self addChildVc:message title:@"消息" image:@"AImessage" selectedImage:@"AImessage_s"];
    
    
    MEAICustomerHomeVC *customer = [[MEAICustomerHomeVC alloc] init];
    customer.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
    [self addChildVc:customer title:@"客户" image:@"Aicustomer" selectedImage:@"Aicustomer_s"];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName :kMEblack
                                                        } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName :kMEblack
                                                        } forState:UIControlStateNormal];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MENavigationVC *nav = (MENavigationVC *)self.navigationController;
    nav.canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MENavigationVC *nav = (MENavigationVC *)self.navigationController;
    nav.canDragBack = YES;;
}

#pragma mark - Private Method

- (void)popBackAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    childVc.title=title;
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
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
