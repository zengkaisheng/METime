//
//  MEPersonalCourseHeader.m
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseHeader.h"

@interface MEPersonalCourseHeader ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblConsLeading;

@end


@implementation MEPersonalCourseHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithTitle:(NSString *)title {
    _redImageView.hidden = YES;
    _titleLblConsLeading.constant = 17.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _titleLbl.text = title;
}

- (void)setNewUIWithTitle:(NSString *)title {
    _redImageView.hidden = NO;
    _titleLblConsLeading.constant = 15+14;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _titleLbl.text = title;
}

- (IBAction)checkMoreAction:(id)sender {
    kMeCallBlock(_tapBlock);
}

@end
