//
//  MEGiftHeaderView.m
//  ME时代
//
//  Created by hank on 2018/12/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGiftHeaderView.h"
#import "MEAdModel.h"

@interface MEGiftHeaderView(){
    NSArray *_arrData;
}

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSdHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consVIewHeight;

@end

@implementation MEGiftHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = kMEPink;
    _consSdHeight.constant = 175*kMeFrameScaleY();
    _consVIewHeight.constant = (166*SCREEN_WIDTH)/750;
    _arrData = [NSArray array];
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
    _sdView.autoScrollTimeInterval = 4;
//    _sdView.delegate =self;
    _sdView.backgroundColor = [UIColor clearColor];
    _sdView.placeholderImage = kImgBannerPlaceholder;
    _sdView.currentPageDotColor = kMEPink;
}

- (void)setUiWithModel:(NSArray *)model{
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [model enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.imageURLStringsGroup = arrImage;
}

+ (CGFloat)getViewHeight{
    CGFloat height = 175*kMeFrameScaleY();
    height+=  (166*SCREEN_WIDTH)/750;
    return height;
}

@end
