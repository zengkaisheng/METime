//
//  METhridHomeHotCell.m
//  ME时代
//
//  Created by hank on 2019/4/13.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeHotCell.h"
#import "METhridHomeHotGoodModel.h"

@interface METhridHomeHotCell (){
    kMeBasicBlock _payBlock;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgPalyGood;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
//@property (weak, nonatomic) IBOutlet UILabel *lblComPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSaled;



@end

@implementation METhridHomeHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
//    _lblComPrice.adjustsFontSizeToFitWidth = YES;
    _lblPrice.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWIthModel:(METhridHomeHotGoodModel *)model payBlock:(kMeBasicBlock)payBlock{
    _payBlock = payBlock;
    kSDLoadImg(_imgGood, kMeUnNilStr(model.product.images));
    kSDLoadImg(_imgPalyGood, kMeUnNilStr(model.is_index_hot_images_url));
//    [_lblComPrice setLineStrWithStr:[NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product.market_price)]];
    _lblSaled.text = [NSString stringWithFormat:@"销量:%@",kMeUnNilStr(model.sale)];
//    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product.money)];
    _lblDesc.text = kMeUnNilStr(model.product.desc);
    _lblGoodName.text = kMeUnNilStr(model.product.goodtitle);
    
    
    NSString *str = [NSString stringWithFormat:@"¥%@ ¥%@",@(kMeUnNilStr(model.product.market_price).floatValue),@(kMeUnNilStr(model.product.money).floatValue)];
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSUInteger firstLoc = 0;
    NSUInteger secondLoc = [[aString string] rangeOfString:@" "].location;

    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [aString addAttribute:NSForegroundColorAttributeName value:kME999999 range:range];
    [aString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    [aString addAttribute:NSFontAttributeName value:kMeFont(11) range:range];
    
    _lblPrice.attributedText = aString;
    
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    
}


- (IBAction)playAction:(UIButton *)sender {
    kMeCallBlock(_payBlock);
}

@end
