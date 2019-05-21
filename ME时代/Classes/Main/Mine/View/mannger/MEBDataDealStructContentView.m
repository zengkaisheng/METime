//
//  MEBDataDealStructContentView.m
//  ME时代
//
//  Created by hank on 2019/2/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBDataDealStructContentView.h"


@implementation MEBDataDealStructContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
//    [self addSubview:topLineView];
    [self addSubview:self.lblCategory];
    [self addSubview:self.lblPercent];
    [self addSubview:self.viewRightLine];
}

- (UILabel*)lblCategory{
    if(!_lblCategory){
        _lblCategory = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.width, 18)];
        _lblCategory.textAlignment = NSTextAlignmentCenter;
        _lblCategory.font = kMeFont(14);
        _lblCategory.textColor = kME666666;
    }
    return _lblCategory;
}

- (UILabel*)lblPercent{
    if(!_lblPercent){
        _lblPercent = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lblCategory.bottom+7, self.width, 14)];
        _lblPercent.textAlignment = NSTextAlignmentCenter;
        _lblPercent.font = kMeFont(12);
        _lblPercent.textColor = kMEblack;
    }
    return _lblPercent;
}

- (UIView *)viewRightLine{
    if(!_viewRightLine){
        _viewRightLine = [[UIView alloc]initWithFrame:CGRectMake(self.width-1, 8, 1, 54)];
        _viewRightLine.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];;
    }
    return _viewRightLine;
}



@end
