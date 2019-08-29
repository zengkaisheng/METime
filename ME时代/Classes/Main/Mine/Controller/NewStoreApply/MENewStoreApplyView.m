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
    _tfname.text = kMeUnNilStr(_model.name);
    
    _tfstore_name.text = kMeUnNilStr(_model.store_name);
    
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
