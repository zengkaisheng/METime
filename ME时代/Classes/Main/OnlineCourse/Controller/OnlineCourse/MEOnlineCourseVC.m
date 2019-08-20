//
//  MEOnlineCourseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseVC.h"
#import "MEOnlineCourseHeaderView.h"

#import "MEOnlineConsultCell.h"
#import "MEOnlineToolsCell.h"
#import "MEOnlineCourseRecommentCell.h"
#import "MEAdModel.h"

#import "MEAudioCourseVC.h"
#import "MEOnlineDiagnoseVC.h"
#import "MEDiagnoseListVC.h"
#import "MEOnlineCourseHomeModel.h"
#import "MECourseListBaseVC.h"
#import "MECourseDetailVC.h"
#import "MECourseChargeOrFreeListVC.h"

#import "MECustomerFilesVC.h"

@interface MEOnlineCourseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) MEOnlineCourseHomeModel *model;

@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MEOnlineCourseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"在线课程";
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithArray:@[] type:0];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    self.model = [MEOnlineCourseHomeModel mj_objectWithKeyValues:data];
    [self.headerView setUIWithArray:self.model.top_banner type:0];
    [self.tableView reloadData];
}

#pragma mark -- Action
- (void)rightBtnAction{
    
}
//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
    switch (model.show_type) {//18视频 19音频
        case 18:
        {
            MECourseDetailVC *dvc = [[MECourseDetailVC alloc] initWithId:model.video_id type:0];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 19:
        {
            MECourseDetailVC *dvc = [[MECourseDetailVC alloc] initWithId:model.audio_id type:1];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MEOnlineConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineConsultCell class]) forIndexPath:indexPath];
        [cell setUIWithDict:@{@"title":@"报告诊断"}];
        return cell;
    }else if (indexPath.section == 1) {
        MEOnlineToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineToolsCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:@[]];
        kMeWEAKSELF
        cell.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            switch (index) {
                case 1:
                    NSLog(@"运营数据");
                    break;
                case 2:
                {
                    MECustomerFilesVC *filesVC = [[MECustomerFilesVC alloc] init];
                    [strongSelf.navigationController pushViewController:filesVC animated:YES];
                }
                    break;
                case 3:
                    NSLog(@"顾客服务");
                    break;
                case 4:
                    NSLog(@"顾客预约");
                    break;
                case 5:
                    NSLog(@"顾客消费");
                    break;
                default:
                    break;
            }
        };
        return cell;
    }else if (indexPath.section == 2) {
        MEOnlineConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineConsultCell class]) forIndexPath:indexPath];
        [cell setUIWithDict:@{@"title":@"诊断服务"}];
        return cell;
    }
    MEOnlineCourseRecommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseRecommentCell class]) forIndexPath:indexPath];
    [cell setUpUIWithModel:self.model];
    kMeWEAKSELF
    cell.selectedBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        MEAdModel *model = strongSelf.model.onLine_banner[index];
        [strongSelf cycleScrollViewDidSelectItemWithModel:model];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kMEOnlineConsultCellHeight;
    }else if (indexPath.section == 1) {
        return kMEOnlineToolsCellHeight;
    }else if (indexPath.section == 2) {
        return 93;
    }
    
    if (kMeUnArr(self.model.onLine_banner).count <= 0 && kMeUnArr(self.model.video_list.data).count <= 0) {
        return 0;
    }
    CGFloat height = 41.0+18.0;
    if (kMeUnArr(self.model.onLine_banner).count > 0) {
        height += 120;
    }
    if (kMeUnArr(self.model.video_list.data).count > 0) {
        height += 89*kMeUnArr(self.model.video_list.data).count;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 21)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    switch (section) {
        case 0:
            titleLbl.text = @"在线诊断";
            break;
        case 1:
            titleLbl.text = @"运营工具";
            break;
        case 2:
            titleLbl.text = @"专家诊断";
            break;
        default:
            break;
    }
    [headerView addSubview:titleLbl];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 12;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MEOnlineDiagnoseVC *onlineDiagnoseVC = [[MEOnlineDiagnoseVC alloc] init];
        [self.navigationController pushViewController:onlineDiagnoseVC animated:YES];
    } else if (indexPath.section == 2) {
        MEDiagnoseListVC *diagnoseList = [[MEDiagnoseListVC alloc] init];
        [self.navigationController pushViewController:diagnoseList animated:YES];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineConsultCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineConsultCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineToolsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineToolsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineCourseRecommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineCourseRecommentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonOnlineHomeIndex)];
        _refresh.delegate = self;
        _refresh.isDataInside = NO;
//        _refresh.showMaskView = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

- (MEOnlineCourseHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEOnlineCourseHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEOnlineCourseHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (index < 100) {
                MEAdModel *model = strongSelf.model.top_banner[index];
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            }else {
                switch (index) {
                    case 100:
                    {
                        MEAudioCourseVC *vc = [[MEAudioCourseVC alloc] initWithType:0];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 101:
                    {
                        MEAudioCourseVC *vc = [[MEAudioCourseVC alloc] initWithType:1];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 102:
                    {
                        MECourseChargeOrFreeListVC *vc = [[MECourseChargeOrFreeListVC alloc] initWithIsFree:NO];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 103:
                    {
                        MECourseChargeOrFreeListVC *vc = [[MECourseChargeOrFreeListVC alloc] initWithIsFree:YES];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
        };
    }
    return _headerView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setImage:[UIImage imageNamed:@"icon_push"] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRight.cornerRadius = 2;
        _btnRight.clipsToBounds = YES;
        _btnRight.frame = CGRectMake(0, 0, 30, 30);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
