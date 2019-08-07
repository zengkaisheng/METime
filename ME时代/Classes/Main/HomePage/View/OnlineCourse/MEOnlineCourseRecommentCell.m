//
//  MEOnlineCourseRecommentCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseRecommentCell.h"
#import "MECourseAdvertisementCell.h"
#import "MEOnlineCourseListCell.h"
#import "MEOnlineCourseHomeModel.h"
#import "MECourseDetailVC.h"
#import "MEOnlineCourseVC.h"

@interface MEOnlineCourseRecommentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHomeModel *model;

@end

@implementation MEOnlineCourseRecommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineCourseListCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECourseAdvertisementCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECourseAdvertisementCell class])];
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

#pragma mark -- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (kMeUnArr(self.model.onLine_banner).count > 0) {
            return 1;
        }else {
            return 0;
        }
    }
    return self.model.video_list.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MECourseAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECourseAdvertisementCell class]) forIndexPath:indexPath];
        [cell setUIWithArray:kMeUnArr(self.model.onLine_banner)];
        return cell;
    }
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];

    MEOnlineCourseListModel *model = self.model.video_list.data[indexPath.row];
    [cell setUIWithModel:model isHomeVC:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }
    return 89;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH-30, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = YES;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 21)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.text = @"在线课程";
    [headerView addSubview:titleLbl];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] init];
    MEOnlineCourseVC *homevc = (MEOnlineCourseVC *)[MECommonTool getVCWithClassWtihClassName:[MEOnlineCourseVC class] targetResponderView:self];
    if (homevc) {
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setUpUIWithModel:(MEOnlineCourseHomeModel *)model {
    self.model = model;
    [self.tableView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
