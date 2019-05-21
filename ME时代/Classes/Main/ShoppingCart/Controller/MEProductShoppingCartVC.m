//
//  MEProductShoppingCartVC.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEProductShoppingCartVC.h"
#import "MEShoppingCartModel.h"
#import "MEShopppingCartBottomView.h"
#import "MEShoppingCartCell.h"
#import "MEShoppingCartGoodsVC.h"
#import "MEShopCartMakeOrderVC.h"
//#import "MELoginVC.h"

@interface MEProductShoppingCartVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>

/**
 选中的数组
 */
@property (nonatomic, copy) NSMutableArray *arrSelect;
//@property (nonatomic, strong) NSMutableArray<MEGoodsModel *> *arrStore;//商品
@property (nonatomic, strong) MEShopppingCartBottomView *bottomView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
//@property (nonatomic, strong) MELoginVC *loginVC;
@end

@implementation MEProductShoppingCartVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![MEUserInfoModel isLogin]){
//        [self.view addSubview:self.loginVC.view];
    }else{
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.bottomView];
        [self.refresh addRefreshView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kMEShopppingCartBottomViewHeight));
            make.width.equalTo(@(SCREEN_WIDTH));
            make.top.equalTo(@(SCREEN_HEIGHT-kMEShopppingCartBottomViewHeight-kMeTabBarHeight));
        }];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
    kShopCartReload
}

- (void)userLogout{
//    [self.view addSubview:self.loginVC.view];
    [self.navigationController popToViewController:self animated:NO];
    [self.refresh.arrData removeAllObjects];
    [self.tableView reloadData];
    self.refresh = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.bottomView removeFromSuperview];
    self.bottomView  = nil;
}

- (void)userLogin{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.refresh addRefreshView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kMEShopppingCartBottomViewHeight));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(@(SCREEN_HEIGHT-kMEShopppingCartBottomViewHeight-kMeTabBarHeight));
    }];
//    [self.loginVC.view removeFromSuperview];
//    self.loginVC = nil;
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    [self.arrSelect removeAllObjects];;
    [self.bottomView clearData];
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"product_type":@(1),
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEShoppingCartModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEShoppingCartCell class])];
    //MEStoreModel *storeModel = self.arrStore[indexPath.section];
    MEShoppingCartModel *goodsModel = self.refresh.arrData[indexPath.row];
    [cell setUIWIthModel:goodsModel];
    //把事件的处理分离出去
    [self shoppingCartCellClickAction:cell goodsModel:goodsModel indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEShoppingCartCellHeight;
}

#pragma makr - public


#pragma makr - private

- (void)clickAllSelectBottomView:(MEShopppingCartBottomView *)bottomView {
    kMeWEAKSELF
    bottomView.AllClickBlock = ^(BOOL isClick) {
        kMeSTRONGSELF
        for (MEShoppingCartModel *goodsModel in strongSelf.arrSelect) {
            goodsModel.isSelect = NO;
        }
        [strongSelf.arrSelect removeAllObjects];
        if (isClick) {//选中
            NSLog(@"全选");
            for (MEShoppingCartModel *goodsModel in strongSelf.refresh.arrData) {
                goodsModel.isSelect = YES;
                [strongSelf.arrSelect addObject:goodsModel];
            }
        } else {//取消选中
            NSLog(@"取消全选");
            for (MEShoppingCartModel *goodsModel in strongSelf.refresh.arrData) {
                goodsModel.isSelect = NO;
            }
        }
        [self.tableView reloadData];;
        [strongSelf countPrice];
    };
    
    bottomView.AccountBlock = ^{
        kMeSTRONGSELF
        if(strongSelf.arrSelect.count == 0){
            kMeAlter(@"提示", @"请选择商品");
        }else{
            kMeSTRONGSELF
            MEShopCartMakeOrderVC *ovc = [[MEShopCartMakeOrderVC alloc]initWithIsinteral:NO WithArrChartGood:strongSelf.arrSelect];
            ovc.PayFinishBlock = ^{
                kMeSTRONGSELF
                [strongSelf.refresh reload];
                //            [strongSelf deleteSlectArrChach];
                //            [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            [strongSelf.navigationController pushViewController:ovc animated:YES];
        }
    };
    
    bottomView.DelBlock = ^{
        kMeSTRONGSELF
        if(strongSelf.arrSelect.count == 0){
            kMeAlter(@"提示", @"请选择商品");
        }else{
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除?"];
            [aler addButtonWithTitle:@"确定" block:^{
                [strongSelf delGoosAction];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        }
    };
}

- (void)delGoosAction{
    NSMutableArray *arrCartId = [NSMutableArray array];
    for (MEShoppingCartModel *goodsModel in self.arrSelect) {
        [arrCartId addObject:@(goodsModel.product_cart_id)];
    }
    NSString *strCartId =  [arrCartId componentsJoinedByString:@","];
    kMeWEAKSELF
    [MEPublicNetWorkTool postDelGoodForShopWithMemberId:0 productCartId:strCartId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf deleteSlectArrChach];
    } failure:^(id object) {
        
    }];
}

//删除本地选择
- (void)deleteSlectArrChach{
    for (MEGoodsModel *goodsModel in self.arrSelect) {
        [self.refresh.arrData removeObject:goodsModel];
    }
    [self.arrSelect removeAllObjects];
    [self judgeIsAllSelect];
    [self countPrice];
    [self.tableView reloadData];;
}

/**
 是否全选
 */
- (void)judgeIsAllSelect {
    NSInteger count = self.refresh.arrData.count;
    //先遍历购物车商品, 得到购物车有多少商品
    //如果购物车总商品数量 等于 选中的商品数量, 即表示全选了
    if (count == self.arrSelect.count) {
        self.bottomView.isClick = YES;
    } else {
        self.bottomView.isClick = NO;
    }
}

/**
 计算价格
 */
- (void)countPrice {
    double totlePrice = 0.0;
    for (MEShoppingCartModel *goodsModel in self.arrSelect) {
        double price = [goodsModel.money doubleValue];
        totlePrice += price * goodsModel.goods_num ;
    }
    
    _bottomView.allPriceLabel.text = [NSString stringWithFormat:@"合计 ￥%.2f", totlePrice];
}


- (void)shoppingCartCellClickAction:(MEShoppingCartCell *)cell
                         goodsModel:(MEShoppingCartModel *)goodsModel
                          indexPath:(NSIndexPath *)indexPath {
    kMeWEAKSELF
    //选中某一行
    cell.ClickRowBlock = ^(BOOL isClick) {
        kMeSTRONGSELF
        goodsModel.isSelect = isClick;
        if (isClick) {//选中
            NSLog(@"选中");
            [strongSelf.arrSelect addObject:goodsModel];
        } else {//取消选中
            NSLog(@"取消选中");
            [strongSelf.arrSelect removeObject:goodsModel];
        }
        [strongSelf judgeIsAllSelect];
        [strongSelf countPrice];
    };
    //加
    cell.AddBlock = ^(UILabel *countLabel) {
        kMeSTRONGSELF
        NSLog(@"%@", countLabel.text);
        goodsModel.goods_num = [countLabel.text integerValue];
        [strongSelf.refresh.arrData replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        if ([strongSelf.arrSelect containsObject:goodsModel]) {
            [strongSelf.arrSelect removeObject:goodsModel];
            [strongSelf.arrSelect addObject:goodsModel];
            [strongSelf countPrice];
        }
        
    };
    //减
    cell.CutBlock = ^(UILabel *countLabel) {
        kMeSTRONGSELF
        NSLog(@"%@", countLabel.text);
        goodsModel.goods_num = [countLabel.text integerValue];
        [strongSelf.refresh.arrData replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        if ([strongSelf.arrSelect containsObject:goodsModel]) {
            [strongSelf.arrSelect removeObject:goodsModel];
            [strongSelf.arrSelect addObject:goodsModel];
            [strongSelf countPrice];
        }
    };
}

#pragma mark - Setter And Getter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight-kMEShopppingCartBottomViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEShoppingCartCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEShoppingCartCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEShopppingCartBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MEShopppingCartBottomView" owner:nil options:nil] lastObject];
        [self clickAllSelectBottomView:_bottomView];
    }
    return _bottomView;
}

- (NSMutableArray *)arrSelect {
    if (!_arrSelect) {
        _arrSelect = [NSMutableArray new];
    }
    return _arrSelect;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCartCartGoodsList)];
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"购物车没有商品";
        }];
    }
    return _refresh;
}

//- (MELoginVC *)loginVC{
//    if(!_loginVC){
//        _loginVC = [[MELoginVC alloc]init];
//        _loginVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _loginVC.btnReturn.hidden = YES;
//        _loginVC.view.frame = self.view.bounds;
//        [self addChildViewController:_loginVC];
//    }
//    return _loginVC;
//}


@end
