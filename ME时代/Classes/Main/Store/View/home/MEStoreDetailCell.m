//
//  MEStoreDetailCell.m
//  ME时代
//
//  Created by hank on 2018/10/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEStoreDetailCell.h"
#import "MEGoodModel.h"

@interface MEStoreDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointNum;


@end


@implementation MEStoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEGoodModel *)model{
    kSDLoadImg(_imgPic,  MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSubTitle.text = kMeUnNilStr(model.title);
    _lblAppointNum.text = [NSString stringWithFormat:@"%@人预约",kMeUnNilStr(model.reserve_num)];
}

@end
