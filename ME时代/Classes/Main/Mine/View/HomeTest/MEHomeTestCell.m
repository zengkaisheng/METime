//
//  MEHomeTestCell.m
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeTestCell.h"

@interface MEHomeTestCell ()
{
    NSArray *_arrImg;
    NSArray *_arrTitle;

}
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation MEHomeTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _arrImg = @[@"testCu",@"testlist",@"testHostory"];
    _arrTitle = @[@"自定义测试内容",@"选择测试题库",@"历史发布测试题库"];
    self.selectionStyle = 0;
}

- (void)setUIWIithType:(MEHomeTestCellType)type{
    _imgPic.image = [UIImage imageNamed:_arrImg[type]];
    _lblTitle.text = kMeUnNilStr(_arrTitle[type]);
}

@end
