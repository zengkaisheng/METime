//
//  MEBrandTriangleCell.m
//  ME时代
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandTriangleCell.h"
#import "MEBrandManngerAllModel.h"

@interface MEBrandTriangleCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblOne;
@property (weak, nonatomic) IBOutlet UILabel *lblTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblThree;
@property (weak, nonatomic) IBOutlet UILabel *lblFive;

@end

@implementation MEBrandTriangleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEBrandManngerAllModel *)model{
    _lblOne.text = kMeUnNilStr(model.Corporate.one);
    _lblTwo.text = kMeUnNilStr(model.Corporate.two);
    _lblThree.text = kMeUnNilStr(model.Corporate.three);
    _lblFive.text = kMeUnNilStr(model.Corporate.five);
}

@end
