//
//  METopUpSuccessVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "METopUpSuccessVC.h"

@interface METopUpSuccessVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (nonatomic, copy) kMeBasicBlock confirmBlock;
@property (nonatomic, strong) NSString *money;

@end

@implementation METopUpSuccessVC

- (instancetype)initWithMoney:(NSString *)money sucessConfireBlock:(kMeBasicBlock)block{
    if(self = [super init]){
        self.money = money;
        self.confirmBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _consTop.constant = kMeNavBarHeight+62;
    _moneyLbl.text = [NSString stringWithFormat:@"￥%@",kMeUnNilStr(self.money)];
}

- (IBAction)finishAction:(id)sender {
    kMeCallBlock(self.confirmBlock);
}


@end
