//
//  MEMessageTextField.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMessageTextField.h"

@interface MEMessageTextField ()<UITextFieldDelegate>

@end

@implementation MEMessageTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    self.returnKeyType = UIReturnKeyDone;
//    self.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = self.height/2;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchCancel];
    
}

- (void)textFieldDidChange:(UITextField *)tfInput{
    kMeCallBlock(self.contentBlock, [kMeUnNilStr(tfInput.text) trimSpace]);
}

//- (void)textFieldShouldReturn:(UITextField *)textField{
//    kMeCallBlock(_returnBlock);
//}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    kMeCallBlock(_returnBlock);
    return YES;
}

@end
