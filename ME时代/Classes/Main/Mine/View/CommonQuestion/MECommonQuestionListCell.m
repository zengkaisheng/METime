//
//  MECommonQuestionListCell.m
//  ME时代
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommonQuestionListCell.h"
#import "MECommonQuestionListModel.h"

@interface MECommonQuestionListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *HeaderLbl;

@end


@implementation MECommonQuestionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MECommonQuestionListModel *)model {
    kSDLoadImg(_headerImgV, model.icon);
    _HeaderLbl.text = model.name;
    if (model.problem.count > 0) {
        for (int i = 0; i < model.problem.count; i++) {
            MECommonQuestionSubModel *subModel = model.problem[i];
            UIView *subView = [self createSubViewWithModel:subModel frame:CGRectMake(0, 45*(i+1), SCREEN_WIDTH-22, 45) tag:100+i];
            [_bgView addSubview:subView];
        }
    }
}

- (UIView *)createSubViewWithModel:(MECommonQuestionSubModel *)subModel frame:(CGRect)frame tag:(NSInteger)tag{
    UIView *subView = [[UIView alloc] initWithFrame:frame];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, frame.size.width-8-30, 44)];
    titleLbl.text = [NSString stringWithFormat:@"%ld.%@",tag-99,subModel.title];
    titleLbl.font = [UIFont systemFontOfSize:13];
    titleLbl.numberOfLines = 2;
    [subView addSubview:titleLbl];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inco-yytmtmda"]];
    rightArrow.frame = CGRectMake(frame.size.width - 22, 15, 7, 12);
    [subView addSubview:rightArrow];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, frame.size.height-1, frame.size.width-16, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    [subView addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [subView addSubview:btn];
    
    return subView;
}

- (void)btnDidClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.indexBlock) {
        self.indexBlock(btn.tag - 100);
    }
}

@end
