//
//  MEStudyPlanVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEStudyPlanVC.h"
#import "MEStudiedHomeModel.h"
#import "MEPersonalCourseHeader.h"
#import "MEStudiedRecommentCell.h"
#import "MENewBCourseListCell.h"
#import "MECourseDetailVC.h"
#import "MECourseVideoListVC.h"

@interface MEStudyPlanVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) MEStudiedHomeModel *model;

@end

@implementation MEStudyPlanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;

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
    self.model = [MEStudiedHomeModel mj_objectWithKeyValues:data];
    [self.tableView reloadData];
}

#pragma mark -- Networking
//课程点赞
- (void)praiseCourseWithCourseModel:(MEStudiedCourseModel *)model {
    kMeWEAKSELF
    [MEPublicNetWorkTool postPraiseCourseWithCourseId:model.idField courseType:model.c_type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code intValue] == 200) {
            if (model.is_like == 1) {
                [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
                model.is_like = 0;
                model.class_like_num--;
            }else {
                [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
                model.is_like = 1;
                model.class_like_num++;
            }
            strongSelf.model.recomment = model;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.model.studied.count;
    }else if (section == 2) {
        return self.model.collected.count;
    }
    if (self.model.recomment.c_id == 0) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        MENewBCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewBCourseListCell class]) forIndexPath:indexPath];
        NSArray *array = kMeUnArr(self.model.studied);
        MEStudiedCourseModel *model = array[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }else if (indexPath.section == 2) {
        MENewBCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewBCourseListCell class]) forIndexPath:indexPath];
        NSArray *array = kMeUnArr(self.model.collected);
        MEStudiedCourseModel *model = array[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }
    MEStudiedRecommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEStudiedRecommentCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.model.recomment];
    kMeWEAKSELF
    cell.likeCourseBlock = ^{
        kMeSTRONGSELF
        [strongSelf praiseCourseWithCourseModel:strongSelf.model.recomment];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.model.recomment.c_id == 0) {
            return 0;
        }
        return kMEStudiedRecommentCellHeight;
    }
    return kMENewBCourseListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEPersonalCourseHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"推荐学习";
            break;
        case 1:
            title = @"学过的课程";
            break;
        case 2:
            title = @"收藏的课程";
            break;
        default:
            break;
    }
    [header setNewUIWithTitle:title];
    kMeWEAKSELF
    header.tapBlock = ^{
        kMeSTRONGSELF
        MECourseVideoListVC *vc = [[MECourseVideoListVC alloc] initWithType:section+1];
        vc.title = title;
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEStudiedCourseModel *model = nil;
    if (indexPath.section == 0) {
        model = self.model.recomment;
    }else if (indexPath.section == 1) {
        NSArray *array = kMeUnArr(self.model.studied);
        model = array[indexPath.row];
    }else if (indexPath.section == 2) {
        NSArray *array = kMeUnArr(self.model.collected);
        model = array[indexPath.row];
    }
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.c_id type:model.c_type-1];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMeStatusBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEStudiedRecommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEStudiedRecommentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewBCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewBCourseListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersonalCourseHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEPersonalCourseHeader class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonOnlineHomeStudied)];
        _refresh.delegate = self;
        _refresh.isDataInside = NO;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

@end
