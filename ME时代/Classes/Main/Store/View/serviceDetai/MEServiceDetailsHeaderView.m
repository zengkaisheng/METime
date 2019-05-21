//
//  MEServiceDetailsHeaderView.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEServiceDetailsHeaderView.h"
#import "SDCycleScrollView.h"
#import "MEGoodDetailModel.h"

@interface MEServiceDetailsHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCommonPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointmentNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSdHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

//@property (weak, nonatomic) IBOutlet UILabel *lblAction;
@end

@implementation MEServiceDetailsHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSD];

}

- (void)setUIWithModel:(MEGoodDetailModel *)model{
//    _lblAction.hidden = YES;
//    _lblPrice.hidden = YES;
    self.sdView.imageURLStringsGroup = @[MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images))];
    _lblTitle.text = kMeUnNilStr(model.title);
//    _lblSubTitle.text = kMeUnNilStr(model.title);;
    _lblCommonPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.money)];
//    _lblPrice.text = kMeUnNilStr(model.money);
//    _lblAppointmentNum.hidden = YES;
    _lblAppointmentNum.text = [NSString stringWithFormat:@"%@人预约",kMeUnNilStr(model.reserve_num)];
    _consSdHeight.constant = 375 * kMeFrameScaleX();
    if(model.is_first_buy){
        _lblTip.text = @"首次下单可免费体验该服务";
    }else{
        _lblTip.hidden = YES;
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}


- (void)initSD{
    _sdView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
    _sdView.autoScrollTimeInterval = 4;
    _sdView.delegate =self;
    _sdView.backgroundColor = [UIColor clearColor];
    _sdView.placeholderImage = kImgBannerPlaceholder;
    _sdView.currentPageDotColor = kMEPink;
    
}

+(CGFloat)getViewHeight{
    CGFloat allHeight = 497 - 375 + (375 * kMeFrameScaleX());
    return allHeight;
}

@end
