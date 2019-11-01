//
//  MEChooseStatusVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEChooseStatusVC.h"

@interface MEChooseStatusVC ()

@end

@implementation MEChooseStatusVC

+ (void)presentChooseStatusVCWithIndexBlock:(kMeIndexBlock)indexBlock{
    MEChooseStatusVC *statusVC = [[MEChooseStatusVC alloc]init];
    statusVC.indexBlock = indexBlock;
    [MECommonTool presentViewController:statusVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarHidden = YES;
}

- (IBAction)applyStoreAction:(id)sender {
    kMeWEAKSELF
    [MECommonTool dismissViewControllerAnimated:YES completion:^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.indexBlock,1);
    }];
}
- (IBAction)personAction:(id)sender {
    kMeWEAKSELF
    [MECommonTool dismissViewControllerAnimated:YES completion:^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.indexBlock,2);
    }];
}

@end
