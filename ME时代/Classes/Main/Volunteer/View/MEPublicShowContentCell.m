//
//  MEPublicShowContentCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowContentCell.h"
#import "MENineGridView.h"
#import "YBImageBrowser.h"
#import "MEPublicShowDetailModel.h"

#define kmainCommentCellWdith (SCREEN_WIDTH -26-26)

@interface MEPublicShowContentCell ()<YBImageBrowserDataSource>{
    NSInteger _currentIndex;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet MENineGridView *gridView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consGridViewHeight;


@property (strong, nonatomic) MEPublicShowDetailModel *model;

@end

@implementation MEPublicShowContentCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEPublicShowDetailModel *)model{
    _model = model;
    _currentIndex = 0;
    kSDLoadImg(_headerPic, kMeUnNilStr(model.header_pic));
    _nameLbl.text = kMeUnNilStr(model.nick_name);
    NSArray *timeArr = [kMeUnNilStr(model.created_at) componentsSeparatedByString:@" "];
    _addressLbl.text = [NSString stringWithFormat:@"%@%@",kMeUnNilStr(model.address),kMeUnNilStr(timeArr.firstObject)];
    [_contentLbl setAtsWithStr:kMeUnNilStr(model.content) lineGap:0];
    
    _consGridViewHeight.constant = [MENineGridView getPublicShowViewHeightWithArr:kMeUnArr(model.images)];
    [_gridView setImagePublicShowWithArr:kMeUnArr(model.images)];
    kMeWEAKSELF
    _gridView.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        strongSelf->_currentIndex = index;
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSource = strongSelf;
        browser.currentIndex = index;
        [browser show];
    };
    
    if (model.is_praise == 1) {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_voluniteer_like_sel"] forState:UIControlStateNormal];
        [_likeBtn setTitle:@"已点赞" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateNormal];
    }else {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_voluniteer_like_nor"] forState:UIControlStateNormal];
        [_likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:kME999999 forState:UIControlStateNormal];
    }
    
    [self layoutIfNeeded];
}

- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
    return _model.images.count;
}
- (YBImageBrowserModel *)yBImageBrowser:(YBImageBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index {
    NSString *urlStr = [_model.images objectAtIndex:index];
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    model.url = [NSURL URLWithString:urlStr];
    return model;
}
- (UIImageView *)imageViewOfTouchForImageBrowser:(YBImageBrowser *)imageBrowser {
    return [_gridView.arrImageView objectAtIndex:_currentIndex];
}

- (IBAction)likeBtnAction:(id)sender {
    //点赞
    kMeCallBlock(self.indexBlock,0);
}

+ (CGFloat)getCellHeightithModel:(MEPublicShowDetailModel *)model{
    CGFloat height = 20+22+6+16+16;
    NSString *str = kMeUnNilStr(model.content);
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:12] width:kmainCommentCellWdith lineH:0 maxLine:0];
    height += titleHeight>17?titleHeight:17;
    height += 11;
    
    NSArray *photo = kMeUnArr(model.images);
    if(photo.count){
        height+= [MENineGridView getPublicShowViewHeightWithArr:photo];
        height+=17;
    }else{
        height+=14;
    }
    height+=18+15;
    return height;
    
}

@end
