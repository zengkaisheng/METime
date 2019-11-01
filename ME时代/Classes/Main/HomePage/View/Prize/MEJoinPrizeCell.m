//
//  MEJoinPrizeCell.m
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEJoinPrizeCell.h"

@interface MEJoinPrizeCell ()

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;


@end

@implementation MEJoinPrizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setUpUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpUI {
//    _joinBtn.frame = CGRectMake(15, 4, SCREEN_WIDTH - 30, 45);
//    CAGradientLayer *btnLayer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:255/255.0 green:112/255.0 blue:96/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:253/255.0 green:71/255.0 blue:54/255.0 alpha:1.0].CGColor] locations:@[@(0.0),@(1.0)] frame:_joinBtn.layer.bounds];
//    [_joinBtn.layer insertSublayer:btnLayer atIndex:0];
    
    _joinBtn.backgroundColor = [UIColor colorWithHexString:@"#FD4736"];
    _joinBtn.layer.shadowColor = [UIColor colorWithRed:254/255.0 green:85/255.0 blue:68/255.0 alpha:0.9].CGColor;
    _joinBtn.layer.shadowOffset = CGSizeMake(0,3);
    _joinBtn.layer.shadowOpacity = 1;
    _joinBtn.layer.shadowRadius = 7;
    _joinBtn.layer.cornerRadius = 22.5;

}

- (IBAction)joinAction:(id)sender {
    if (self.joinBlock) {
        self.joinBlock();
    }
}

- (CAGradientLayer *)getLayerWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors locations:(NSArray *)locations frame:(CGRect)frame {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = endPoint;//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = colors;
    layer.locations = locations;//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = frame;
    return layer;
}

@end
