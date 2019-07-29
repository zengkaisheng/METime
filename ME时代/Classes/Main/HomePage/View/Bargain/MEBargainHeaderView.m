//
//  MEBargainHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainHeaderView.h"
#import "MEAdModel.h"

@interface MEBargainHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *topLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomLbl;

@end


@implementation MEBargainHeaderView

- (void)setUIWithDictionary:(NSDictionary *)dic {
    if (dic.allKeys.count <= 0) {
        return;
    }
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    
    
    NSArray *banners = dic[@"top_banner"];
    __block NSMutableArray *arrImage =[NSMutableArray array];
    [banners enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
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
//    kSDLoadImg(_headerPic, @"");
//    _topLbl.text = @"某某砍价成功了致青春期男孩";
    NSString *fstr = @"";
    if ([kMeUnNilStr(dic[@"type"]) intValue] == 1) {//砍价
        fstr = [NSString stringWithFormat:@"%d 人今日砍价成功",[kMeUnNilStr(dic[@"today_finish_bargin_total"]) intValue]];
    }else if ([kMeUnNilStr(dic[@"type"]) intValue] == 2) {//拼团
        fstr = [NSString stringWithFormat:@"%d 人今日拼团成功",[kMeUnNilStr(dic[@"today_group_total"]) intValue]];
    }
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    NSUInteger secondLoc = [[faString string] rangeOfString:@" "].location;
    
    NSRange range = NSMakeRange(0, secondLoc+1);
    [faString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:22] range:range];
    _bottomLbl.attributedText = faString;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedBlock,index);
}

@end
