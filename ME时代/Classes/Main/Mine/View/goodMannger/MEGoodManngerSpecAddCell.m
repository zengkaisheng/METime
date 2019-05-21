//
//  MEGoodManngerSpecAddCell.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEGoodManngerSpecAddCell.h"
#import "MEGoodManngerGoodSpec.h"
#import "MEBlockTextField.h"

@interface MEGoodManngerSpecAddCell ()


@property (weak, nonatomic) IBOutlet UILabel *lblSpec;

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfContent;

@end

@implementation MEGoodManngerSpecAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblSpec.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEGoodManngerGoodSpec *)model{
    _lblSpec.text = kMeUnNilStr(model.spec_name);
    _tfContent.contentBlock = ^(NSString *str) {
        model.specContent = kMeUnNilStr(str);
    };
    _tfContent.text = kMeUnNilStr(model.specContent);
}

@end
