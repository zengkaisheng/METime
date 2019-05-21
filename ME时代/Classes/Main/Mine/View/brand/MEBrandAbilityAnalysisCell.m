//
//  MEBrandAbilityAnalysisCell.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAbilityAnalysisCell.h"
#import "MEBrandAbilityAnalysisDataModel.h"

@interface MEBrandAbilityAnalysisCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;


@end

@implementation MEBrandAbilityAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEBrandAbilityAnalysisDataModel*)model{
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSubtitle.text = kMeUnNilStr(model.subtitle);
}

@end
