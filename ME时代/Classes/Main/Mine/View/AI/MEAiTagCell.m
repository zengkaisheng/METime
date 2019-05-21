//
//  MEAiTagCell.m
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAiTagCell.h"
#import "MEAiCustomerTagModel.h"

@interface MEAiTagCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation MEAiTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblContent.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEAiCustomerTagchildrenModel *)model{
    _lblContent.text = kMeUnNilStr(model.label_name);
    _lblContent.backgroundColor = model.isSelect ? [UIColor colorWithHexString:@"d8f1d3"]:[UIColor colorWithHexString:@"f1f2f6"];
    _lblContent.textColor = model.isSelect ? [UIColor colorWithHexString:@"55ba14"]:[UIColor colorWithHexString:@"747474"];
}

@end
