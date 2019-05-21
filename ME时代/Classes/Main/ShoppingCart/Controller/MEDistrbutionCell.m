//
//  MEDistrbutionCell.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDistrbutionCell.h"

@interface MEDistrbutionCell(){
    NSArray *_arrImage;
    NSArray *_arrTitle;

}
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@end

@implementation MEDistrbutionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _arrImage = MEDistrbutionCellStyleImage;
    _arrTitle = MEDistrbutionCellStyleTitle;
    // Initialization code
}

- (void)setUIWithtype:(MEDistrbutionCellStyle)type subtitle:(NSString *)subTitle{
    _lblSubTitle.hidden = type == MEMyCode;
    _imgPic.image = kMeGetAssetImage(_arrImage[type]);
    _lblTitle.text = _arrTitle[type];
    _lblSubTitle.text = kMeUnNilStr(subTitle);
}

@end
