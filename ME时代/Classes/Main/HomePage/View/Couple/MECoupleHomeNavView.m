//
//  MECoupleHomeNavView.m
//  ME时代
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECoupleHomeNavView.h"

@interface MECoupleHomeNavView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTop;

@end

@implementation MECoupleHomeNavView

- (void)awakeFromNib{
    [super awakeFromNib];
    _conTop.constant = kMeStatusBarHeight;
    [self layoutIfNeeded];
}

- (IBAction)backAction:(UIButton *)sender {
    kMeCallBlock(_backBlock);
}

- (IBAction)searchAction:(UIButton *)sender {
    kMeCallBlock(_searchBlock);
}


@end
