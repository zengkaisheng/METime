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
#import "MEPersonalCourseHeader.h"
#import "MEOnlineCourseHomeModel.h"
#import "MECourseDetailVC.h"
#import "MEOnlineCourseVC.h"
#import "MEOnlineCourseListModel.h"
#import "MECourseVideoListVC.h"

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
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
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
//    return 2;
    return self.model.category.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (kMeUnArr(self.model.onLine_banner).count > 0) {
            return 1;
        }else {
            return 0;
        }
    }
//    return self.model.video_list.data.count;
    MECourseHomeCategoryModel *categoryModel = self.model.category[section-1];
    return categoryModel.video_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MECourseAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECourseAdvertisementCell class]) forIndexPath:indexPath];
        [cell setUIWithArray:kMeUnArr(self.model.onLine_banner)];
        kMeWEAKSELF
        cell.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (strongSelf.selectedBlock) {
                strongSelf.selectedBlock(index);
            }
        };
        return cell;
    }
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
//    MEOnlineCourseListModel *model = self.model.video_list.data[indexPath.row];
//    [cell setUIWithModel:model isHomeVC:YES];
    MECourseHomeCategoryModel *categoryModel = self.model.category[indexPath.section-1];
    MEOnlineCourseListModel *model = categoryModel.video_list[indexPath.row];
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
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH-30, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.layer.cornerRadius = 5;
        headerView.layer.masksToBounds = YES;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 21)];
        titleLbl.font = [UIFont boldSystemFontOfSize:15];
        titleLbl.text = @"在线课程";
        [headerView addSubview:titleLbl];
        return headerView;
    }
    
    MEPersonalCourseHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
     MECourseHomeCategoryModel *categoryModel = self.model.category[section-1];
    [header setUIWithTitle:kMeUnNilStr(categoryModel.video_type_name)];
    kMeWEAKSELF
    header.tapBlock = ^{
        kMeSTRONGSELF
         MEOnlineCourseVC *homevc = (MEOnlineCourseVC *)[MECommonTool getVCWithClassWtihClassName:[MEOnlineCourseVC class] targetResponderView:strongSelf];
        MECourseVideoListVC *vc = [[MECourseVideoListVC alloc] initWithCategoryId:categoryModel.idField listType:@""];
        vc.title = kMeUnNilStr(categoryModel.video_type_name);
        if (homevc) {
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    };
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseHomeCategoryModel *categoryModel = self.model.category[indexPath.section-1];
    MEOnlineCourseListModel *model = categoryModel.video_list[indexPath.row];
    
//    MEOnlineCourseListModel *model = self.model.video_list.data[indexPath.row];
    MEOnlineCourseVC *homevc = (MEOnlineCourseVC *)[MECommonTool getVCWithClassWtihClassName:[MEOnlineCourseVC class] targetResponderView:self];
    if (kMeUnNilStr(model.video_urls).length > 0) {
        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:0];
        if (homevc) {
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    }else if (kMeUnNilStr(model.audio_urls).length > 0) {
        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:1];
        if (homevc) {
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)setUpUIWithModel:(MEOnlineCourseHomeModel *)model {
    self.model = model;
    [self.tableView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
