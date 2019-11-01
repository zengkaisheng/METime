//
//  MECareerBaseVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECareerBaseVC.h"
#import "MENewOnlineCourseHeaderView.h"
#import "MEStudiedRecommentCell.h"
#import "MECareerCourseListModel.h"
#import "MECourseDetailVC.h"

@interface MECareerBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSArray * categorys;

@end

@implementation MECareerBaseVC

- (instancetype)initWithCategoryId:(NSInteger)categoryId  categorys:(NSArray *)categorys{
    if (self = [super init]) {
        self.categoryId = categoryId;
        self.categorys = [categorys copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"c_id":@(self.categoryId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECareerCourseListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- Networking
//课程点赞
- (void)praiseCourseWithCourseModel:(MECareerCourseListModel *)model {
    kMeWEAKSELF
    [MEPublicNetWorkTool postPraiseCourseWithCourseId:model.a_id courseType:model.type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code intValue] == 200) {
            if (model.is_like == 1) {
                [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
                model.is_like = 0;
                model.like--;
            }else {
                [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
                model.is_like = 1;
                model.like++;
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
    MEStudiedRecommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEStudiedRecommentCell class]) forIndexPath:indexPath];
    MECareerCourseListModel *model = self.refresh.arrData[indexPath.row];
    [cell setCareerUIWithModel:model];
    kMeWEAKSELF
    cell.likeCourseBlock = ^{
        kMeSTRONGSELF
        [strongSelf praiseCourseWithCourseModel:model];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEStudiedRecommentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECareerCourseListModel *model = self.refresh.arrData[indexPath.row];
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.a_id type:model.type-1];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        CGFloat categoryViewHeight = kCategoryViewHeight;
        if (self.categorys.count < 2) {
            categoryViewHeight = 0.1;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- kMENewOnlineCourseHeaderViewHeight - categoryViewHeight - kMeTabBarHeight-(kMeStatusBarHeight-20)) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEStudiedRecommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEStudiedRecommentCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonOnlineGetLists)];
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
