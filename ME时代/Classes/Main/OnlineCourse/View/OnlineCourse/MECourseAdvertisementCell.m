//
//  MECourseAdvertisementCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseAdvertisementCell.h"
#import "MEAdModel.h"

@interface MECourseAdvertisementCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsTrailing;

@end

@implementation MECourseAdvertisementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithArray:(NSArray *)array{
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdViewConsLeading.constant = _sdViewConsTrailing.constant = 9;
    
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

- (void)setNewCourseUIWithArray:(NSArray *)array {
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdViewConsLeading.constant = _sdViewConsTrailing.constant = 0;
    _sdView.layer.cornerRadius = 0;
    
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
