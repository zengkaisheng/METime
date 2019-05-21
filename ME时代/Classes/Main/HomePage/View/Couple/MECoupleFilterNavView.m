//
//  MECoupleFilterNavView.m
//  ME时代
//
//  Created by hank on 2018/12/24.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MECoupleFilterNavView.h"

@interface MECoupleFilterNavView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;

@end

@implementation MECoupleFilterNavView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consTopMargin.constant = kMeStatusBarHeight;
}



- (IBAction)backAction:(UIButton *)sender {
    kMeCallBlock(_backBlock);
}

- (IBAction)searchAction:(UIButton *)sender {
    kMeCallBlock(_searchBlock);
}

@end
