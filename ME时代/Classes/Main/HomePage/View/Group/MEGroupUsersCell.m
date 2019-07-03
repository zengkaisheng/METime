//
//  MEGroupUsersCell.m
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupUsersCell.h"
#import "MEGroupUserContentModel.h"

@interface MEGroupUsersCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end



@implementation MEGroupUsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_moreBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-110];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithArray:(NSArray *)array {
    for (UIView *view in self.contentView.subviews) {
        if (view.tag > 99) {
            [view removeFromSuperview];
        }
    }
    CGFloat height = 66;
    if (array.count > 0) {
        NSInteger count = array.count>3?3:array.count;
        for (int i = 0; i < count; i++) {
            MEGroupUserContentModel *model = array[i];
            UIView *view = [self createSubViewWithImage:model.header_pic name:model.name count:model.num time:@"剩余01时01分01秒" frame:CGRectMake(0, 41+height*i, SCREEN_WIDTH, height) tag:100+i];
            if (i < count-1) {
                UIView *line = [self createLineView];
                line.frame = CGRectMake(15, 65, SCREEN_WIDTH-30, 1);
                [view addSubview:line];
            }
            [self.contentView addSubview:view];
        }
    }
}

- (UIView *)createLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    return line;
}

- (UIView *)createSubViewWithImage:(NSString *)image name:(NSString *)name count:(NSString *)count time:(NSString *)time frame:(CGRect)frame tag:(NSInteger)tag {
    UIView *subView = [[UIView alloc] initWithFrame:frame];
    //头像
    UIImageView *headerPic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 40, 40)];
    kSDLoadImg(headerPic, image);
    headerPic.layer.cornerRadius = 20;
    headerPic.backgroundColor = [UIColor colorWithHexString:@"#A6A6A6"];
    [subView addSubview:headerPic];
    //name
    UILabel *nameLbl = [self createLabelWithTitle:name color:kME333333 font:15.0 textAlignment:NSTextAlignmentLeft];
    nameLbl.frame = CGRectMake(CGRectGetMaxX(headerPic.frame)+15, 26, SCREEN_WIDTH-200-75, 14);
    [subView addSubview:nameLbl];
    //count
    NSString *countStr = [NSString stringWithFormat:@"还差%@人拼成",count];
    UILabel *countLbl = [self createLabelWithTitle:countStr color:kME333333 font:12.0 textAlignment:NSTextAlignmentRight];
    countLbl.frame = CGRectMake(SCREEN_WIDTH-105-80, 19, 80, 12);
    
    NSMutableAttributedString *attribStr = [[NSMutableAttributedString alloc] initWithString:countStr];
    NSRange range = [countStr rangeOfString:[NSString stringWithFormat:@"%@人",count]];
    [attribStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF0000"] range:range];
    countLbl.attributedText = attribStr;
    [subView addSubview:countLbl];
    //time
    UILabel *timeLbl = [self createLabelWithTitle:time color:kME666666 font:11.0 textAlignment:NSTextAlignmentRight];
    timeLbl.frame = CGRectMake(SCREEN_WIDTH-105-100, 35, 100, 11);
    [subView addSubview:timeLbl];
    //button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH-15-75, 20, 75, 25);
    [btn setTitle:@"去拼团" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#FF0000"]];
    btn.layer.cornerRadius = 25/2.0;
    btn.tag = tag;
    [btn addTarget:self action:@selector(gotoGroup:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:btn];
    subView.tag = tag;
    
    return subView;
}

- (UILabel *)createLabelWithTitle:(NSString *)title color:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment {
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.textColor = color;
    lab.font = [UIFont systemFontOfSize:font];
    lab.textAlignment = textAlignment;
    return lab;
}

- (void)gotoGroup:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"点击了第%ld个按钮",btn.tag-100);
}

- (IBAction)moreAction:(id)sender {
    
}

+ (CGFloat)getHeightWithArray:(NSArray *)array {
    CGFloat height = 41+10;
    if (array.count > 0) {
        NSInteger count = array.count>3?3:array.count;
        height += 66*count;
        return height;
    }else {
        return 0.1;
    }
}

@end
