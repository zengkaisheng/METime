//
//  MEGroupListCell.m
//  ME时代
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupListCell.h"
#import "MEGroupListModel.h"

@interface MEGroupListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end


@implementation MEGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEGroupListModel *)model {
    kSDLoadImg(_headerPic, model.image_url);
    _titleLbl.text = model.title;
    _numberLbl.text = [NSString stringWithFormat:@"%@人团",model.group_num];
    
    NSString *faStr = [NSString stringWithFormat:@"拼团价￥%@ ￥%@",model.money,model.market_price];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:faStr];
    NSUInteger secondLoc = [faStr rangeOfString:@" "].location;
    
    [string addAttribute:NSForegroundColorAttributeName value:kME999999 range:NSMakeRange(secondLoc, faStr.length-secondLoc)];
    [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(secondLoc+1, faStr.length-secondLoc-1)];
    _priceLbl.attributedText = string;
}

@end
