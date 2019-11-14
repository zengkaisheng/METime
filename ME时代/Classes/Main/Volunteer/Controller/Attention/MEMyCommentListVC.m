//
//  MEMyCommentListVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyCommentListVC.h"
#import "MERecruitDetailModel.h"
#import "MEVolunteerCommentCell.h"

#import "MERecruitDetailVC.h"
#import "MEPublicShowDetailVC.h"

@interface MEMyCommentListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MEMyCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MERecruitCommentModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEVolunteerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVolunteerCommentCell class]) forIndexPath:indexPath];
    MERecruitCommentModel *model = self.refresh.arrData[indexPath.row];
    model.header_pic = kMeUnNilStr(kCurrentUser.header_pic);
    model.name = kMeUnNilStr(kCurrentUser.name);
    kMeWEAKSELF
    cell.answerBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if ([str isEqualToString:@"删除"]) {
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除该评论?"];
            kMeWEAKSELF
            [aler addButtonWithTitle:@"删除" block:^{
                kMeSTRONGSELF
                [MEPublicNetWorkTool postDeleteCommentWithCommentId:[NSString stringWithFormat:@"%@",@(model.idField)] successBlock:^(ZLRequestResponse *responseObject) {
                    if ([responseObject.status_code integerValue] == 200) {
                        [MECommonTool showMessage:@"删除成功" view:kMeCurrentWindow];
                        [strongSelf.refresh.arrData removeObjectAtIndex:indexPath.row];
                        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                        [strongSelf.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } failure:^(id object) {
                    
                }];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        }else if ([str isEqualToString:@"详情"]) {
            if (model.type == 1) {
                MERecruitDetailVC *vc = [[MERecruitDetailVC alloc] initWithRecruitId:model.activity_id];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }else if (model.type == 2) {
                MEPublicShowDetailVC *vc = [[MEPublicShowDetailVC alloc] initWithShowId:model.activity_id];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    };
    [cell setSelfCommentUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MERecruitCommentModel *model = self.refresh.arrData[indexPath.row];
    return model.contentHeight+35;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVolunteerCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVolunteerCommentCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonUserMyComment)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关评论";
        }];
    }
    return _refresh;
}

@end
