//
//  MECourseDetailHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseDetailHeaderView.h"
#import "MECourseDetailModel.h"

@interface MECourseDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseListBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation MECourseDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor *normalColor = [UIColor blackColor];
    UIColor *selectedColor = [UIColor colorWithHexString:@"#FFA8A8"];
    [self.introduceBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.introduceBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    [self.courseListBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.courseListBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    self.introduceBtn.selected = YES;
    self.courseListBtn.selected = NO;
}

- (void)setUIWithModel:(MECourseDetailModel *)model index:(NSInteger)index {
    if (index == 0) {
        self.introduceBtn.selected = YES;
        self.courseListBtn.selected = NO;
    }else if (index == 1) {
        self.introduceBtn.selected = NO;
        self.courseListBtn.selected = YES;
    }
    kSDLoadImg(_headerPic, kMeUnNilStr(model.images_url));
    
    if (kMeUnNilStr(model.video_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.video_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.video_price)];
        _descLbl.text = kMeUnNilStr(model.video_desc);
    }else if (kMeUnNilStr(model.audio_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.audio_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.audio_price)];
        _descLbl.text = kMeUnNilStr(model.audio_desc);
    }
    
    _learnCountLbl.text = [NSString stringWithFormat:@"%@次学习",@(model.browse)];
    _priceLbl.hidden = model.is_charge==2?YES:NO;
}

- (IBAction)courseIntroduceAction:(id)sender {
    self.introduceBtn.selected = YES;
    self.courseListBtn.selected = NO;
    kMeCallBlock(_selectedBlock,0);
}
- (IBAction)courseListAction:(id)sender {
    self.introduceBtn.selected = NO;
    self.courseListBtn.selected = YES;
    kMeCallBlock(_selectedBlock,1);
}

@end
