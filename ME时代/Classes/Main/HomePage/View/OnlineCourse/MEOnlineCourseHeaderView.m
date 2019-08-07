//
//  MEOnlineCourseHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseHeaderView.h"
#import "MEAdModel.h"

@interface MEOnlineCourseHeaderView ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end


@implementation MEOnlineCourseHeaderView

- (void)setUIWithArray:(NSArray *)array type:(NSInteger)type {
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
    
    if (type == 0) {
        _bottomView.hidden = YES;
    }else if (type == 1) {
        _bottomView.hidden = NO;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedBlock,index);
}

- (IBAction)videoAction:(id)sender {
    kMeCallBlock(_selectedBlock,100);
}

- (IBAction)audioAction:(id)sender {
    kMeCallBlock(_selectedBlock,101);
}
- (IBAction)chargeAction:(id)sender {
    kMeCallBlock(_selectedBlock,102);
}
- (IBAction)freeAction:(id)sender {
    kMeCallBlock(_selectedBlock,103);
}

@end
