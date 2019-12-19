//
//  METhridHomeCommondSectionView.m
//  志愿星
//
//  Created by hank on 2019/4/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeCommondSectionView.h"

@interface METhridHomeCommondSectionView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end


@implementation METhridHomeCommondSectionView


- (void)setUIWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            _titleLbl.text = @"活动专区";
            _titleLbl.textColor = [UIColor colorWithHexString:@"#FF7979"];
            _leftImageV.hidden = _rightImageV.hidden = YES;
            _leftView.hidden = _rightView.hidden = NO;
            _leftView.backgroundColor = _rightView.backgroundColor = [UIColor colorWithHexString:@"#FF7979"];
            _bgImageV.hidden = YES;
        }
            break;
        case 1:
        {
            _bgImageV.hidden = NO;
            _leftImageV.hidden = _rightImageV.hidden = YES;
            _leftView.hidden = _rightView.hidden = YES;
        }
            break;
        case 2:
        {
            _titleLbl.text = @"为你推荐";
            _titleLbl.textColor = [UIColor colorWithHexString:@"#2ED9A4"];
            _leftImageV.hidden = _rightImageV.hidden = NO;
            _leftView.hidden = _rightView.hidden = YES;
            _bgImageV.hidden = YES;
        }
            break;
        case 3:
        {
            _titleLbl.text = @"一起学习";
            _titleLbl.textColor = [UIColor colorWithHexString:@"#FF7979"];
            _leftImageV.hidden = _rightImageV.hidden = YES;
            _leftView.hidden = _rightView.hidden = NO;
            _leftView.backgroundColor = _rightView.backgroundColor = [UIColor colorWithHexString:@"#FF7979"];
            _bgImageV.hidden = YES;
        }
            break;
        case 4:
        {
            _titleLbl.text = @"精品课程";
            _titleLbl.textColor = [UIColor colorWithHexString:@"#FF7979"];
            _leftImageV.hidden = _rightImageV.hidden = YES;
            _leftView.hidden = _rightView.hidden = NO;
            _leftView.backgroundColor = _rightView.backgroundColor = [UIColor colorWithHexString:@"#FF7979"];
            _bgImageV.hidden = YES;
        }
            break;
        case 5:
        {
            _titleLbl.text = @"公益秀";
            _titleLbl.textColor = [UIColor colorWithHexString:@"#2ED9A4"];
            _leftImageV.hidden = _rightImageV.hidden = YES;
            _leftView.hidden = _rightView.hidden = NO;
            _leftView.backgroundColor = _rightView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
            _bgImageV.hidden = YES;
        }
            break;
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
