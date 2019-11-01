//
//  MEReportFooterView.m
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEReportFooterView.h"

@interface MEReportFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *telePhoneLbl;


@end

@implementation MEReportFooterView

- (void)setUIWithContent:(NSString *)content phone:(NSString *)phone {
    _contentLbl.text = content;
    _telePhoneLbl.text = [NSString stringWithFormat:@"联系方式：%@",phone];
}

+ (CGFloat)getHeightWithContent:(NSString *)content {
    CGFloat height = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
    return 18+44+20+21+5+height+60;
}

- (IBAction)consultBtnAction:(id)sender {
    kMeCallBlock(_tapBlock);
}


@end
