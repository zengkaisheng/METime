//
//  MEPublicShowListCell.m
//  ME时代
//
//  Created by gao lei on 2019/12/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowListCell.h"
#import "MECommunityServericeListModel.h"

@interface MEPublicShowListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageV;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsTop;


@property (weak, nonatomic) IBOutlet UILabel *titleLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBtnConsWidth;

@end

@implementation MEPublicShowListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    _commentBtnConsWidth.constant = 0.0;
    _commentBtn.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setShowUIWithModel:(MECommunityServericeListModel *)model {
    _titleLbl.text = kMeUnNilStr(model.title);
    _addressLbl.text = kMeUnNilStr(model.address);
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@",@(model.praise_num)] forState:UIControlStateNormal];
    if (model.is_praise == 1) {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_voluniteer_like_sel"] forState:UIControlStateNormal];
    }else {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_voluniteer_like_nor"] forState:UIControlStateNormal];
    }
    
    if (kMeUnArr(model.images).count > 1) {
        _imageV.hidden = YES;
        _titleLbl1.hidden = YES;
        _titleLbl.hidden = NO;
        _leftImageV.hidden = NO;
        if (kMeUnArr(model.images).count == 1) {
            _centerImageV.hidden = _rightImageV.hidden = YES;
            kSDLoadImg(_leftImageV, kMeUnNilStr(model.images.firstObject));
        }else if (kMeUnArr(model.images).count == 2) {
            _centerImageV.hidden = NO;
            _rightImageV.hidden = YES;
            kSDLoadImg(_leftImageV, kMeUnNilStr(model.images.firstObject));
            kSDLoadImg(_centerImageV, kMeUnNilStr(model.images[1]));
        }else if (kMeUnArr(model.images).count > 2) {
            _centerImageV.hidden = _rightImageV.hidden = NO;
            kSDLoadImg(_leftImageV, kMeUnNilStr(model.images.firstObject));
            kSDLoadImg(_centerImageV, kMeUnNilStr(model.images[1]));
            kSDLoadImg(_rightImageV, kMeUnNilStr(model.images[2]));
        }
    } else {
        _leftImageV.hidden = _centerImageV.hidden = _rightImageV.hidden = YES;
        _titleLbl.hidden = YES;
        _imageV.hidden = NO;
        _titleLbl1.hidden = NO;
        _titleLbl1.text = kMeUnNilStr(model.title);
        if (kMeUnArr(model.images).count <= 0) {
            _imageV.hidden = YES;
        } else {
            _imageV.hidden = NO;
            kSDLoadImg(_imageV, kMeUnNilStr(model.images.firstObject));
        }
    }
}

- (IBAction)likeBtnAction:(id)sender {
    //点赞
    kMeCallBlock(self.indexBlock,0);
}

- (IBAction)commentBtnAction:(id)sender {
    //评论
    kMeCallBlock(self.indexBlock,1);
}


@end
