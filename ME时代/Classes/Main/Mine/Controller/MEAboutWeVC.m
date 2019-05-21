//
//  MEAboutWeVC.m
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAboutWeVC.h"

@interface MEAboutWeVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;

@end

@implementation MEAboutWeVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    _consTopMargin.constant = kMeNavBarHeight;
    _lblVersion.text = [NSString stringWithFormat:@"ver%@",kMEAppVersion];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
 
#pragma mark - Public
 
#pragma mark - Private
 
#pragma mark - Getter
 
#pragma mark - Setter

@end
