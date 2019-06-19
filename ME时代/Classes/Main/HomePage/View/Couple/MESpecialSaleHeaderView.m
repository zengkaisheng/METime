//
//  MESpecialSaleHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESpecialSaleHeaderView.h"
#import "MEAdModel.h"

@interface MESpecialSaleHeaderView ()<SDCycleScrollViewDelegate>

@end

@implementation MESpecialSaleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithBannerImage:(NSArray *)bannerImages {
    
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    
    __block NSMutableArray *arrImage =[NSMutableArray array];
    [bannerImages enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.imageURLStringsGroup = arrImage;
    
    if (arrImage.count <= 1) {
        _sdView.infiniteLoop = NO;
        _sdView.autoScroll = NO;
    }else {
        _sdView.infiniteLoop = YES;
        _sdView.autoScroll = YES;
        _sdView.autoScrollTimeInterval = 4;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedIndexBlock,index);
}

@end
