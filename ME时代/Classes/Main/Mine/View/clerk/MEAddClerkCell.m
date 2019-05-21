//
//  MEAddClerkCell.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAddClerkCell.h"
#import "MEClerkModel.h"

@interface MEAddClerkCell (){
    MEClerkModel *_model;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end

@implementation MEAddClerkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWIthModel:(MEClerkModel *)model{
    _model = model;
    kSDLoadImg(_imgHeader, kMeUnNilStr(model.header_pic));
    _lblName.text = kMeUnNilStr(model.name);
    _lblTime.text = kMeUnNilStr(model.cellphone);
}

- (void)setUIWithModel:(MEClerkModel *)model withKey:(NSString *)key{
    [self setUIWIthModel:model];
    if(kMeUnNilStr(key).length>0){
        _lblName.text = nil;
        _lblName.attributedText = [kMeUnNilStr(model.name) attributeWithRangeOfString:key color:kMEPink];
        _lblTime.text = nil;
        _lblTime.attributedText = [kMeUnNilStr(model.cellphone) attributeWithRangeOfString:key color:kMEPink];
    }
}

- (IBAction)updatClerkAction:(UIButton *)sender {
    kMeCallBlock(_updateBlock);
}

@end
