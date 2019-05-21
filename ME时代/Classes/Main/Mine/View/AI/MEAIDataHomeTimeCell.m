//
//  MEAIDataHomeTimeCell.m
//  ME时代
//
//  Created by hank on 2019/4/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAIDataHomeTimeCell.h"
#import "MEAIDataHomeTimeModel.h"

@interface MEAIDataHomeTimeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;


@end

@implementation MEAIDataHomeTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEAIDataHomeTimeModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.header_pic));
    _lblTitle.text = [NSString stringWithFormat:@"%@第%@次查看您的小店",kMeUnNilStr(model.nick_name),kMeUnNilStr(model.count)];
    _lblTime.text = kMeUnNilStr(model.created_at);
}

- (void)setPeopleUIWithModel:(MEAIDataHomeTimeModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.header_pic));
    _lblTitle.text = [NSString stringWithFormat:@"%@和您互动了%@次",kMeUnNilStr(model.nick_name),kMeUnNilStr(model.count)];
    _lblTime.text = kMeUnNilStr(model.created_at);
}

@end
