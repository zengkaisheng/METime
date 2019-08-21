//
//  DataPickerViewCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "DataPickerViewCell.h"

@implementation DataPickerViewModel

@end

@interface DataPickerViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation DataPickerViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}

- (void)setupViews {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_list_seled"];
    [self.contentView addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self.frame.size.width - 88);
        make.height.mas_equalTo(36);
    }];
    self.titleLab = titleLab;
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    imgView.hidden = YES;
    self.imgView = imgView;
}

- (void)fullCellWithModel:(DataPickerViewModel *)model {
    self.titleLab.text = model.name;
    if (model.isSelected == YES) {
        self.titleLab.textColor = kMEPink;
    }else {
        self.titleLab.textColor = [UIColor blackColor];
    }
    self.imgView.hidden = !model.isSelected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
