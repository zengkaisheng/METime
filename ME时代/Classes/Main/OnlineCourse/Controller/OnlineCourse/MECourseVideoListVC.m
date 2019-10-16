//
//  MECourseVideoListVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseVideoListVC.h"
#import "MEOnlineCourseListModel.h"
#import "MEOnlineCourseListCell.h"
#import "MECourseDetailVC.h"

#import "MEStudiedHomeModel.h"
#import "MEStudiedRecommentCell.h"
#import "MENewBCourseListCell.h"

@interface MECourseVideoListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _categoryId;
    NSInteger _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) NSString *listType;

@end

@implementation MECourseVideoListVC

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (instancetype)initWithCategoryId:(NSInteger)categoryId listType:(NSString *)listType{
    if (self = [super init]) {
        _categoryId = categoryId;
        self.listType = listType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if (_type > 0) {
        return @{
                 @"token":kMeUnNilStr(kCurrentUser.token)
                };
    }
    if (kMeUnNilStr(self.listType).length > 0) {
        return @{@"token":kMeUnNilStr(kCurrentUser.token),
//                 @"video_type":@(_categoryId),
                 self.listType:@"1"
                 };
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"video_type":@(_categoryId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if (_type > 0) {
        [self.refresh.arrData addObjectsFromArray:[MEStudiedCourseModel mj_objectArrayWithKeyValuesArray:data]];
    }else {
        [self.refresh.arrData addObjectsFromArray:[MEOnlineCourseListModel mj_objectArrayWithKeyValuesArray:data]];
    }
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
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type > 0) {
        if (_type == 1) {
            MEStudiedRecommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEStudiedRecommentCell class]) forIndexPath:indexPath];
            MEStudiedCourseModel *model = self.refresh.arrData[indexPath.row];
            [cell setUIWithModel:model];
            kMeWEAKSELF
            cell.likeCourseBlock = ^{
                kMeSTRONGSELF
                [strongSelf praiseCourseWithCourseModel:model];
            };
            return cell;
        }else {
            MENewBCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewBCourseListCell class]) forIndexPath:indexPath];
            MEStudiedCourseModel *model = self.refresh.arrData[indexPath.row];
            [cell setUIWithModel:model];
            return cell;
        }
    }
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
    MEOnlineCourseListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model isHomeVC:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type > 0) {
        if (_type == 1) {
            return kMEStudiedRecommentCellHeight;
        }else {
            return kMENewBCourseListCellHeight;
        }
    }
    return kMEOnlineCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type > 0) {
        MEStudiedCourseModel *model = self.refresh.arrData[indexPath.row];
        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:model.c_type-1];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        MEOnlineCourseListModel *model = self.refresh.arrData[indexPath.row];
        MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:0];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineCourseListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEStudiedRecommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEStudiedRecommentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewBCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewBCourseListCell class])];
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
        NSString *url = kGetApiWithUrl(MEIPcommonVideoList);
        if (_type == 1) {
            url = kGetApiWithUrl(MEIPcommonHomeRecommentStudyList);
        }else if (_type == 2) {
            url = kGetApiWithUrl(MEIPcommonHomeStudiedList);
        }else if (_type == 3) {
            url = kGetApiWithUrl(MEIPcommonHomeCollectedList);
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:url];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关课程";
        }];
    }
    return _refresh;
}

@end
