//
//  MEBrandAiCell.m
//  ME时代
//
//  Created by hank on 2019/3/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAiCell.h"
#import "MEBrandAISortModel.h"

@interface MEBrandAiCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblSortNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAINum;
@property (weak, nonatomic) IBOutlet UIImageView *imgSort;
@property (weak, nonatomic) IBOutlet UILabel *lblSale;


@end

@implementation MEBrandAiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblSortNum.adjustsFontSizeToFitWidth  = YES;
    _lblAINum.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEBrandAISortModel *)model sortNum:(NSInteger)sortNum{
    _lblSortNum.text = @(sortNum+1).description;
    kSDLoadImg(_imgPic, kMeUnNilStr(model.header_pic));
    _lblName.text = kMeUnNilStr(model.store_name);
    _lblAINum.text = kMeUnNilStr(model.count);
    switch (sortNum) {
        case 0:{
            _imgSort.hidden = NO;
            _imgSort.image = [UIImage imageNamed:@"icon_brandAi_one"];
        }
            break;
        case 1:{
            _imgSort.hidden = NO;
            _imgSort.image = [UIImage imageNamed:@"icon_brandAi_two"];
        }
            break;
        case 2:{
            _imgSort.hidden = NO;
            _imgSort.image = [UIImage imageNamed:@"icon_brandAi_three"];
        }
            break;
        default:{
            _imgSort.hidden = YES;
        }
            break;
    }
}

- (void)setSortUIWithModel:(MEBrandAISortModel *)model sortNum:(NSInteger)sortNum{
    [self setUIWithModel:model sortNum:sortNum];
    _lblSale.hidden = YES;
}

@end
