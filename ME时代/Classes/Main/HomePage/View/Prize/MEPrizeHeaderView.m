//
//  MEPrizeHeaderView.m
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPrizeHeaderView.h"
#import "MEPrizeDetailsModel.h"

@interface MEPrizeHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation MEPrizeHeaderView

- (void)setUIWithModel:(MEPrizeDetailsModel *)model {
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    _sdView.imageURLStringsGroup = @[model.image];
    _sdView.backgroundColor = [UIColor clearColor];
    
    _titleLbl.text = model.title;
    _countLbl.text = [NSString stringWithFormat:@"%ld份",(long)model.total];
    _timeLbl.text = [NSString stringWithFormat:@"开奖时间 %@",model.open_time];
}

- (IBAction)likeAction:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
