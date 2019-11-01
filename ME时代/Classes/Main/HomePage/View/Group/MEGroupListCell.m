//
//  MEGroupListCell.m
//  志愿星
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsTop;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConsWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsBottom;

@end


@implementation MEGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEGroupListModel *)model {
    _bgViewConsTop.constant = _bgViewConsLeading.constant = _bgViewConsTrailing.constant = 0.0;
    _bgView.cornerRadius = 0.0;
    _headerPicConsTop.constant = 12.0;
    _headerPicConsLeading.constant = 15.0;
    _headerPicConsBottom.constant = 12.0;
    _headerPic.cornerRadius = 0.0;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(model.image_url));
    _titleLbl.text = kMeUnNilStr(model.title);
    _numberLbl.text = [NSString stringWithFormat:@"%@人团",kMeUnNilStr(model.group_num)];
    
    if (IS_IPHONE_4S||IS_IPHONE_5||IS_iPhone5S) {
        _priceLbl.font = [UIFont systemFontOfSize:11];
    }else if (IS_IPHONE_6) {
        _priceLbl.font = [UIFont systemFontOfSize:13];
    }else {
        _priceLbl.font = [UIFont systemFontOfSize:15];
    }
    
    NSString *faStr = [NSString stringWithFormat:@"拼团价￥%@ ￥%@",kMeUnNilStr(model.money).length>0?kMeUnNilStr(model.money):@"0.00",kMeUnNilStr(model.market_price).length>0?kMeUnNilStr(model.market_price):@"0.00"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:faStr];
    NSUInteger secondLoc = [faStr rangeOfString:@" "].location;
    
    [string addAttribute:NSForegroundColorAttributeName value:kME999999 range:NSMakeRange(secondLoc+1, faStr.length-secondLoc-1)];
    [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(secondLoc+1, faStr.length-secondLoc-1)];
    _priceLbl.attributedText = string;
}

- (void)setHomeUIWithModel:(MEGroupListModel *)model {
    _bgViewConsTop.constant = 5.0;
    _bgViewConsLeading.constant = _bgViewConsTrailing.constant = 10.0;
    _bgView.cornerRadius = 10.0;
    _headerPicConsTop.constant = 15.0;
    _headerPicConsLeading.constant = 10.0;
    _headerPicConsBottom.constant = 17.0;
    _headerPic.cornerRadius = 4.0;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(model.image_url));
    _titleLbl.text = kMeUnNilStr(model.title);
    _numberLbl.text = [NSString stringWithFormat:@"%@人团",kMeUnNilStr(model.group_num)];
    
    if (IS_IPHONE_4S||IS_IPHONE_5||IS_iPhone5S) {
        _priceLbl.font = [UIFont systemFontOfSize:11];
    }else if (IS_IPHONE_6) {
        _priceLbl.font = [UIFont systemFontOfSize:13];
    }else {
        _priceLbl.font = [UIFont systemFontOfSize:15];
    }
    
    _priceLbl.text = [NSString stringWithFormat:@"拼团价￥%@",kMeUnNilStr(model.money)];
    _priceLbl.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15];
    _priceLbl.textColor = [UIColor colorWithHexString:@"#EA3982"];
//    NSString *faStr = [NSString stringWithFormat:@"拼团价￥%@ ￥%@",kMeUnNilStr(model.money),kMeUnNilStr(model.market_price)];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:faStr];
//    NSUInteger secondLoc = [faStr rangeOfString:@" "].location;
//
//    [string addAttribute:NSForegroundColorAttributeName value:kME999999 range:NSMakeRange(secondLoc+1, faStr.length-secondLoc-1)];
//    [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(secondLoc+1, faStr.length-secondLoc-1)];
//    _priceLbl.attributedText = string;
    [_groupBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_groupBtn setBackgroundColor:[UIColor colorWithHexString:@"#EA3982"]];
    _groupBtn.cornerRadius = 5.0;
    _btnConsWidth.constant = 75;
    _btnConsHeight.constant = 30;
}

- (IBAction)groupAction:(id)sender {
    kMeCallBlock(self.groupBlock);
}

@end
