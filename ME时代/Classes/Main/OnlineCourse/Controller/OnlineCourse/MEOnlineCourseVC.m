//
//  MEOnlineCourseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseVC.h"
#import "MEOnlineCourseHeaderView.h"
#import "MENewOnlineCourseHeaderView.h"
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

#import "MEOperateVC.h"
#import "MECustomerFilesVC.h"
#import "MECustomerServiceVC.h"
#import "MECustomerConsumeVC.h"
#import "MECustomerAppointmentVC.h"

@interface MEOnlineCourseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) MENewOnlineCourseHeaderView *headerNewView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) MEOnlineCourseHomeModel *model;

@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MEOnlineCourseVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //黑色
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"在线课程";
    self.tableView.tableHeaderView = self.headerNewView;
//    [self.headerView setUIWithArray:@[] type:0];
    [self.headerNewView setUIWithArray:@[]];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}

- (void)userLogin{
    [self.refresh reload];
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
    BOOL hasSection = NO;
    for (MECourseHomeMenuListModel *model in self.model.menu_list) {
        if (model.idField == 1) {
            hasSection = YES;
        }
    }
    if (hasSection) {
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView setUIWithArray:self.model.top_banner type:0];
    }else {
        self.tableView.tableHeaderView = self.headerNewView;
        [self.headerNewView setUIWithArray:self.model.top_banner];
    }
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
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 2) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            MEOnlineConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineConsultCell class]) forIndexPath:indexPath];
            [cell setUIWithDict:@{@"title":@"免费诊断店铺问题"}];
            return cell;
        }
        return [UITableViewCell new];
    }else if (indexPath.section == 1) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 4) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            MEOnlineConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineConsultCell class]) forIndexPath:indexPath];
            [cell setUIWithDict:@{@"title":@"定制店铺专属方案"}];
            return cell;
        }
        return [UITableViewCell new];
    }else if (indexPath.section == 2) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 3) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            MEOnlineToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineToolsCell class]) forIndexPath:indexPath];
            [cell setUIWithHiddenRunData:NO];
            kMeWEAKSELF
            cell.selectedBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                switch (index) {
                    case 1:
                    {
                        MEOperateVC *operationVC = [[MEOperateVC alloc] init];
                        operationVC.isShowTop = YES;
                        [strongSelf.navigationController pushViewController:operationVC animated:YES];
                    }
                        break;
                    case 2:
                    {
                        MECustomerFilesVC *filesVC = [[MECustomerFilesVC alloc] init];
                        [strongSelf.navigationController pushViewController:filesVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        MECustomerServiceVC *serviceVC = [[MECustomerServiceVC alloc] init];
                        [strongSelf.navigationController pushViewController:serviceVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        MECustomerAppointmentVC *appointmentVC = [[MECustomerAppointmentVC alloc] init];
                        [strongSelf.navigationController pushViewController:appointmentVC animated:YES];
                    }
                        break;
                    case 5:
                    {
                        MECustomerConsumeVC *vc = [[MECustomerConsumeVC alloc] init];
                        [strongSelf.navigationController pushViewController:vc
                                                                   animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            };
            return cell;
        }
        return [UITableViewCell new];
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
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 2) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return kMEOnlineConsultCellHeight;
        }
        return 0;
    }else if (indexPath.section == 1) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 4) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 93;
        }
        return 0;
    }else if (indexPath.section == 2) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 3) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return kMEOnlineToolsCellHeight;
        }
        return 0;
    }
    if (kMeUnArr(self.model.onLine_banner).count <= 0 && kMeUnArr(self.model.video_list.data).count <= 0) {
        return 0;
    }
    
    BOOL hasSection = NO;
    for (MECourseHomeMenuListModel *model in self.model.menu_list) {
        if (model.idField == 5) {
            hasSection = YES;
        }
    }
    if (hasSection) {
        CGFloat height = 41.0+18.0;
        if (kMeUnArr(self.model.onLine_banner).count > 0) {
            height += 120;
        }
        if (kMeUnArr(self.model.category).count > 0) {
            for (MECourseHomeCategoryModel *categoryModel in self.model.category) {
                if (kMeUnArr(categoryModel.video_list).count > 0) {
                    height += 43;
                }
                height += 89*kMeUnArr(categoryModel.video_list).count;
            }
        }
        return height;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }
    if (section == 0) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 2) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 41;
        }
        return 0;
    }else if (section == 1) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 4) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 41;
        }
        return 0;
    }else if (section == 2) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 3) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 41;
        }
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
            titleLbl.text = @"定制方案";
            break;
        case 2:
            titleLbl.text = @"运营工具";
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
    } else if (indexPath.section == 1) {
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

- (MENewOnlineCourseHeaderView *)headerNewView {
    if(!_headerNewView){
        _headerNewView = [[[NSBundle mainBundle]loadNibNamed:@"MENewOnlineCourseHeaderView" owner:nil options:nil] lastObject];
        _headerNewView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMENewOnlineCourseHeaderViewHeight);
        kMeWEAKSELF
        _headerNewView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (index < 100) {
                MEAdModel *model = strongSelf.model.top_banner[index];
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            }
        };
    }
    return _headerNewView;
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
