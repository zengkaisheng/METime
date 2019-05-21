//
//  MECoupleFileCell.m
//  ME时代
//
//  Created by hank on 2018/12/24.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MECoupleFileCell.h"
#import "MECoupleFilterModel.h"

@interface MECoupleFileCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation MECoupleFileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 15, self.frame.size.width - 12, self.frame.size.width - 12)];
        self.imageV.contentMode = UIViewContentModeScaleToFill;
        self.imageV.cornerRadius = (self.frame.size.width - 12)/2;
        self.imageV.clipsToBounds = YES;
        [self.contentView addSubview:self.imageV];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageV.bottom+8, self.frame.size.width, 15)];
        self.name.textColor = kME333333;
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:self.name];
    }
    return self;
}

- (void)setModel:(MECoupleFilterSubModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    self.name.text = model.name;
}


@end
