//
//  MECourseDetailHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseDetailHeaderView.h"

@interface MECourseDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseListBtn;

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

- (void)setUIWithModel:(id)model index:(NSInteger)index {
    if (index == 0) {
        self.introduceBtn.selected = YES;
        self.courseListBtn.selected = NO;
    }else if (index == 1) {
        self.introduceBtn.selected = NO;
        self.courseListBtn.selected = YES;
    }
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
