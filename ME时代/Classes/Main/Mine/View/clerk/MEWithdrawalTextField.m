//
//  MEWithdrawalTextField.m
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEWithdrawalTextField.h"

@implementation MEWithdrawalTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)tfInput{
    kMeCallBlock(self.contentBlock, [kMeUnNilStr(tfInput.text) trimSpace]);
}

@end
