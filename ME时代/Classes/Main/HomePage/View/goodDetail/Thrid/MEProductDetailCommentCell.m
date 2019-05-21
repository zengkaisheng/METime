//
//  MEProductDetailCommentCell.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEProductDetailCommentCell.h"
#import "MENineGridView.h"
#import "MEStarControl.h"
#import "YBImageBrowser.h"
#import "MEGoodsCommentModel.h"

@interface MEProductDetailCommentCell()<YBImageBrowserDataSource>{
    MEGoodsCommentModel *_model;
    NSInteger _currentIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet MEStarControl *starView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet MENineGridView *viewForPhoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consPhotoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;

@end

@implementation MEProductDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUiWIthModel:(MEGoodsCommentModel *)model{
    _model = model;
    _currentIndex = 0;
    kSDLoadImg(_imgHeader, kMeUnNilStr(model.header_pic));
    _lblName.text = kMeUnNilStr(model.nick_name);
    _lblSku.text = kMeUnNilStr(model.sku);
    _starView.score = model.value;
    [_viewForPhoto setImageViewWithArr:kMeUnArr(model.images)];
    kMeWEAKSELF
    _viewForPhoto.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        strongSelf->_currentIndex = index;
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSource = strongSelf;
        browser.currentIndex = index;
        [browser show];
    };
    _consPhotoHeight.constant = [MENineGridView getViewHeightWIth:kMeUnArr(model.images)];
    NSString *str = kMeUnNilStr(model.comment);
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:14] width:(SCREEN_WIDTH - 20) lineH:0 maxLine:0];
    _consTitleHeight.constant = titleHeight>17?titleHeight:17;
    [_lblTitle setAtsWithStr:kMeUnNilStr(str) lineGap:0];
    [self layoutIfNeeded];
}

//YBImageBrowserDataSource 代理实现赋值数据
- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
    return kMeUnArr(_model.images).count;
}
- (YBImageBrowserModel *)yBImageBrowser:(YBImageBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index {
    NSString *urlStr = [kMeUnArr(_model.images) objectAtIndex:index];
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    model.url = [NSURL URLWithString:urlStr];
    //model.sourceImageView = [imageViewArray objectAtIndex:index];
    return model;
}
- (UIImageView *)imageViewOfTouchForImageBrowser:(YBImageBrowser *)imageBrowser {
    return [_viewForPhoto.arrImageView objectAtIndex:_currentIndex];
}

+ (CGFloat)getCellHeightWithModel:(MEGoodsCommentModel *)model{
    CGFloat height = 10+10+40+10+15+10+10;
    NSString *str = kMeUnNilStr(model.comment);
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:14] width:(SCREEN_WIDTH - 20) lineH:0 maxLine:0];
    height+=titleHeight>17?titleHeight:17;
    CGFloat photoheight = [MENineGridView getViewHeightWIth:kMeUnArr(model.images)];
    if(photoheight>0){
        height+=(14+photoheight);
    }else{
        height+=10;
    }
    return height;
}


@end
