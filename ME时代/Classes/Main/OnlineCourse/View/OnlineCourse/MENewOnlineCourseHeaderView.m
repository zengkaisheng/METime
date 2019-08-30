//
//  MENewOnlineCourseHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewOnlineCourseHeaderView.h"
#import "MEAdModel.h"

@interface MENewOnlineCourseHeaderView ()<SDCycleScrollViewDelegate>

@end

@implementation MENewOnlineCourseHeaderView


- (void)setUIWithArray:(NSArray *)array {
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    
    __block NSMutableArray *arrImage =[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
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

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedBlock,index);
}

@end
