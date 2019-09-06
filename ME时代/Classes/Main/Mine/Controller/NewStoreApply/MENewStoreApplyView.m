//
//  MENewStoreApplyView.m
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewStoreApplyView.h"
#import "MEStoreApplyParModel.h"
#import "MEBlockTextField.h"
#import "ZHMapAroundInfoViewController.h"

@interface MENewStoreApplyView ()

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfTrue_name;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfname;

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfstore_name;

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfaddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPCD;

@end

@implementation MENewStoreApplyView

- (void)setModel:(MEStoreApplyParModel *)model{
    _model = model;
    kMeWEAKSELF
    self.tfTrue_name.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_model.true_name = str;
    };
    
    self.tfname.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_model.name = str;
    };
    
    self.tfstore_name.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_model.store_name = str;
    };
    
    
    self.tfaddress.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_model.address = str;
    };
}

- (void)reloadUI{
    
    _tfTrue_name.text = kMeUnNilStr(_model.true_name);
    kMeWEAKSELF
    _tfTrue_name.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 10) {
            str = [str substringWithRange:NSMakeRange(0, 10)];
            strongSelf->_tfTrue_name.text = str;
            [strongSelf->_tfTrue_name endEditing:YES];
        }
        strongSelf->_model.true_name = str;
    };
    _tfname.text = kMeUnNilStr(_model.name);
    _tfname.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 10) {
            str = [str substringWithRange:NSMakeRange(0, 10)];
            strongSelf->_tfname.text = str;
            [strongSelf->_tfname endEditing:YES];
        }
        strongSelf->_model.name = str;
    };
    
    _tfstore_name.text = kMeUnNilStr(_model.store_name);
    _tfstore_name.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 10) {
            str = [str substringWithRange:NSMakeRange(0, 10)];
            strongSelf->_tfstore_name.text = str;
            [strongSelf->_tfstore_name endEditing:YES];
        }
        strongSelf->_model.store_name = str;
    };
    
    self.tfaddress.text = kMeUnNilStr(_model.address);
    self.lblPCD.text = [NSString stringWithFormat:@"%@ %@ %@",kMeUnNilStr(_model.province),kMeUnNilStr(_model.city),kMeUnNilStr(_model.district)];
}


- (IBAction)locationAction:(UIButton *)sender {
    kMeCallBlock(_locationBlock);
}

- (IBAction)applyAction:(UIButton *)sender {
    kMeCallBlock(_applyBlock);
}

@end
