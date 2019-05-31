//
//  MENewFilterGoodsTopHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/5/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterGoodsTopHeaderView.h"

@interface MENewFilterGoodsTopHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *BGImageV;


@end


@implementation MENewFilterGoodsTopHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithBackgroundImage:(NSString *)bgImage bannerImage:(NSString *)bannerImage {
    kSDLoadImg(_BGImageV,kMeUnNilStr(bgImage));
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.imageURLStringsGroup = @[bannerImage];
    
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    [_sdView disableScrollGesture];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

@end
