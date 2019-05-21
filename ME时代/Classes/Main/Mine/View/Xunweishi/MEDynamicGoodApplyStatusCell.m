//
//  MEDynamicGoodApplyStatusCell.m
//  SunSum
//
//  Created by hank on 2019/3/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEDynamicGoodApplyStatusCell.h"
#import "MEDynamicGoodApplyModel.h"

@interface MEDynamicGoodApplyStatusCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitme;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end

@implementation MEDynamicGoodApplyStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEDynamicGoodApplyModel *)model{
    _lblTitme.text = [NSString stringWithFormat:@"申请时间:%@",kMeUnNilStr(model.created_at)];
    NSString *str = @"";
    if([kMeUnArr(model.images) count]){
        str = model.images[0];
    }
    kSDLoadImg(_imgPic, str);
    _lblGoodName.text = kMeUnNilStr(model.goods_name);
    NSString *strstatus = @"";
    if(model.status == 1){
        strstatus = @"待审核";
    }else if (model.status == 2){
        strstatus = @"申请成功";
    }else if (model.status == 3){
        strstatus = @"申请失败";
    }
    _lblStatus.text = strstatus;
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.price)];
}


@end
