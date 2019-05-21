//
//  MENewBaoQiangCell.m
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENewBaoQiangCell.h"
#import "MEGoodModel.h"

const static NSInteger kMEBaoQiangCellLimit  = 3;

@interface MENewBaoQiangCell ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrView;
@property (strong, nonatomic) NSArray *arrModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSubViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSubViewFlabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSubViewSlabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consimgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgSubViewHeight;


@end

@implementation MENewBaoQiangCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _consimgHeight.constant = 19*kMeFrameScaleX();
    _consTopMargin.constant = 14*kMeFrameScaleX();
    _consViewTopMargin.constant =10*kMeFrameScaleX();
    _consViewHeight.constant = 130*kMeFrameScaleX();
    _consSubViewTop.constant = 64 *kMeFrameScaleX();
    _consSubViewFlabelTop.constant = 11*kMeFrameScaleX();
    _consSubViewSlabelTop.constant = 12*kMeFrameScaleX();
    _consImgSubViewHeight.constant = 55 *kMeFrameScaleX();
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = kMeViewBaseTag + idx;
        UILabel *lblCommonPrice = [obj viewWithTag:102];
        UILabel *lblPrice = [obj viewWithTag:103];
        lblCommonPrice.adjustsFontSizeToFitWidth = YES;
        lblPrice.adjustsFontSizeToFitWidth = YES;
        lblPrice.textColor = kMEPink;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [obj addGestureRecognizer:ges];
    }];
    [self layoutIfNeeded];
    // Initialization code
}

- (void )tapView:(UITapGestureRecognizer *)ges{
    UIView *view = ges.view;
    NSInteger tag = view.tag-kMeViewBaseTag;
    kMeCallBlock(_indexBlock,tag);
}


- (void)setUIWithArr:(NSArray *)arrModel{
    _arrModel = arrModel;
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    for (int i=0; i<arrModel.count; i++) {
        if(i >= kMEBaoQiangCellLimit){
            break;
        }
        MEGoodModel *obj = arrModel[i];
        UIView *view = _arrView[i];
        view.hidden = NO;
        UIImageView *img = [view viewWithTag:100];
        UILabel *lblTitle = [view viewWithTag:101];
        UILabel *lblCommonPrice = [view viewWithTag:102];
        UILabel *lblPrice = [view viewWithTag:103];
        lblTitle.text = kMeUnNilStr(obj.title);
       
        NSString *commStr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.market_price).floatValue)];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:commStr attributes:attribtDic];
        lblCommonPrice.attributedText = attribtStr;

        lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.money).floatValue)];
        [img sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(obj.images_hot))] placeholderImage:kImgPlaceholder];
    }
}

@end
