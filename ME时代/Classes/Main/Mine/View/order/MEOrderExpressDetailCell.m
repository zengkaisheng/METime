//
//  MEOrderExpressDetailCell.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEOrderExpressDetailCell.h"
#import "MEOrderDetailModel.h"

@interface MEOrderExpressDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblExpressNum;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *arrImg;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;

@end

@implementation MEOrderExpressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWIthModel:(MEexpressDetailModel *)model{
    _lblExpressNum.text = [NSString stringWithFormat:@"%@:%@",kMeUnNilStr(model.express_name),kMeUnNilStr(model.express_num)];
    [_arrImg enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    kMeWEAKSELF
    [model.data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kMeSTRONGSELF
        UIImageView *img = strongSelf->_arrImg[idx];
        img.hidden = NO;
        kSDLoadImg(img, kMeUnNilStr(obj[@"images_url"]));
    }];
    _lblNum.text = [NSString stringWithFormat:@"共%@件商品",@(kMeUnArr(model.data).count).description];
}

+ (CGFloat)getCellHeightWithModel:(MEexpressDetailModel *)model{
    CGFloat height = 192 - 94;
    NSArray *arr = kMeUnArr(model.data);
    if(arr.count){
        CGFloat h = (SCREEN_WIDTH - 40)/3;
        return height +h;
    }else{
        return height - 15;
    }
    
}
@end
