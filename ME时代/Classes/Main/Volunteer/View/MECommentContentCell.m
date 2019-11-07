//
//  MECommentContentCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommentContentCell.h"

@interface MECommentContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end


@implementation MECommentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithName:(NSString *)name content:(NSString *)content {
    _nameLbl.text = kMeUnNilStr(name);
    _contentLbl.text = kMeUnNilStr(content);
}

@end
