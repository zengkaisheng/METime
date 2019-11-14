//
//  MERecruitCommentCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitCommentCell.h"
#import "MEVolunteerCommentCell.h"
#import "MERecruitDetailModel.h"

@interface MERecruitCommentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation MERecruitCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVolunteerCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVolunteerCommentCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
//    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithArray:(NSArray *)array {
    self.dataSource = array;
    _titleLbl.text = @"留言咨询";
    [self.tableView reloadData];
}

- (void)setShowUIWithArray:(NSArray *)array {
    self.dataSource = array;
    _titleLbl.text = @"评论";
    [self.tableView reloadData];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEVolunteerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVolunteerCommentCell class]) forIndexPath:indexPath];
    MERecruitCommentModel *model = self.dataSource[indexPath.row];
    kMeWEAKSELF
    cell.answerBlock = ^(NSString *str) {
        kMeSTRONGSELF
//        NSLog(@"str:%@",str);
        kMeCallBlock(strongSelf->_tapBlock,str,indexPath.row);
    };
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MERecruitCommentModel *model = self.dataSource[indexPath.row];
    return model.contentHeight;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

@end
