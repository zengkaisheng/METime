//
//  MEAICustomerCheckDetailCell.m
//  志愿星
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAICustomerCheckDetailCell.h"
#import "MEAICustomerCheckDetailModel.h"

@interface MEAICustomerCheckDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@end


@implementation MEAICustomerCheckDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEAICustomerCheckDetailModel *)model {
    kSDLoadImg(_headerImgV, kMeUnNilStr(model.header_pic));
    _nameLbl.text = kMeUnNilStr(model.name);
    _timeLbl.text = kMeUnNilStr(model.created_at);
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"访问数：%ld次",(long)model.count]];
    NSUInteger firstLoc = [[aString string] rangeOfString:@"："].location + 1;
    NSString *count = [NSString stringWithFormat:@"%ld",(long)model.count];
    NSRange range = NSMakeRange(firstLoc, count.length);
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#55BA34"] range:range];
    _countLbl.attributedText = aString;
}

@end
