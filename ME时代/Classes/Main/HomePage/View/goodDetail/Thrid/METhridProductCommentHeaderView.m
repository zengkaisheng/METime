//
//  METhridProductCommentHeaderView.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductCommentHeaderView.h"
#import "MEStarControl.h"
#import "MEGoodDetailModel.h"

@interface METhridProductCommentHeaderView (){
    METhridProductCommentHeaderViewType _type;
}

@property (weak, nonatomic) IBOutlet MEStarControl *starView;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIButton *btnGood;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblGood;

@end

@implementation METhridProductCommentHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    _type = METhridProductCommentHeaderViewAllType;
    _starView.starSize = CGSizeMake(16, 16);
}

- (void)setUIWithModel:(MEGoodDetailModel *)model type:(METhridProductCommentHeaderViewType)type{
    _type = type;
    [_btnAll setTitle:[NSString stringWithFormat:@"全部(%@)",kMeUnNilStr(model.comment_count)] forState:UIControlStateNormal];
    [_btnGood setTitle:[NSString stringWithFormat:@"好评(%@)",kMeUnNilStr(model.good_comment_count)] forState:UIControlStateNormal];
    [_btnPhoto setTitle:[NSString stringWithFormat:@"晒图(%@)",kMeUnNilStr(model.show_pic_comment_count)] forState:UIControlStateNormal];
    _starView.score = model.value;
    _lblGood.text = [NSString stringWithFormat:@"%@好评率",kMeUnNilStr(model.equities)];
    [self reloadBtnStatusWithSelectBtn:_type];
}

- (void)reloadBtnStatusWithSelectBtn:(METhridProductCommentHeaderViewType)type{
    switch (type) {
        case METhridProductCommentHeaderViewAllType:{
            _btnAll.backgroundColor = kMEfeedfe;
            [_btnAll setTitleColor:kMEe74291 forState:UIControlStateNormal];
            _btnAll.borderWidth = 0;
            _btnGood.backgroundColor = [UIColor whiteColor];
            [_btnGood setTitleColor:kME666666 forState:UIControlStateNormal];
            _btnGood.borderWidth = 1;
            _btnPhoto.backgroundColor = [UIColor whiteColor];
            [_btnPhoto setTitleColor:kME666666 forState:UIControlStateNormal];
            _btnPhoto.borderWidth = 1;
        }
            break;
        case METhridProductCommentHeaderViewGoodType:{
            _btnGood.backgroundColor = kMEfeedfe;
            [_btnGood setTitleColor:kMEe74291 forState:UIControlStateNormal];
            _btnGood.borderWidth = 0;
            _btnAll.backgroundColor = [UIColor whiteColor];
            [_btnAll setTitleColor:kME666666 forState:UIControlStateNormal];
            _btnAll.borderWidth = 1;
            _btnPhoto.backgroundColor = [UIColor whiteColor];
            [_btnPhoto setTitleColor:kME666666 forState:UIControlStateNormal];
            _btnPhoto.borderWidth = 1;
        }
            break;
        case METhridProductCommentHeaderViewPhotoType:{
            _btnPhoto.backgroundColor = kMEfeedfe;
            [_btnPhoto setTitleColor:kMEe74291 forState:UIControlStateNormal];
            _btnPhoto.borderWidth = 0;
            _btnAll.backgroundColor = [UIColor whiteColor];
            [_btnAll setTitleColor:kME666666 forState:UIControlStateNormal];
            _btnAll.borderWidth = 1;
            _btnGood.backgroundColor = [UIColor whiteColor];
            [_btnGood setTitleColor:kME666666 forState:UIControlStateNormal];
            _btnGood.borderWidth = 1;
        }
            break;
        default:
            break;
    }
}

- (IBAction)allAction:(UIButton *)sender {
    _type = METhridProductCommentHeaderViewAllType;
    [self reloadBtnStatusWithSelectBtn:_type];
    kMeCallBlock(_selectBlock,_type);
}

- (IBAction)goodAction:(UIButton *)sender {
    _type = METhridProductCommentHeaderViewGoodType;
    [self reloadBtnStatusWithSelectBtn:_type];
    kMeCallBlock(_selectBlock,_type);
}

- (IBAction)photoAction:(UIButton *)sender {
    _type = METhridProductCommentHeaderViewPhotoType;
    [self reloadBtnStatusWithSelectBtn:_type];
    kMeCallBlock(_selectBlock,_type);
}


@end
