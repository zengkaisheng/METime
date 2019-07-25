//
//  MEHomeTestAddContentCell.m
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeTestAddContentCell.h"
#import "MEHomeAddTestDecModel.h"
#import "MEBlockTextField.h"
@interface MEHomeTestAddContentCell()
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfTitle;

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfA;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfB;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfC;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfD;

@property (nonatomic, strong) MEHomeAddTestDecContentModel *model;
@end
@implementation MEHomeTestAddContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setUiWithModel:(MEHomeAddTestDecContentModel *)model{
    _model = model;
    kMeWEAKSELF
    _tfTitle.text = kMeUnNilStr(model.content);
    _tfTitle.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.content = kMeUnNilStr(str);
    };
    
    _tfA.text = kMeUnNilStr(model.option1);
    _tfA.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.option1 = kMeUnNilStr(str);
    };
    
    _tfB.text = kMeUnNilStr(model.option2);
    _tfB.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.option2 = kMeUnNilStr(str);
    };
    
    _tfC.text = kMeUnNilStr(model.option3);
    _tfC.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.option3 = kMeUnNilStr(str);
    };
    
    _tfD.text = kMeUnNilStr(model.option4);
    _tfD.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.option4 = kMeUnNilStr(str);
    };
}

@end
