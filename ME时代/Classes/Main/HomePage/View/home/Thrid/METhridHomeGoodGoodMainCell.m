//
//  METhridHomeGoodGoodMainCell.m
//  ME时代
//
//  Created by hank on 2019/4/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeGoodGoodMainCell.h"
#import "MEGoodModel.h"

@interface METhridHomeGoodGoodMainCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end

@implementation METhridHomeGoodGoodMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lblTitle.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
    _lblPrice.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
    _lblPrice.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEGoodModel *)model{
    kSDLoadImg(_imgPic,kMeUnNilStr(model.images_url));
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSubTitle.text = kMeUnNilStr(model.desc).length?kMeUnNilStr(model.desc):kMeUnNilStr(model.title);
//    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.product.money).floatValue)];
    
//    NSString *commStr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.product.market_price).floatValue)];
    
    NSString *str = [NSString stringWithFormat:@"¥%@ ¥%@",@(kMeUnNilStr(model.money).floatValue),@(kMeUnNilStr(model.market_price).floatValue)];
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSUInteger firstLoc = [[aString string] rangeOfString:@" "].location+1;
    NSUInteger secondLoc = str.length;
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [aString addAttribute:NSForegroundColorAttributeName value:kME999999 range:range];
    [aString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    [aString addAttribute:NSFontAttributeName value:kMeFont(12) range:range];
    
    _lblPrice.attributedText = aString;
    
    if (model.type == 5) {
//        switch (model.type) {
//            case 1:
//            {//未参加
//                [_prizeBtn setTitle:@"参加抽奖" forState:UIControlStateNormal];
//                [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F03D38"]];
//            }
//                break;
//            case 2:
//            {//等待开奖
//                [_prizeBtn setTitle:@"等待开奖" forState:UIControlStateNormal];
//                [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F03D38"]];
//            }
//                break;
//            case 3:
//            {//中奖(待领取)
//                [_prizeBtn setTitle:@"领取奖品" forState:UIControlStateNormal];
//                [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F03D38"]];
//            }
//                break;
//            case 4:
//            {//未中奖
//                [_prizeBtn setTitle:@"已结束" forState:UIControlStateNormal];
//                [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
//            }
//                break;
//            case 5:
//            {//已领取
//                [_prizeBtn setTitle:@"已领取" forState:UIControlStateNormal];
//                [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
//            }
//                break;
//            default:
//                break;
//        }
        [_buyBtn setTitle:@"立即签到" forState:UIControlStateNormal];
    }else {
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    }
//    [_lblUnderLinePrice setLineStrWithStr:commStr];
}
- (IBAction)buyAction:(id)sender {
    if (self.buyBlock) {
        self.buyBlock();
    }
}


@end
