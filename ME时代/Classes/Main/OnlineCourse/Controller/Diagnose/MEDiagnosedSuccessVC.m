//
//  MEDiagnosedSuccessVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnosedSuccessVC.h"
#import "MEOnlineCourseVC.h"

@interface MEDiagnosedSuccessVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConsHeight;

@end

@implementation MEDiagnosedSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBarHidden = YES;
    _topViewConsHeight.constant = kMeNavBarHeight;
}

- (IBAction)backAction:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MEOnlineCourseVC class]]) {
            kNoticeReloadUI
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


@end
