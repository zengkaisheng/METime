//
//  MEAIDataHomeActiveHomeCell.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAIDataHomeActiveHomeCell.h"

@interface MEAIDataHomeActiveHomeCell (){
    NSArray *_arrImage;
    NSArray *_arrTitle;

}

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;


@end

@implementation MEAIDataHomeActiveHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrImage = @[@"aiCheckStore",@"aiShareStore",@"aipintuan",@"aiCheckServer"];
    _arrTitle = @[@"查看店铺",@"分享店铺",@"查看拼团活动",@"查看服务项目"];
    // Initialization code
}

- (void)setUIWithType:(MEAIDataHomeActiveHomeCellType)type count:(NSInteger)count{
    NSString *strImg = _arrImage[type];
    NSString *strTitle = _arrTitle[type];
    _imgPic.image = [UIImage imageNamed:strImg];
    _lblTitle.text = strTitle;
    _lblCount.text = [NSString stringWithFormat:@"%@次",@(count).description];
}

@end
