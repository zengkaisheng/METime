//
//  MEBrandAllDataCell.m
//  ME时代
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAllDataCell.h"
#import "MEBrandManngerAllModel.h"

@interface MEBrandAllDataCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblCustomAll;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderAll;
@property (weak, nonatomic) IBOutlet UILabel *lblDelaAll;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodVisterCount;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveVisetCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDymalVisterCount;


@end

@implementation MEBrandAllDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEBrandManngerAllModel *)model{
    _lblCustomAll.text = kMeUnNilStr(model.customer_count);
    _lblOrderAll.text = kMeUnNilStr(model.order_count);
    _lblDelaAll.text = kMeUnNilStr(model.deal_count);
    _lbGoodVisterCount.text = kMeUnNilStr(model.product_access);
    _lblActiveVisetCount.text = kMeUnNilStr(model.activity_access);
    _lblDymalVisterCount.text = kMeUnNilStr(model.dynamic_access);
}

@end
