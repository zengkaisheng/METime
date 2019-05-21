//
//  MEAiCustomerDetailCell.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAiCustomerDetailCell.h"
#import "MEStarControl.h"
#import "MEFlowLabelView.h"
#import "MEAiCustomerDetailModel.h"

#define kMEAiCustomerDetailCellFlowWdith (SCREEN_WIDTH - 60)
const static CGFloat kFlowWdithHeight = 21;

@interface MEAiCustomerDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet MEStarControl *statrt;
@property (weak, nonatomic) IBOutlet MEFlowLabelView *flowlabel;
@property (weak, nonatomic) IBOutlet UILabel *lblAppoint;
@property (weak, nonatomic) IBOutlet UILabel *lblFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowB;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTag;


@end

@implementation MEAiCustomerDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _flowlabel.flowLabelViewWdith = kMEAiCustomerDetailCellFlowWdith;
    _flowlabel.flowLabelViewLabelHeight = kFlowWdithHeight;
    // Initialization code
}

- (void)setUIWithModel:(MEAiCustomerDetailModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.header_pic));
    _lblTitle.text = kMeUnNilStr(model.nick_name);
    _statrt.score = model.star_level;
    _lblAppoint.text = kMeUnNilStr(model.predict_bargain).length?model.predict_bargain:@"0";
    _lblFollow.text = kMeUnNilStr(model.follow_up).length?model.follow_up:@"0";
    _lblFollowB.hidden = ([kMeUnNilStr(model.follow_up) isEqualToString:@"成交"]||[kMeUnNilStr(model.follow_up) isEqualToString:@"无法签单"]);
    if(kMeUnArr(model.label).count){
        [_flowlabel reloaCustomWithArr:kMeUnArr(model.label) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"55ba14"] backGroundColor:[UIColor colorWithHexString:@"ddf0d0"]];
    }else{
         [_flowlabel reloaCustomWithArr:@[@"添加标签"] font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"55ba14"] backGroundColor:[UIColor colorWithHexString:@"ddf0d0"]];
    }
    [self layoutIfNeeded];
}

+ (CGFloat)getCellHeightWithModel:(MEAiCustomerDetailModel *)model{
    CGFloat height = 255-kFlowWdithHeight;
    CGFloat flowHeight = [MEFlowLabelView getCustomMEFlowLabelViewHeightWithArr:kMeUnArr(model.label) wdith:kMEAiCustomerDetailCellFlowWdith LabelViewLabelHeight:kFlowWdithHeight font:[UIFont systemFontOfSize:12]];
    if(kMeUnArr(model.label).count == 0){
        height +=kFlowWdithHeight;
    }
    return (height + flowHeight);
}

- (IBAction)followAction:(UIButton *)sender {
    kMeCallBlock(_followBlock);
}

- (IBAction)addTagAction:(UIButton *)sender {
    kMeCallBlock(_addTagBlock);
}


@end
