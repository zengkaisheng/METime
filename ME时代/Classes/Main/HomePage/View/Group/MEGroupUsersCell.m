//
//  MEGroupUsersCell.m
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupUsersCell.h"
#import "MEGroupUserContentModel.h"
#import "MEGroupUserContentCell.h"

@interface MEGroupUsersCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end



@implementation MEGroupUsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_moreBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-115];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithArray:(NSArray *)array count:(NSString *)count {
    _countLbl.text = [NSString stringWithFormat:@"%@人在拼团，可直接参与",count];
    self.dataSource = [NSArray arrayWithArray:array];
    [self.contentView addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count>3?3:self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGroupUserContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGroupUserContentCell class]) forIndexPath:indexPath];
    MEGroupUserContentModel *model = self.dataSource[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kMeCallBlock(self.indexBlock,indexPath.row);
}

- (UIView *)createLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    return line;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, (self.dataSource.count>3?3:self.dataSource.count)*66) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGroupUserContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGroupUserContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEf5f4f4;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (IBAction)moreAction:(id)sender {
    kMeCallBlock(self.checkMoreBlock);
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
