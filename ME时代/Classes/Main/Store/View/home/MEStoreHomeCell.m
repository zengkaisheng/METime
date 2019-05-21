//
//  MEStoreHomeCell.m
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEStoreHomeCell.h"
#import "MEStarControl.h"
#import "MEStoreModel.h"

#define kImgHeight (220 *kMeFrameScaleY())

@interface MEStoreHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet MEStarControl *starView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgWdith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgHeight;
//8 70 12

@end

@implementation MEStoreHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _consImgWdith.constant = kImgWdith;
    _consImgHeight.constant = kImgHeight;
}

- (void)setUIWithModel:(MEStoreModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.mask_img)));
    _lblTitle.text = kMeUnNilStr(model.store_name);
    _lblSubTitle.text =[NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
    _starView.score = model.stars;
}

- (void)setUIWithModel:(MEStoreModel *)model WithKey:(NSString *)key{
    [self setUIWithModel:model];
    if(kMeUnNilStr(key).length>0){
        _lblTitle.text = nil;
        _lblTitle.attributedText = [kMeUnNilStr(model.store_name) attributeWithRangeOfString:key color:kMEPink];
        _lblSubTitle.text = nil;
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
        _lblSubTitle.attributedText = [address attributeWithRangeOfString:key color:kMEPink];
    }
}

+ (CGFloat)getCellHeightWithModel:(MEStoreModel *)model{
    CGFloat height = kMEStoreHomeCellHeight;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
    CGFloat addressHeight = [NSAttributedString heightForAtsWithStr:address font:[UIFont systemFontOfSize:12] width:(SCREEN_WIDTH - 30-33) lineH:0 maxLine:2];
    if(addressHeight>15){
        height  =  height-15+addressHeight;
        return height;
    }
    return height;
    
}

@end
