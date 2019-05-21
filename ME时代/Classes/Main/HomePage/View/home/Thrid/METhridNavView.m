//
//  METhridNavView.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridNavView.h"

@interface METhridNavView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBottomMargin;

@end

@implementation METhridNavView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
}

@end
