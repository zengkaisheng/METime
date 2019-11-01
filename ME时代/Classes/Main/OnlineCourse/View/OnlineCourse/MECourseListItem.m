//
//  MECourseListItem.m
//  志愿星
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseListItem.h"
#import "MEOnlineCourseListModel.h"

@interface MECourseListItem ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation MECourseListItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithModel:(MEOnlineCourseListModel *)model {
    _titleLbl.text = kMeUnNilStr(model.video_name);
    
    if (model.isSelected) {
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"#FBB8B8"].CGColor;
        _bgView.layer.borderWidth = 1.0;
        _titleLbl.textColor = [UIColor colorWithHexString:@"#FBB8B8"];
    }else {
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
        _bgView.layer.borderWidth = 1.0;
        _titleLbl.textColor = [UIColor blackColor];
    }
}

@end
