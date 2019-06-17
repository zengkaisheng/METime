//
//  MENewFilterGoodsMiddleBannerView.m
//  ME时代
//
//  Created by gao lei on 2019/6/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterGoodsMiddleBannerView.h"
#import "MEAdModel.h"

@interface MENewFilterGoodsMiddleBannerView ()<SDCycleScrollViewDelegate>

@end

@implementation MENewFilterGoodsMiddleBannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithImages:(NSArray *)images {
    
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    
    __block NSMutableArray *arrImage =[NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.imageURLStringsGroup = arrImage;
    
    if (images.count <= 1) {
        _sdView.infiniteLoop = NO;
        _sdView.autoScroll = NO;
    }else {
        _sdView.infiniteLoop = YES;
        _sdView.autoScroll = YES;
        _sdView.autoScrollTimeInterval = 4;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedIndexBlock,index);
}

@end
