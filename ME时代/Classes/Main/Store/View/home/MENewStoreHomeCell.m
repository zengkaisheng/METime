//
//  MENewStoreHomeCell.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MENewStoreHomeCell.h"
#import "MEStarControl.h"
#import "MEStoreModel.h"
#import "MEFlowLabelView.h"

@interface MENewStoreHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet MEStarControl *starView;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet MEFlowLabelView *flowLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consflowHeight;

@end

@implementation MENewStoreHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblDistance.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEStoreModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.mask_img)));
    _lblTitle.text = kMeUnNilStr(model.store_name);
    _lblAddress.text =[NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
    _starView.score = model.stars;
    _lblScore.text = [NSString stringWithFormat:@"%@分",@(model.stars).description];
    _lblDistance.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.distance)];
    if(kMeUnArr(model.label).count){
        _flowLabelView.hidden = NO;
        _consflowHeight.constant = [MEFlowLabelView getMEFlowLabelViewHeightWithArr:kMeUnArr(model.label)];
        [_flowLabelView reloaWithArr:kMeUnArr(model.label)];
    }else{
        _flowLabelView.hidden = YES;
        _consflowHeight.constant = 0;
    }
    
}

- (void)setUIWithModel:(MEStoreModel *)model WithKey:(NSString *)key{
    [self setUIWithModel:model];
    if(kMeUnNilStr(key).length>0){
        _lblTitle.text = nil;
        _lblTitle.attributedText = [kMeUnNilStr(model.store_name) attributeWithRangeOfString:key color:kMEPink];
        _lblAddress.text = nil;
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
        _lblAddress.attributedText = [address attributeWithRangeOfString:key color:kMEPink];
    }
}

+ (CGFloat)getCellHeightWithmodel:(MEStoreModel *)model{
    if(kMeUnArr(model.label).count){
        CGFloat height = kMENewStoreHomeCellHeight;
        height +=[MEFlowLabelView getMEFlowLabelViewHeightWithArr:kMeUnArr(model.label)];
        height+=13;
        return height;
    }else{
        return kMENewStoreHomeCellHeight+13;
    }
}


@end
