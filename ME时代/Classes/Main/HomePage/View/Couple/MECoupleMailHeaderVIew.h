//
//  MECoupleMailHeaderVIew.h
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MECoupleModel;
@class MEPinduoduoCoupleInfoModel;
@class MEJDCoupleModel;
#define MECoupleMailHeaderVIewHeight (SCREEN_WIDTH + 205)

@interface MECoupleMailHeaderVIew : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
- (void)setUIWithModel:(MECoupleModel *)model;
- (void)setPinduoduoUIWithModel:(MEPinduoduoCoupleInfoModel *)model;
@property (nonatomic ,copy)kMeBasicBlock getCoupleBlock;
- (void)setJDUIWithModel:(MEJDCoupleModel *)model;


@end
