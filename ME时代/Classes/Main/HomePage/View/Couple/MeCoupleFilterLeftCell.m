//
//  MeCoupleFilterLeftCell.m
//  ME时代
//
//  Created by hank on 2018/12/24.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MeCoupleFilterLeftCell.h"

@interface MeCoupleFilterLeftCell ()

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#define defaultColor //rgba(253, 212, 49, 1)


@property (nonatomic, strong) UIView *yellowView;

@end

@implementation MeCoupleFilterLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kLeftTableViewWidth-5, kLeftTableViewHeight)];
        self.name.numberOfLines = 1;
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textColor = kMEblack;//rgba(130, 130, 130, 1);
        self.name.highlightedTextColor = kMEPink;
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, kLeftTableViewHeight)];
        self.yellowView.backgroundColor = kMEPink;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"fbfbfb"];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}


@end
