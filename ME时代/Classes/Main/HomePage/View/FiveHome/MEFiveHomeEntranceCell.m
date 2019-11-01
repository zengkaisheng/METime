//
//  MEFiveHomeEntranceCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveHomeEntranceCell.h"
#import "METhridHomeModel.h"

@interface MEFiveHomeEntranceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MEFiveHomeEntranceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithModel:(METhridHomeAdModel *)model {
    kSDLoadImg(_imageView, kMeUnNilStr(model.ad_img));
}

@end
