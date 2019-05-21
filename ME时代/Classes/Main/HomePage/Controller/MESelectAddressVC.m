//
//  MESelectAddressVC.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESelectAddressVC.h"
#import "MEMyAddressCell.h"
#import "MENewAddressVC.h"
#import "MEAddressModel.h"

#define kbtnFrame CGRectMake(-15, 0, 75, 25)
@interface MESelectAddressVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MESelectAddressVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kMEHexColor(@"eeeeee");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    self.navigationItem.title = @"我的收货地址";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEAddressModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyAddressCell class]) forIndexPath:indexPath];
    MEAddressModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model isSelect:model.is_default == 1];
    kMeWEAKSELF
    cell.editBlock = ^{
        kMeSTRONGSELF
        MENewAddressVC *vc = [[MENewAddressVC alloc]initWithModel:model];
        vc.reloadBlock = ^{
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [strongSelf.refresh reload];
        };
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEMyAddressCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAddressModel *model = self.refresh.arrData[indexPath.row];
    kMeCallBlock(_selectModelBlock,model);
}

- (void)addAddress:(UIButton *)btn{
    MENewAddressVC *vc = [[MENewAddressVC alloc]init];
    kMeWEAKSELF
    vc.reloadBlock = ^{
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyAddressCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setTitle:@"添加新地址" forState:UIControlStateNormal];
        [_btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
        _btnRight.titleLabel.font = kMeFont(14);
        _btnRight.frame = kbtnFrame;
        [_btnRight addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonAddressAddressList)];
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有地址";
        }];
    }
    return _refresh;
}


@end
