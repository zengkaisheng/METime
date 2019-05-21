//
//  MEExitVC.m
//  ME时代
//
//  Created by hank on 2018/11/2.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEExitVC.h"

@interface MEExitVC ()

@end

@implementation MEExitVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提示";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)UpdateAction:(UIButton *)sender {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",kMEAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}



@end
