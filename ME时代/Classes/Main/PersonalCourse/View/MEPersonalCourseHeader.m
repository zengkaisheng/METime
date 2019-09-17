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

@end


@implementation MEPersonalCourseHeader

- (void)setUIWithTitle:(NSString *)title {
    self.contentView.backgroundColor = [UIColor whiteColor];
    _titleLbl.text = title;
}

- (IBAction)checkMoreAction:(id)sender {
    kMeCallBlock(_tapBlock);
}

@end
