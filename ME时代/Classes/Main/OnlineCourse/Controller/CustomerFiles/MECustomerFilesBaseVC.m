//
//  MECustomerFilesBaseVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerFilesBaseVC.h"
#import "MECustomerFileListModel.h"
#import "MECustomerServiceListCell.h"
#import "MECustomerDetailVC.h"

@interface MECustomerFilesBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSArray *_arrDicParm;
}
@property (nonatomic, assign) NSInteger classifyId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MECustomerFilesBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId  materialArray:(NSArray *)materialArray{
    if (self = [super init]) {
        _classifyId = classifyId;
        _arrDicParm = [materialArray copy];
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
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"classify_id":@(self.classifyId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECustomerFileListModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)reloadDatas {
    [self.refresh reload];
}

#pragma mark -- Networking
- (void)deleteCustomerFileWithFileId:(NSInteger)fileId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCustomerInformationWithCustomerId:fileId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"删除成功" view:kMeCurrentWindow];
        [strongSelf.refresh reload];
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerServiceListCell class]) forIndexPath:indexPath];
    MECustomerFileListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.tapBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 0) {//删除
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf deleteCustomerFileWithFileId:model.customer_files_id];
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定要删除 %@ 吗？",kMeUnNilStr(model.name)] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            [strongSelf presentViewController:alertController animated:YES completion:nil];
        }else if (index == 1) {//查看
             MECustomerDetailVC *vc = [[MECustomerDetailVC alloc] initWithCustomerId:model.idField];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMECustomerServiceListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerFileListModel *model = self.refresh.arrData[indexPath.row];
    MECustomerDetailVC *vc = [[MECustomerDetailVC alloc] initWithCustomerId:model.idField];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-(_arrDicParm.count<2?0.1:kCategoryViewHeight)) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerServiceListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerServiceListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerFilesList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关档案";
        }];
    }
    return _refresh;
}

@end
