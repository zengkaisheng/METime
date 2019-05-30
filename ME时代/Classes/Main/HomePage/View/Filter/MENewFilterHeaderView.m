//
//  MENewFilterHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterHeaderView.h"

@interface MENewFilterHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *BGImageV;

@end

@implementation MENewFilterHeaderView

- (void)setUIWithModel {
    self.BGImageV.image = [UIImage imageNamed:@"testCoupon"];
    __block NSMutableArray *arrImage = [NSMutableArray array];
//    [kMeUnArr(model.top_banner) enumerateObjectsUsingBlock:^(METhridHomeAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        [arrImage addObject:kMeUnNilStr(model.ad_img)];
//    }];
    [arrImage addObject:@"http://images.meshidai.com/93c3dcc36a33f7cc5822b12e28c293da"];
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.imageURLStringsGroup = arrImage;
    
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    [_sdView disableScrollGesture];
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
