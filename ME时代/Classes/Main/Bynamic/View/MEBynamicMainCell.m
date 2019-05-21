//
//  MEBynamicMainCell.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicMainCell.h"
#import "MEBynamicCommentView.h"
#import "MENineGridView.h"
#import "MEBynamicHomeModel.h"
#import "YBImageBrowser.h"

#define kmainCommentCellWdith (SCREEN_WIDTH - 10 -36-10-10)

#define kmainCommentCellStoreWdith (SCREEN_WIDTH - 10 -36-10-10-5-42-20)

@interface MEBynamicMainCell ()<YBImageBrowserDataSource>{
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet MENineGridView *gridView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consGridViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet MEBynamicCommentView *viewCommentAndLike;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consComentHeight;
@property (strong, nonatomic) MEBynamicHomeModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;


@property (weak, nonatomic) IBOutlet UIView *viewForStore;
@property (weak, nonatomic) IBOutlet UIImageView *imgStoreHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consStoreTitleHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consDelW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consDelLeft;

@end

@implementation MEBynamicMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _currentIndex = 0;
    self.selectionStyle = 0;
    _btnShare.hidden =  ![WXApi isWXAppInstalled];
    // Initialization code
}

- (void)setUIWithModel:(MEBynamicHomeModel *)model{
    _model = model;
    if(kMeUnNilStr(model.member_id).length == 0){
        _btnDel.hidden = YES;
        _consDelW.constant = 0;
        _consDelLeft.constant = 0;
    }else{
        if([kMeUnNilStr(model.member_id) isEqualToString:kCurrentUser.uid]){
             _btnDel.hidden = NO;
            _consDelW.constant = 32;
            _consDelLeft.constant = 8;
        }else{
            _btnDel.hidden = YES;
            _consDelW.constant = 0;
            _consDelLeft.constant = 0;
        }
    }
    _currentIndex = 0;
    _btnLike.selected =  model.praise_over;
//    _imgHeader.image = [UIImage imageNamed:@"icon-wgvilogo"];
    kSDLoadImg(_imgHeader, kMeUnNilStr(model.header_pic));
    _lblName.text = kMeUnNilStr(model.author);
    _lblTime.text = kMeUnNilStr(model.created_at);
    NSString *str = kMeUnNilStr(model.content);
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:14] width:kmainCommentCellWdith lineH:0 maxLine:0];
    _consTitleHeight.constant = titleHeight>17?titleHeight:17;
    [_lblTitle setAtsWithStr:kMeUnNilStr(model.content) lineGap:0];
    
     _consGridViewHeight.constant = [MENineGridView getDymmaincViewHeightWIth:kMeUnArr(model.images)];
    [_gridView setImageDymamicViewWithArr:kMeUnArr(model.images)];
    kMeWEAKSELF
    _gridView.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        strongSelf->_currentIndex = index;
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSource = strongSelf;
        browser.currentIndex = index;
        [browser show];
    };

    _consComentHeight.constant = [MEBynamicCommentView getViewHeightWithArrLike:kMeUnArr(model.praise) Arrcomment:kMeUnArr(model.comment)];
    
    _viewCommentAndLike.hidden = (kMeUnArr(model.praise).count==0 && kMeUnArr(model.comment).count==0);
    
    [_viewCommentAndLike setUIWithArrLike:kMeUnArr(model.praise) Arrcomment:kMeUnArr(model.comment)];
    if(model.product_id){
        _viewForStore.hidden = NO;
        kSDLoadImg(_imgStoreHeader, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.goods_images)));
        NSString *str = kMeUnNilStr(model.goods_title);
        CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:12] width:kmainCommentCellStoreWdith lineH:0 maxLine:0]+16;
        _consStoreTitleHeight.constant = titleHeight>57?titleHeight:57;
        [_lblStoreTitle setAtsWithStr:str lineGap:0];
    }else{
        _viewForStore.hidden = YES;
        _consStoreTitleHeight.constant = 0 ;
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

- (IBAction)shareAction:(UIButton *)sender {
    kMeCallBlock(_shareBlock);
}

- (IBAction)likeAction:(UIButton *)sender {
    if(!sender.selected){
        kMeCallBlock(_LikeBlock);
    }
}

- (IBAction)commentAction:(UIButton *)sender {
    kMeCallBlock(_CommentBlock);
}

- (IBAction)delAction:(UIButton *)sender {
    kMeCallBlock(_delBlock);
}

- (IBAction)saveAction:(UIButton *)sender {
    kMeCallBlock(_saveBlock);
}

+ (CGFloat)getCellHeightithModel:(MEBynamicHomeModel *)model{
    CGFloat height = 11+20+7;
    NSString *str = kMeUnNilStr(model.content);
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:14] width:kmainCommentCellWdith lineH:0 maxLine:0];
    height += titleHeight>17?titleHeight:17;
    
    NSArray *photo = kMeUnArr(model.images);
    if(photo.count){
        height+= [MENineGridView getDymmaincViewHeightWIth:photo];
        height+=17;
    }else{
        height+=14;
    }
    if(model.product_id){
        NSString *str = kMeUnNilStr(model.goods_title);
        CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:12] width:kmainCommentCellStoreWdith lineH:0 maxLine:0]+16;
        height+=titleHeight>57?titleHeight:57;
        height+=10;
    }
    
    height+=25;
    height+=[MEBynamicCommentView getViewHeightWithArrLike:kMeUnArr(model.praise) Arrcomment:kMeUnArr(model.comment)];
    height+=10;
    return height;
    
}

@end
