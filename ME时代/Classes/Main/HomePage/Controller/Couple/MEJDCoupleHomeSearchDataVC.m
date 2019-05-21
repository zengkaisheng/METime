//
//  MEJDCoupleHomeSearchDataVC.m
//  ME时代
//
//  Created by hank on 2019/5/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEJDCoupleHomeSearchDataVC.h"
#import "MEJDCoupleModel.h"
#import "MEJDCoupleHomeMainGoodGoodsCell.h"
#import "MEJDCoupleMailDetalVC.h"

@interface MEJDCoupleHomeSearchDataVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_queryStr;
    NSMutableArray *_arrData;
    NSInteger _pageIndex;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;


@end

@implementation MEJDCoupleHomeSearchDataVC

- (instancetype)initWithQuery:(NSString *)query{
    if(self = [super init]){
        _queryStr = kMeUnNilStr(query);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _queryStr;
    _arrData = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headrefresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerfresh)];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)headrefresh{
    _pageIndex = 1;
    [self requestNetWorkIsHead:YES];
}

- (void)footerfresh{
    ++ _pageIndex;
    [self requestNetWorkIsHead:NO];
}

- (void)reload{
    [ZLFailLoadView removeFromView:self.tableView];
    if (self.tableView.mj_header) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        _pageIndex = 1;
        [_arrData removeAllObjects];
        [self requestNetWorkIsHead:YES];
    }
}

- (void)requestNetWorkIsHead:(BOOL)isHead{
    [ZLFailLoadView removeFromView:self.tableView];
    NSDictionary *dic = @{@"keyword":_queryStr,
                          @"pageSize":@"20",
                          @"page":@(_pageIndex)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonjingdonggoodsgoodsQuery);
    
    kMeWEAKSELF
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSArray class]]){
            if (strongSelf->_pageIndex == 1) {
                [strongSelf->_arrData removeAllObjects];
            }
            NSArray *dicArr = responseObject.data ;
            [strongSelf->_arrData addObjectsFromArray:[MEJDCoupleModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
            [strongSelf.tableView reloadData];
            [strongSelf endRefreshIsHead:isHead count:dicArr.count];
            [strongSelf showFailLoadViewWithResponse:responseObject];
            if (strongSelf->_arrData.count > 0) strongSelf.tableView.mj_footer.hidden = NO;
        }
    } failure:^(id error) {
        kMeSTRONGSELF
        [strongSelf endRefreshIsHead:isHead count:1];
        [strongSelf.tableView reloadData];
        [strongSelf showFailLoadViewWithResponse:error];
        strongSelf.tableView.mj_footer.hidden = !(strongSelf->_arrData.count > 0);
    }];
}

- (void)showFailLoadViewWithResponse:(id)response{
    kMeWEAKSELF
    [ZLFailLoadView showInView:self.tableView response:response allData:_arrData refreshBlock:^{
        kMeSTRONGSELF
        [strongSelf reload];
    } editHandle:^(ZLFailLoadView *failView) {
        failView.backgroundColor = [UIColor clearColor];
        failView.lblOfNodata.text = @"未搜索到您需要的产品";
    }];
}

- (void)endRefreshIsHead:(BOOL)isHead count:(NSInteger)count{
    if (isHead) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    if (count==0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEJDCoupleHomeMainGoodGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEJDCoupleHomeMainGoodGoodsCell class]) forIndexPath:indexPath];
    [cell setUIWithArr:_arrData];
    kMeWEAKSELF
    cell.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        MEJDCoupleModel *model = strongSelf->_arrData[index];
        MEJDCoupleMailDetalVC *vc = [[MEJDCoupleMailDetalVC alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MEJDCoupleHomeMainGoodGoodsCell getCellHeightWithArr:_arrData];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEJDCoupleHomeMainGoodGoodsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEJDCoupleHomeMainGoodGoodsCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEf5f4f4;
    }
    return _tableView;
}
@end
