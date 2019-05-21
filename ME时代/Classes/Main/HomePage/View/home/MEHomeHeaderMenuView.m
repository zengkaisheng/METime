//
//  MEHomeHeaderMenuView.m
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomeHeaderMenuView.h"
#import "MEHomePageVC.h"
#import "MEActiveVC.h"

@implementation MEHomeHeaderMenuView

#pragma mark - Action

- (IBAction)collageAction:(UIButton *)sender {
    kMeAlter(@"提示", @"敬请期待");
}

- (IBAction)SecKillseconAction:(UIButton *)sender {
    kMeAlter(@"提示", @"敬请期待");
}


- (IBAction)activeAction:(UIButton *)sender {
    MEHomePageVC *home = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:self];
    if(home){
        MEActiveVC *avc = [[MEActiveVC alloc]init];
        [home.navigationController pushViewController:avc animated:YES];
    }
}

- (IBAction)cutDownAction:(UIButton *)sender {
    kMeAlter(@"提示", @"敬请期待");
}


@end
