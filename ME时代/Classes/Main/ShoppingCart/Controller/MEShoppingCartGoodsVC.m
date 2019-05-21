//
//  MEShoppingCartGoodsVC.m
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingCartGoodsVC.h"
#import "MEShoppingCartCell.h"
#import "MEShoppingCartModel.h"
#import "MEShopppingCartBottomView.h"

@interface MEShoppingCartGoodsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEShoppingCartGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    MEStoreModel *model = [MEStoreModel new];

    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

//#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    //MEStoreModel *storeModel = self.arrStore[section];
//    return self.arrStore.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MEShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MEShoppingCartCell"];
//    //MEStoreModel *storeModel = self.arrStore[indexPath.section];
//    MEGoodsModel *goodsModel = self.arrStore[indexPath.row];
//    [cell setUIWIthModel:goodsModel];
//    //把事件的处理分离出去
//    [self shoppingCartCellClickAction:cell goodsModel:goodsModel indexPath:indexPath];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kMEShoppingCartCellHeight;
//}
//
//#pragma makr - public
//
//- (void)reloadData{
//    [self.tableView reloadData];
//}
//
//#pragma makr - private
//
//- (void)shoppingCartCellClickAction:(MEShoppingCartCell *)cell
//                         goodsModel:(MEGoodsModel *)goodsModel
//                          indexPath:(NSIndexPath *)indexPath {
//    kMeWEAKSELF
//    //选中某一行
//    cell.ClickRowBlock = ^(BOOL isClick) {
//        kMeSTRONGSELF
//        goodsModel.isSelect = isClick;
//        if (isClick) {//选中
//            NSLog(@"选中");
//            [strongSelf.arrSelect addObject:goodsModel];
//        } else {//取消选中
//            NSLog(@"取消选中");
//            [strongSelf.arrSelect removeObject:goodsModel];
//        }
//        kMeCallBlock(strongSelf.judgeIsAllSelectBlock);
//        kMeCallBlock(strongSelf.countPriceBlock);
////        [strongSelf judgeIsAllSelect];
////        [strongSelf countPrice];
//    };
//    //加
//    cell.AddBlock = ^(UILabel *countLabel) {
//        kMeSTRONGSELF
//        NSLog(@"%@", countLabel.text);
//        goodsModel.count = countLabel.text;
//        [strongSelf.arrStore replaceObjectAtIndex:indexPath.row withObject:goodsModel];
//        if ([strongSelf.arrSelect containsObject:goodsModel]) {
//            [strongSelf.arrSelect removeObject:goodsModel];
//            [strongSelf.arrSelect addObject:goodsModel];
////            [strongSelf countPrice];
//            kMeCallBlock(strongSelf.countPriceBlock);
//        }
//        
//    };
//    //减
//    cell.CutBlock = ^(UILabel *countLabel) {
//        kMeSTRONGSELF
//        NSLog(@"%@", countLabel.text);
//        goodsModel.count = countLabel.text;
//        [strongSelf.arrStore replaceObjectAtIndex:indexPath.row withObject:goodsModel];
//        if ([strongSelf.arrSelect containsObject:goodsModel]) {
//            [strongSelf.arrSelect removeObject:goodsModel];
//            [strongSelf.arrSelect addObject:goodsModel];
////            [strongSelf countPrice];
//            kMeCallBlock(strongSelf.countPriceBlock);
//        }
//    };
//}

///**
// 是否全选
// */
//- (void)judgeIsAllSelect {
//    NSInteger count = 0;
//    //先遍历购物车商品, 得到购物车有多少商品
//    for (MEStoreModel *storeModel in self.arrStore) {
//        count += storeModel.goodsArray.count;
//    }
//    //如果购物车总商品数量 等于 选中的商品数量, 即表示全选了
//    if (count == self.arrSelect.count) {
//        self.bottomView.isClick = YES;
//    } else {
//        self.bottomView.isClick = NO;
//    }
//}
//
///**
// 计算价格
// */
//- (void)countPrice {
//    double totlePrice = 0.0;
//    for (MEGoodsModel *goodsModel in self.arrSelect) {
//        double price = [goodsModel.realPrice doubleValue];
//        totlePrice += price * [goodsModel.count integerValue];
//    }
//    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"合计 ￥%.2f", totlePrice];
//}

/*
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        kMeWEAKSELF
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            kMeSTRONGSELF
            //[strongSelf deleteGoodsWithIndexPath:indexPath];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
*/

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-44-kMeTabBarHeight-50) style:UITableViewStylePlain];
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
@end
