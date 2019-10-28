//
//  MEPublicShowDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowDetailVC.h"
#import "MEPublicShowDetailModel.h"
#import "MEPublicShowContentCell.h"

@interface MEPublicShowDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger showId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEPublicShowDetailModel *model;

@end

@implementation MEPublicShowDetailVC

- (instancetype)initWithShowId:(NSInteger)showId {
    if (self = [super init]) {
        _showId = showId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公益秀";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self requestPublicShowDetailWithNetWork];
}

#pragma mark -- Networking
//公益秀详情
- (void)requestPublicShowDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetPublicShowDetailWithShowId:_showId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEPublicShowDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

//点赞/取消点赞
- (void)praiseShowDetail{
    [MEPublicNetWorkTool postPraiseShowWithShowId:self.model.idField status:self.model.is_praise==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            if (strongSelf.model.is_praise == 0) {
                [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
                strongSelf.model.is_praise = 1;
            }else {
                [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
                strongSelf.model.is_praise = 0;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            kMeCallBlock(self.praiseBlock,strongSelf.model.is_praise);
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEPublicShowContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPublicShowContentCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.model];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        [strongSelf praiseShowDetail];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MEPublicShowContentCell getCellHeightithModel:self.model];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPublicShowContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPublicShowContentCell class])];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end
