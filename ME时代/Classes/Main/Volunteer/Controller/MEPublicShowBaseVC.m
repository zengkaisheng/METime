//
//  MEPublicShowBaseVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowBaseVC.h"
#import "MECommunityServericeListModel.h"
#import "MECommunityServiceListCell.h"
#import "MECommunityServiceCell.h"
#import "MEPublicShowDetailVC.h"
#import "MERegisteVolunteerVC.h"

@interface MEPublicShowBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, assign) NSInteger classifyId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, assign) CGFloat categoryHeight;

@end

@implementation MEPublicShowBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId categoryHeight:(CGFloat)categoryHeight{
    if (self = [super init]) {
        _classifyId = classifyId;
        self.categoryHeight = categoryHeight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = self.isHome;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"classify_id":@(self.classifyId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECommunityServericeListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- Networking
//点赞/取消点赞
- (void)praiseShowWithShowModel:(MECommunityServericeListModel *)model finishBlock:(kMeBasicBlock)finishBlock{

    [MEPublicNetWorkTool postPraiseShowWithShowId:model.idField status:model.is_praise==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        if ([responseObject.status_code integerValue] == 200) {
            if (model.is_praise == 0) {
                [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
                model.is_praise = 1;
                model.praise_num++;
            }else {
                [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
                model.is_praise = 0;
                model.praise_num--;
            }
            kMeCallBlock(finishBlock);
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommunityServericeListModel *model = self.refresh.arrData[indexPath.row];
    if (kMeUnArr(model.images).count > 1) {
        MECommunityServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECommunityServiceListCell class]) forIndexPath:indexPath];
        [cell setShowUIWithModel:model];
        kMeWEAKSELF
        cell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            switch (index) {
                case 0:
                {
                    [strongSelf praiseShowWithShowModel:model finishBlock:^{
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }
                    break;
                case 1:
                    //评论
                    break;
                default:
                    break;
            }
        };
        return cell;
    }
    MECommunityServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECommunityServiceCell class]) forIndexPath:indexPath];
    [cell setShowUIWithModel:model];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        switch (index) {
            case 0:
            {
                [strongSelf praiseShowWithShowModel:model finishBlock:^{
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
                break;
            case 1:
                //评论
                break;
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommunityServericeListModel *model = self.refresh.arrData[indexPath.row];
    if (kMeUnArr(model.images).count > 1) {
        return kMECommunityServiceListCellHeight-18;
    }
    return kMECommunityServiceCellHeight+31;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kCurrentUser.is_volunteer == 1) {
        MECommunityServericeListModel *model = self.refresh.arrData[indexPath.row];
        MEPublicShowDetailVC *vc = [[MEPublicShowDetailVC alloc] initWithShowId:model.idField];
        kMeWEAKSELF
        vc.praiseBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            model.is_praise = index;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-self.categoryHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommunityServiceListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECommunityServiceListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommunityServiceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECommunityServiceCell class])];
        
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonUsefulactivityGetList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关公益秀";
        }];
    }
    return _refresh;
}

@end
