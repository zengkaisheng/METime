//
//  MEOrderSelectStoreCell.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEOrderSelectStoreCell.h"

@interface MEOrderSelectStoreCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;


@end

@implementation MEOrderSelectStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithSubtitle:(NSString *)subtitle title:(NSString *)title{
    if(kMeUnNilStr(subtitle).length){
        _lblSubtitle.text = kMeUnNilStr(subtitle);
    }else{
        _lblSubtitle.text = @"请选择";
    }
    _lblTitle.text = kMeUnNilStr(title);
}

@end
