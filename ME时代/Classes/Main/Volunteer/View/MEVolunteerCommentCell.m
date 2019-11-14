//
//  MEVolunteerCommentCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVolunteerCommentCell.h"
#import "MECommentContentCell.h"
#import "MERecruitDetailModel.h"

@interface MEVolunteerCommentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsLeading;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (nonatomic, strong) NSArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConsHeight;

@end

@implementation MEVolunteerCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommentContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECommentContentCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
//    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.cornerRadius = 11;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
    
    _bottomViewConsHeight.constant = 0.0;
    _bottomView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MERecruitCommentModel *)model {
    _bottomViewConsHeight.constant = 0.0;
    _bottomView.hidden = YES;
    _headerPicConsLeading.constant = 12.0;
    kSDLoadImg(_headerPic, kMeUnNilStr(model.header_pic));
    _nameLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.name)];
    _contentLbl.text = kMeUnNilStr(model.content);
    self.dataSource = model.comment_back;
    [_answerBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)setListUIWithModel:(MERecruitCommentModel *)model {
    _bottomViewConsHeight.constant = 0.0;
    _bottomView.hidden = YES;
    _headerPicConsLeading.constant = 34.0;
    kSDLoadImg(_headerPic, kMeUnNilStr(model.header_pic));
    _nameLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.name)];
    _contentLbl.text = kMeUnNilStr(model.content);
    self.dataSource = model.comment_back;
    [_answerBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)setSelfCommentUIWithModel:(MERecruitCommentModel *)model {
    _headerPicConsLeading.constant = 15.0;
    kSDLoadImg(_headerPic, kMeUnNilStr(model.header_pic));
    _nameLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.name)];
    _contentLbl.text = kMeUnNilStr(model.content);
    self.dataSource = model.comment_back;
    [_answerBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.tableView reloadData];
    
    _bottomViewConsHeight.constant = 36.5;
    self.bottomView.hidden = NO;
    _activityTitleLbl.text = kMeUnNilStr(model.activity);
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommentContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECommentContentCell class]) forIndexPath:indexPath];
    MERecruitCommentBackModel *model = self.dataSource[indexPath.row];
    [cell setUIWithName:kMeUnNilStr(model.name) content:kMeUnNilStr(model.content)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MERecruitCommentBackModel *model = self.dataSource[indexPath.row];
    return model.contentHeight+15;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (IBAction)answerAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"title:%@",btn.titleLabel.text);
    kMeCallBlock(_answerBlock,btn.titleLabel.text);
}

- (IBAction)checkDetailAction:(id)sender {
    kMeCallBlock(_answerBlock,@"详情");
}

@end
