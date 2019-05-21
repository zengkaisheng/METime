//
//  MEBaoQiangCell.m
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaoQiangCell.h"
#import "MEGoodModel.h"


const static NSInteger kMEBaoQiangCellLimit  = 3;

#define kVMEBaoQiangCelliewBaseTag (2000)

@interface MEBaoQiangCell (){
    
}

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrView;
@property (strong, nonatomic) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewWdith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblWdith;

@end

@implementation MEBaoQiangCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _consViewWdith.constant = 100*kMeFrameScaleX();
    _lblWdith.constant =37*kMeFrameScaleX();
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = kVMEBaoQiangCelliewBaseTag + idx;
        UILabel *lblPrice = [obj viewWithTag:102];
        UILabel *lblIntergal = [obj viewWithTag:104];
        lblPrice.adjustsFontSizeToFitWidth = YES;
        lblIntergal.adjustsFontSizeToFitWidth = YES;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [obj addGestureRecognizer:ges];
    }];
}

- (void )tapView:(UITapGestureRecognizer *)ges{
    UIView *view = ges.view;
    NSInteger tag = view.tag-kVMEBaoQiangCelliewBaseTag;
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
        UILabel *lbl = [view viewWithTag:101];
        UILabel *lblPrice = [view viewWithTag:102];
        UILabel *lblIntergal = [view viewWithTag:104];
        UIImageView *imgTop = [view viewWithTag:105];
        imgTop.image = [UIImage imageNamed:@(i+1).description];
        lbl.text = kMeUnNilStr(obj.title);
        
        lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.market_price).floatValue)];
        lblIntergal.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(obj.money).floatValue)];
        [img sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(obj.images))] placeholderImage:kImgPlaceholder];
    }

}

+ (CGFloat)getCellHeightWithArr:(NSArray *)arr{
    return arr.count>0?kMEBaoQiangCellHeoght:kMEBaoQiangCellTitleHeight;
}

@end
