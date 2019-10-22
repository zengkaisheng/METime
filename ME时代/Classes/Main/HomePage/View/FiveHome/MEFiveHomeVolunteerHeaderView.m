//
//  MEFiveHomeVolunteerHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/10/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveHomeVolunteerHeaderView.h"
#import "METhridHomeModel.h"

@interface MEFiveHomeVolunteerHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

@end


@implementation MEFiveHomeVolunteerHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithModel:(METhridHomeModel *)model {
    MEFiveHomeModulesModel *modulesModel = model.modules;
    METhridHomeAdModel *adModel = nil;
    
    NSArray *left_img = kMeUnArr(modulesModel.left_img);
    if (left_img.count > 0) {
        adModel = (METhridHomeAdModel *)left_img.firstObject;
        kSDLoadImg(_leftImageView, kMeUnNilStr(adModel.ad_img));
    }
    
    NSArray *right_top_img = kMeUnArr(modulesModel.right_top_img);
    if (right_top_img.count > 0) {
        adModel = (METhridHomeAdModel *)right_top_img.firstObject;
        kSDLoadImg(_rightTopImageView, kMeUnNilStr(adModel.ad_img));
    }
    
    NSArray *right_bottom_img = kMeUnArr(modulesModel.right_bottom_img);
    if (right_bottom_img.count > 0) {
        adModel = (METhridHomeAdModel *)right_bottom_img.firstObject;
        kSDLoadImg(_rightBottomImageView, kMeUnNilStr(adModel.ad_img));
    }
}

- (IBAction)leftImageVAction:(id)sender {
    kMeCallBlock(self.selectIndexBlock,0);
}

- (IBAction)rightTopImageVAction:(id)sender {
    kMeCallBlock(self.selectIndexBlock,1);
}

- (IBAction)rightBottomImageVAction:(id)sender {
    kMeCallBlock(self.selectIndexBlock,2);
}

@end
