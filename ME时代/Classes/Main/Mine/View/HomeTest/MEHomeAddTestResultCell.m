//
//  MEHomeAddTestResultCell.m
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddTestResultCell.h"
#import "MEHomeAddTestDecModel.h"

@interface MEHomeAddTestResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblLevle;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhoto;


@end

@implementation MEHomeAddTestResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (IBAction)addPhotoAction:(UIButton *)sender {
    kMeCallBlock(_addPhotoBlock);
}

- (void)setUiWIthModel:(MEHomeAddTestDecResultModel *)model index:(NSInteger)index type:(MEHomeAddTestDecTypeVC)type;{
    _lblLevle.text = [NSString stringWithFormat:@"分值阶段%@",@(index+1)];
    _lblScore.text = [NSString stringWithFormat:@"%.2f~%.2f",model.min,model.max];
    if(kMeUnNilStr(model.answer).length){
        kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(model.answer));
    }else{
        _imgPic.image = nil;
    }
    _btnAddPhoto.hidden = type == MEHomeAddTestDecTypelplatVC;

}


@end
