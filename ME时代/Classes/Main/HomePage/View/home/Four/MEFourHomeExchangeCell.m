//
//  MEFourHomeExchangeCell.m
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeExchangeCell.h"

@interface MEFourHomeExchangeCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBottom;

@end

@implementation MEFourHomeExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    _consLeading.constant = _consTop.constant = _consBottom.constant = _consTrailing.constant = padding;
}

@end
