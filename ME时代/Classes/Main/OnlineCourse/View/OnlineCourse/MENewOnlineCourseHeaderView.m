//
//  MENewOnlineCourseHeaderView.m
//  志愿星
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewOnlineCourseHeaderView.h"
#import "MEAdModel.h"

@interface MENewOnlineCourseHeaderView ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsHeight;

@end

@implementation MENewOnlineCourseHeaderView


- (void)setUIWithArray:(NSArray *)array {
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    
    _sdViewConsHeight.constant = 143;
    _sdViewConsTop.constant = 19;
    _sdViewConsLeading.constant = _sdViewConsTrailing.constant = 15;
    self.backgroundColor = [UIColor whiteColor];
    
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

- (void)setActivityUIWithModel:(MEAdModel *)model {
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    
    _sdViewConsHeight.constant = 250;
    _sdViewConsTop.constant = 0;
    _sdViewConsLeading.constant = _sdViewConsTrailing.constant = 0;
    
    _sdView.imageURLStringsGroup = @[kMeUnNilStr(model.ad_img)];
    self.backgroundColor = _sdView.backgroundColor = [UIColor colorWithHexString:kMeUnNilStr(model.color_start)];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedBlock,index);
}

@end
