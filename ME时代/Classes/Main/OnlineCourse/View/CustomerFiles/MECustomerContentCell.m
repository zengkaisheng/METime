//
//  MECustomerContentCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerContentCell.h"
#import "MEDiagnoseQuestionHeaderView.h"
#import "MECustomerAddInfoCell.h"

@interface MECustomerContentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end


@implementation MECustomerContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseQuestionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerAddInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerAddInfoCell class])];
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDiagnoseReportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDiagnoseReportCell class])];
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEReportSuggestsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEReportSuggestsCell class])];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
    
    _tableView.layer.shadowOffset = CGSizeMake(0, 1);
    _tableView.layer.shadowOpacity = 1;
    _tableView.layer.shadowRadius = 3;
    _tableView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _tableView.layer.masksToBounds = false;
    _tableView.layer.cornerRadius = 5;
    _tableView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerAddInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerAddInfoCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MEDiagnoseQuestionHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEDiagnoseQuestionHeaderView class])];
    [footerView setUIWithTitle:@"" font:0.0 isHiddenBtn:YES];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//建议
- (void)setUIWithArray:(NSArray *)array {
    self.datas = [array copy];
    [self.tableView reloadData];
}

+ (CGFloat)getCellHeightWithArray:(NSArray *)array {
    CGFloat height = 49.0;
//    for (int i = 0; i < array.count; i++) {
//        NSString *str = [NSString stringWithFormat:@"%d、%@",i+1,array[i]];
//        height += [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
//    }
    return height+20;
}

@end
