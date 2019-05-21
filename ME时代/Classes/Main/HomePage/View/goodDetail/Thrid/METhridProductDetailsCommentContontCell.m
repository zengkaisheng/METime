//
//  METhridProductDetailsCommentContontCell.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductDetailsCommentContontCell.h"
#import "MEGoodDetailModel.h"

@interface METhridProductDetailsCommentContontCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoNum;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeaderProtail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consPhotoWdith;

@end

@implementation METhridProductDetailsCommentContontCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithModel:(MEGoodDetailCommentModel *)model{
    _lblTitle.text = kMeUnNilStr(model.goodcomment);
    _lblName.text = kMeUnNilStr(model.nick_name);
    kSDLoadImg(_imgHeaderProtail, kMeUnNilStr(model.header_pic));
    if(kMeUnArr(model.images).count){
        _imgPic.hidden = NO;
        _lblPhotoNum.hidden = NO;
        kSDLoadImg(_imgPic, kMeUnNilStr(model.images[0]));
        _lblPhotoNum.text = [NSString stringWithFormat:@"%@张",@(kMeUnArr(model.images).count).description];
        _consPhotoWdith.constant = 110;
    }else{
        _imgPic.hidden = YES;
        _lblPhotoNum.hidden = YES;
        _consPhotoWdith.constant = 1;
    }
}

@end
