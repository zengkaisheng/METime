//
//  MELogisticsHeaderView.m
//  ME时代
//
//  Created by hank on 2018/10/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MELogisticsHeaderView.h"
#import "MEOrderDetailModel.h"

@interface MELogisticsHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCompand;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;

@end

@implementation MELogisticsHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    _lblNum.adjustsFontSizeToFitWidth = YES;
}

- (void)setUIWithModel:(MEOrderDetailModel *)model{
    _imgPic.image = [UIImage imageNamed:@"nnuxtriysjrh"];
//    kSDLoadImg(_imgPic,  MELoadQiniuImagesWithUrl(model.);
//    _lblStatus.text = kMeUnNilStr(@"");
    _lblStatus.hidden = YES;
    _lblCompand.text = @"百世汇通";
//    _lblNum.text = kMeUnNilStr(model.logistics.nu);
    
}

@end
