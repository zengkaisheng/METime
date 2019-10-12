//
//  MENewOnlineCourseVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewOnlineCourseVC.h"
#import "MEOnlineCourseHeaderView.h"
#import "MENewOnlineCourseHeaderView.h"
#import "MEAdModel.h"

#import "MEAudioCourseVC.h"
#import "MEOnlineCourseHomeModel.h"
#import "MEOnlineCourseListModel.h"
#import "MECourseDetailVC.h"
#import "MECourseChargeOrFreeListVC.h"
#import "MEOnlineCourseVC.h"
#import "MECourseVideoListVC.h"
#import "MECourseAudioListVC.h"

#import "MERecommendCourseCell.h"
#import "MENewCourseCell.h"
#import "MECourseAdvertisementCell.h"
#import "MEFineCourseCell.h"
#import "MENewCourseListCell.h"
#import "MEPersonalCourseHeader.h"

@interface MENewOnlineCourseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) MENewOnlineCourseHeaderView *headerNewView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) MEOnlineCourseHomeModel *model;

@end

@implementation MENewOnlineCourseVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.tableView.tableHeaderView = self.headerNewView;
    [self.headerNewView setUIWithArray:@[]];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
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
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else if (section == 2) {
        return self.model.j_goods.count;
    }
    return self.model.b_audio.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 17) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            MERecommendCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecommendCourseCell class]) forIndexPath:indexPath];
            [cell setUIWithArray:self.model.recommend];
            kMeWEAKSELF
            cell.indexBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                if (index == 0) {
//                    NSLog(@"点击了左边课程");
                    MEOnlineCourseListModel *model = strongSelf.model.recommend[0];
                    NSInteger type = 0;
                    if (kMeUnNilStr(model.audio_name).length > 0) {
                        type = 1;
                    }
                    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:type];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else if (index == 1) {
                    MEOnlineCourseListModel *model = strongSelf.model.recommend[1];
//                    NSLog(@"点击了右边课程");
                    NSInteger type = 0;
                    if (kMeUnNilStr(model.audio_name).length > 0) {
                        type = 1;
                    }
                    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:type];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            return cell;
        }
        return [UITableViewCell new];
    }else if (indexPath.section == 1) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 18) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            if (indexPath.row == 0) {
                MENewCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewCourseCell class]) forIndexPath:indexPath];
                [cell setUIWithArray:self.model.courseNew];
                kMeWEAKSELF
                cell.indexBlock = ^(NSInteger index) {
                    kMeSTRONGSELF
                    if (index == 0) {
//                        NSLog(@"点击了左边课程");
                        MEOnlineCourseListModel *model = strongSelf.model.courseNew[0];
                        NSInteger type = 0;
                        if (kMeUnNilStr(model.audio_name).length > 0) {
                            type = 1;
                        }
                        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:type];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }else if (index == 1) {
//                        NSLog(@"点击了上边课程");
                        MEOnlineCourseListModel *model = strongSelf.model.courseNew[1];
                        NSInteger type = 0;
                        if (kMeUnNilStr(model.audio_name).length > 0) {
                            type = 1;
                        }
                        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:type];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }else if (index == 2) {
//                        NSLog(@"点击了下边课程");
                        MEOnlineCourseListModel *model = strongSelf.model.courseNew[2];
                        NSInteger type = 0;
                        if (kMeUnNilStr(model.audio_name).length > 0) {
                            type = 1;
                        }
                        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:type];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                };
                return cell;
            }
            MECourseAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECourseAdvertisementCell class]) forIndexPath:indexPath];
            [cell setNewCourseUIWithArray:self.model.onLine_banner];
            kMeWEAKSELF
            cell.selectedBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                MEAdModel *model = strongSelf.model.onLine_banner[index];
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            };
            return cell;
        }
        return [UITableViewCell new];
    }else if (indexPath.section == 2) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 19) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            MEFineCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFineCourseCell class]) forIndexPath:indexPath];
            MEOnlineCourseListModel *model = self.model.j_goods[indexPath.row];
            [cell setUIWithModel:model];
            return cell;
        }
        return [UITableViewCell new];
    }
    
    BOOL hasSection = NO;
    for (MECourseHomeMenuListModel *model in self.model.menu_list) {
        if (model.idField == 20) {
            hasSection = YES;
        }
    }
    if (hasSection) {
        MENewCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewCourseListCell class]) forIndexPath:indexPath];
        MEOnlineCourseListModel *model = self.model.b_audio[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 17) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return kMERecommendCourseCellHeight;
        }
        return 0;
    }else if (indexPath.section == 1) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 18) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            if (indexPath.row == 0) {
                return kMENewCourseCellHeight;
            }else if (indexPath.row == 1) {
                if (self.model.onLine_banner.count > 0) {
                    return 141;
                }else {
                    return 0;
                }
            }
        }
        return 0;
    }else if (indexPath.section == 2) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 19) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return kMEFineCourseCellHeight;
        }
        return 0;
    }
    
    BOOL hasSection = NO;
    for (MECourseHomeMenuListModel *model in self.model.menu_list) {
        if (model.idField == 20) {
            hasSection = YES;
        }
    }
    if (hasSection) {
        return kMENewCourseListCellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 17) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 43;
        }
        return 0;
    }else if (section == 1) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 18) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 43;
        }
        return 0;
    }else if (section == 2) {
        BOOL hasSection = NO;
        for (MECourseHomeMenuListModel *model in self.model.menu_list) {
            if (model.idField == 19) {
                hasSection = YES;
            }
        }
        if (hasSection) {
            return 43;
        }
        return 0;
    }
    BOOL hasSection = NO;
    for (MECourseHomeMenuListModel *model in self.model.menu_list) {
        if (model.idField == 20) {
            hasSection = YES;
        }
    }
    if (hasSection) {
        return 43;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEPersonalCourseHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
    MECourseHomeMenuListModel *menuModel = self.model.menu_list[section+5];
    [header setNewUIWithTitle:kMeUnNilStr(menuModel.menu_name)];
    header.backgroundColor = [UIColor whiteColor];
    kMeWEAKSELF
    header.tapBlock = ^{
        kMeSTRONGSELF
        MENewOnlineCourseVC *homevc = (MENewOnlineCourseVC *)[MECommonTool getVCWithClassWtihClassName:[MENewOnlineCourseVC class] targetResponderView:strongSelf];
        if (menuModel.idField == 20) {
            MECourseAudioListVC *vc = [[MECourseAudioListVC alloc] initWithCategoryId:menuModel.idField listType:@"is_will"];
            vc.title = kMeUnNilStr(menuModel.menu_name);
            if (homevc) {
                [homevc.navigationController pushViewController:vc animated:YES];
            }
        }else {
            NSString *type = @"";
            if (menuModel.idField == 17) {
                type = @"day_recommend";
            }else if (menuModel.idField == 18) {
                type = @"is_new";
            }else if (menuModel.idField == 19) {
                type = @"is_goods";
            }
            MECourseVideoListVC *vc = [[MECourseVideoListVC alloc] initWithCategoryId:menuModel.idField listType:type];
            vc.title = kMeUnNilStr(menuModel.menu_name);
            if (homevc) {
                [homevc.navigationController pushViewController:vc animated:YES];
            }
        }
    };
    return header;
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
    if (indexPath.section == 2) {
        MEOnlineCourseListModel *model = self.model.j_goods[indexPath.row];
        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:0];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3) {
        MEOnlineCourseListModel *model = self.model.b_audio[indexPath.row];
        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeStatusBarHeight-20, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-(kMeStatusBarHeight-20)) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecommendCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecommendCourseCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewCourseCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECourseAdvertisementCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECourseAdvertisementCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFineCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEFineCourseCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewCourseListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
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

@end
