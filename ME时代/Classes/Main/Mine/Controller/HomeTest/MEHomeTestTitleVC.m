//
//  MEHomeTestTitleVC.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeTestTitleVC.h"
#import "MEHomeTestTitleModel.h"
#import "MEHomeTestTitleCell.h"
#import "MEHomeAddTestDecVC.h"

@interface MEHomeTestTitleVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MEHomeTestTitleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _isplatform?@"平台测试题库":@"历史测试题库";
    self.view.backgroundColor = kMEf6f6f6;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEHomeTestTitleModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeTestTitleModel *model = self.refresh.arrData[indexPath.row];
    MEHomeTestTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeTestTitleCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    cell.btnDel.hidden = _isplatform;
    kMeWEAKSELF
    cell.delBlock = ^{
        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除吗?"];
        [aler addButtonWithTitle:@"确定" block:^{
            [MEPublicNetWorkTool postgetbankdelBankWithId:kMeUnNilStr(model.idField) SuccessBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                [strongSelf.refresh reload];
            } failure:nil];
        }];
        [aler addButtonWithTitle:@"取消"];
        [aler show];
    };
    cell.shareBlock = ^{
        kMeSTRONGSELF
        [strongSelf toShareWithModel:model];
    };
    return cell;
}

- (void)toShareWithModel:(MEHomeTestTitleModel *)model{
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    
#ifdef TestVersion
    NSString *shareIP = [NSString stringWithFormat:@"https://develop.meshidai.com/meAuth.html?entrance=start&bank_id=%@&uid=%@&inviteCode=%@",kMeUnNilStr(model.idField),kMeUnNilStr(kCurrentUser.uid),[kMeUnNilStr(kCurrentUser.invitation_code) length]>0?kMeUnNilStr(kCurrentUser.invitation_code):@" "];
#else
      NSString *shareIP = [NSString stringWithFormat:@"https://msd.meshidai.com/meAuth.html?entrance=start&bank_id=%@&uid=%@&inviteCode=%@",kMeUnNilStr(model.idField),kMeUnNilStr(kCurrentUser.uid),[kMeUnNilStr(kCurrentUser.invitation_code) length]>0?kMeUnNilStr(kCurrentUser.invitation_code):@" "];
#endif

    shareTool.sharWebpageUrl = shareIP;
    //    [NSString stringWithFormat:@"%@%@",SSIPArticelShare,@(_detailModel.article_id).description];
    shareTool.shareTitle = kMeUnNilStr(model.title);
    shareTool.shareDescriptionBody = kMeUnNilStr(model.desc);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:kMeUnNilStr(model.image_url)]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    shareTool.shareImage = [cache imageFromDiskCacheForKey:key];
    [shareTool showShareView:kShareWebPageContentType success:^(id data) {
        NSLog(@"分享成功%@",data);
    } failure:^(NSError *error) {
        NSLog(@"分享失败");
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeTestTitleModel *model = self.refresh.arrData[indexPath.row];
    return [MEHomeTestTitleCell getCellheightWithMolde:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeTestTitleModel *model = self.refresh.arrData[indexPath.row];
    if(_isplatform){
        MEHomeAddTestDecVC *vc = [[MEHomeAddTestDecVC alloc]init];
        vc.type = MEHomeAddTestDecTypelplatVC;
        vc.bank_id = kMeUnNilStr(model.idField);
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MEHomeAddTestDecVC *vc = [[MEHomeAddTestDecVC alloc]init];
        vc.type = MEHomeAddTestDecTypeeditVC;
        vc.bank_id = kMeUnNilStr(model.idField);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeTestTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeTestTitleCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEf6f6f6;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        NSString *str = _isplatform?MEIPcommonbankplatformTest:MEIPcommonbankhistoryTest;
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(str)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有测试题";
        }];
    }
    return _refresh;
}


@end
