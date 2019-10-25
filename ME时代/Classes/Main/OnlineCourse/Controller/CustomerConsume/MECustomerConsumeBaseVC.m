//
//  MECustomerConsumeBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerConsumeBaseVC.h"
#import "MECustomerFileListModel.h"
#import "MECustomerServiceListCell.h"
#import "MECustomerConsumeDetailVC.h"

@interface MECustomerConsumeBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSArray *_arrDicParm;
}

@property (nonatomic, assign) NSInteger classifyId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MECustomerConsumeBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId materialArray:(NSArray *)materialArray {
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
             @"customer_classify_id":@(self.classifyId)
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
- (void)deleteCustomerServiceWithServiceId:(NSInteger)serviceId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postDeleteCustomerServiceWithServiceId:serviceId successBlock:^(ZLRequestResponse *responseObject) {
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
                [strongSelf deleteCustomerServiceWithServiceId:model.customer_files_id];
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定要删除 %@ 吗？",kMeUnNilStr(model.name)] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            [strongSelf presentViewController:alertController animated:YES completion:nil];
        }else if (index == 1) {//查看
            MECustomerConsumeDetailVC *vc = [[MECustomerConsumeDetailVC alloc] initWithFilesId:model.customer_files_id];
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
    MECustomerConsumeDetailVC *vc = [[MECustomerConsumeDetailVC alloc] initWithFilesId:model.customer_files_id];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerExpenseList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无消费记录";
        }];
    }
    return _refresh;
}

@end
