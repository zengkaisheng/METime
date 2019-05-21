//
//  MEMemberHomeDeanCell.m
//  ME时代
//
//  Created by hank on 2018/10/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMemberHomeDeanCell.h"
#import "MEGoodModel.h"

const static NSInteger kMEMemberHomeDeanCellLimit  = 3;
#define kMEMemberHomeDeanCellBaseTag (1000)

@interface MEMemberHomeDeanCell ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrView;

@end

@implementation MEMemberHomeDeanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [_arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = kMEMemberHomeDeanCellBaseTag + idx;
        obj.userInteractionEnabled = NO;
        obj.hidden = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [obj addGestureRecognizer:ges];
    }];
    // Initialization code
}

- (void )tapView:(UITapGestureRecognizer *)ges{
    UIView *view = ges.view;
    NSInteger tag = view.tag-kMEMemberHomeDeanCellBaseTag;
    kMeCallBlock(_indexBlock,tag);
}

- (void)setUIWithArr:(NSArray *)arrModel{
    for (int i=0; i<arrModel.count; i++) {
        if(i >= kMEMemberHomeDeanCellLimit){
            break;
        }
        MEGoodModel *model = arrModel[i];
        UIView *view = _arrView[i];
        view.userInteractionEnabled = YES;
        view.hidden = NO;
        UIImageView *img = [view viewWithTag:100];
        UILabel *lblTitle = [view viewWithTag:101];
        UILabel *lblDean = [view viewWithTag:102];
        kSDLoadImg (img,MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
//        kSDLoadImg(img, MELoadQiniuImagesWithUrl(kMeUnNilStr(@"")));
        lblTitle.text = kMeUnNilStr(model.title);
        lblDean.text =[NSString stringWithFormat:@"%@美豆",model.integral_lines];
    }
}

@end
