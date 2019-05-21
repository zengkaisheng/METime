//
//  MeHomeNewGuideCell.m
//  ME时代
//
//  Created by hank on 2019/5/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MeHomeNewGuideCell.h"
#import "MeHomeNewGuideModel.h"

@interface MeHomeNewGuideCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgpic;


@end

@implementation MeHomeNewGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWitModel:(MeHomeNewGuideModel *)model{
    kSDLoadImg(_imgpic, kMeUnNilStr(model.image));
}

+ (CGFloat)getCellHeight{
    CGFloat height = 14;
    CGFloat w = SCREEN_WIDTH - 24;
    height += ((w * 150)/351);
    return height;
}

@end
