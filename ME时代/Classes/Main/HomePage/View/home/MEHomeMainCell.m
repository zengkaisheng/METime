//
//  MEHomeMainCell.m
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomeMainCell.h"
#import "MEGoodModel.h"

const static NSInteger kMEHomeProductCellLimit  = 6;
const static NSInteger kMEHomeServiceCellLimit  = 3;

#define kViewBaseTag (1000)
#define kImgHeight (184* kMeFrameScaleY())
#define kCellOrgialHeight (581)
#define kViewHeight (177)
#define kViewWdith (100 * kMeFrameScaleX())
#define kLblWdith (37 * kMeFrameScaleX())

@interface MEHomeMainCell(){
    
}

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgHeight;
@property (strong, nonatomic) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consWdith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblWdith;

@end

@implementation MEHomeMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //_consImgHeight.constant = kImgHeight;
    _consWdith.constant = kViewWdith;
    _lblWdith.constant = kLblWdith;
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = kViewBaseTag + idx;
        UILabel *lblPrice = [obj viewWithTag:102];
        UILabel *lblIntergal = [obj viewWithTag:104];

        lblPrice.adjustsFontSizeToFitWidth = YES;
        lblIntergal.adjustsFontSizeToFitWidth = YES;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [obj addGestureRecognizer:ges];
    }];
    _imgMainPic.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesimage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    [_imgMainPic addGestureRecognizer:gesimage];
    // Initialization code
}

- (void)tapImageView:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_imgTouchBlock);
}

- (void)setUIWithArr:(NSArray *)arrModel{
    _lblTitle.text = @"产品区";
    _arrModel = arrModel;
//    [_imgMainPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kImgPlaceholder];
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    for (int i=0; i<arrModel.count; i++) {
        if(i >= kMEHomeProductCellLimit){
            break;
        }
        MEGoodModel * obj = arrModel[i];
        UIView *view = _arrView[i];
        view.hidden = NO;
        UIImageView *img = [view viewWithTag:100];
        [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kImgPlaceholder];
        UILabel *lbl = [view viewWithTag:101];
        UILabel *lblPrice = [view viewWithTag:102];
        UILabel *lblIntergal = [view viewWithTag:104];
        UIImageView *imgIcon = [view viewWithTag:103];
        UIButton *btnAppoint = [view viewWithTag:105];
        btnAppoint.hidden = YES;
        imgIcon.hidden = NO;
        lblIntergal.hidden= NO;
        
        lbl.text = kMeUnNilStr(obj.title);
        lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.market_price).floatValue)];//kMeUnNilStr(obj.money);
        lblIntergal.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.money).floatValue)];//kMeUnNilStr(obj.market_price);
        [img sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(obj.images))] placeholderImage:kImgPlaceholder];
    }
    
}

- (void )tapView:(UITapGestureRecognizer *)ges{
    UIView *view = ges.view;
    NSInteger tag = view.tag-kViewBaseTag;
//    NSString *str = kMeUnArr(_arrModel)[tag];
    kMeCallBlock(_indexBlock,tag);
//    NSLog(@"%@",str);
}

- (void)setServiceUIWithArr:(NSArray *)arrModel{
    _lblTitle.text = @"服务区";
    
    _arrModel = arrModel;
//    [_imgMainPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kImgPlaceholder];
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    for (int i=0; i<arrModel.count; i++) {
        if(i >= kMEHomeServiceCellLimit){
            break;
        }
        MEGoodModel * obj = arrModel[i];
        UIView *view = _arrView[i];
        view.hidden = NO;
        UIImageView *img = [view viewWithTag:100];
        [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kImgPlaceholder];
        UILabel *lbl = [view viewWithTag:101];
        UILabel *lblPrice = [view viewWithTag:102];
        UILabel *lblIntergal = [view viewWithTag:104];
        UIImageView *imgIcon = [view viewWithTag:103];
        UIButton *btnAppoint = [view viewWithTag:105];
        btnAppoint.hidden = NO;
        lblIntergal.hidden = YES;
        imgIcon.hidden = YES;
        
        lbl.text = kMeUnNilStr(obj.title);
        lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.market_price).floatValue)];//kMeUnNilStr(obj.money);
        [img sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(obj.images))] placeholderImage:kImgPlaceholder];
    
    }
    
}

+ (CGFloat)getCellHeightWithArrModel:(NSArray *)arrModel{
    CGFloat cellHeight = kCellOrgialHeight;
    if(arrModel.count == 0){
        cellHeight = kCellOrgialHeight - (kViewHeight*2);
    }else if(arrModel.count>0 && arrModel.count <4){
        cellHeight = kCellOrgialHeight - kViewHeight;
    }else{
        
    }
    return cellHeight;
}

+ (CGFloat)getServiceCellHeightWithArrModel:(NSArray *)arrModel{
    CGFloat cellHeight = kCellOrgialHeight;
    NSUInteger count = arrModel.count>=kMEHomeServiceCellLimit?kMEHomeServiceCellLimit:arrModel.count;
    if(count == 0){
        cellHeight = kCellOrgialHeight - (kViewHeight*2);
    }else if(count>0 && count <4){
        cellHeight = kCellOrgialHeight - kViewHeight;
    }else{
        
    }
    return cellHeight;
}

@end
