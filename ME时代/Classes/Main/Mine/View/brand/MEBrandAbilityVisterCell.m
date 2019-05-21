//
//  MEBrandAbilityVisterCell.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAbilityVisterCell.h"
#import "MEBrandAbilityVisterModel.h"

@interface MEBrandAbilityVisterCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;


@end

@implementation MEBrandAbilityVisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUiWithModel:(MEBrandAbilityVisterModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.header_pic));
    _lblName.text = kMeUnNilStr(model.nick_name);
    _lblTime.text = kMeUnNilStr(model.created_at);
}

@end
