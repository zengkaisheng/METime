//
//  MEBdataVC.m
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBdataVC.h"
#import "MEBdataTopCell.h"
#import "MEBdataPieCell.h"
#import "MEBdataColumnCell.h"
#import "MEBDataDealModel.h"
#import "YBPopupMenu.h"
#import "MEBdataStoreCustomerTopCell.h"
#import "MEBdataLineCell.h"

@interface MEBdataVC ()<UITableViewDelegate, UITableViewDataSource,YBPopupMenuDelegate>{
    MEBDataDealModel *_model;
    //0 数据分析 1门店业绩结构分析 2门店顾客分析
    NSInteger _selectIndex;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEBdataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据分析";
    _selectIndex = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headrefresh)];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)selectAction:(UIButton *)btn{
    kMeWEAKSELF
    [YBPopupMenu showRelyOnView:btn titles:@[@"数据统计",@"门店业绩结构分析",@"门店顾客分析"] icons:nil menuWidth:170 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        kMeSTRONGSELF
        popupMenu.delegate = strongSelf;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if(_selectIndex == index){
        return;
    }
    _selectIndex = index;
    self.title = ybPopupMenu.titles[index];
    [self.tableView reloadData];
}

- (void)headrefresh{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetBstatisticsWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if(![responseObject.data isKindOfClass:[NSDictionary class]]){
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        strongSelf->_model = [MEBDataDealModel mj_objectWithKeyValues:responseObject.data ];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_selectIndex) {
        case 0:
           return 6;
        case 1:
            return 2;
        case 2:
            return 5;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_selectIndex == 0){
        if(indexPath.row == 0){
            MEBdataTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataTopCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:_model];
            return cell;
        }else if (indexPath.row == 1){
            MEBdataPieCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataPieCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.member.women),@(_model.member.man),@(_model.member.privary)] Xtitle:@[@"女",@"男",@"保密"] title:@"用户分析-男女比例"];
            return cell;
        }else if(indexPath.row == 2){
            MEBdataColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataColumnCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.brokerage.can_use_brokerage),@(_model.brokerage.settle_accounts_no),@(_model.brokerage.settle_accounts_ok),@(_model.brokerage.today_brokerage)] Xtitle:@[@"可使用佣金",@"未结算佣金",@"已结算佣金",@"今日产生佣金"] title:@"佣金分析" company:@"佣金"];
            return cell;
        }else if(indexPath.row == 3){
            MEBdataPieCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataPieCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.goods.women_sales),@(_model.goods.man_sales),@(_model.goods.privary_sales)] Xtitle:@[@"女",@"男",@"保密"] title:@"商品分析-男女销售比例"];
            return cell;
        }else if(indexPath.row == 4){
            MEBdataColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataColumnCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.storeProject.allProjectPercent),@(_model.storeProject.nomalProjectPercent),@(_model.storeProject.promotionProjectPercent)] Xtitle:@[@"各项目人均销售额",@"常规目人均销售额",@"促销项目人均销售额"] title:@"门店项目结构诊断" company:@"销售额"];
            return cell;
        }else if(indexPath.row == 5){
            MEBdataColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataColumnCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.business.reserveDealPercent),@(_model.business.achievementPercent)] Xtitle:@[@"预约达成率",@"业绩达成率"] title:@"达成率" company:@"达成率"];
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }else if (_selectIndex == 1){
        if(indexPath.row == 0){
            MEBdataPieCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataPieCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.storeAchievement.AchievementMember.people),@(_model.storeAchievement.AchievementMember.old),@(_model.storeAchievement.AchievementMember.active)] Xtitle:@[@"新顾客",@"顾客",@"潜在用户"] title:@"顾客业绩结构分析"];
            return cell;
        }else if (indexPath.row == 1){
            MEBdataColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataColumnCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:kMeUnArr(_model.storeAchievement.AchievementCatagery) title:@"品类业绩结构分析" company:@"数量"];
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }else if (_selectIndex == 2){
        if(indexPath.row == 0){
            MEBdataStoreCustomerTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataStoreCustomerTopCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:_model];
            return cell;
        }else if (indexPath.row == 1){
            MEBdataColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataColumnCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.storeCustomer.AccessTimesByMouth.small_software),@(_model.storeCustomer.AccessTimesByMouth.app)] Xtitle:@[@"小程序",@"APP"] title:@"顾客月均到店次数和标准值对比" company:@"对比"];
//            MEBdataPieCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataPieCell class]) forIndexPath:indexPath];
//            [cell setUiWithModel:@[@(_model.storeCustomer.AccessTimesByMouth.small_software),@(_model.storeCustomer.AccessTimesByMouth.app)] Xtitle:@[@"小程序",@"APP"] title:@"顾客月均到店次数和标准值对比"];
            return cell;
        }else if (indexPath.row == 2){
            MEBdataPieCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataPieCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:@[@(_model.storeCustomer.AccessTimes.small_software),@(_model.storeCustomer.AccessTimes.app)] Xtitle:@[@"小程序",@"APP"] title:@"按照顾客到店的次数"];
            return cell;
        }else if (indexPath.row == 3){
            MEBdataColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataColumnCell class]) forIndexPath:indexPath];
            [cell setUiGoodNumWithModel:kMeUnArr(_model.storeCustomer.GoodsNum) title:@"顾客消费购买产品数分析" company:@"数量"];
            return cell;
        }else if (indexPath.row == 4){
            MEBdataLineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBdataLineCell class]) forIndexPath:indexPath];
            //门店顾客年龄结构分析
            NSArray *arrAgeFramework = @[@(_model.storeCustomer.ageFramework.one),@(_model.storeCustomer.ageFramework.two),@(_model.storeCustomer.ageFramework.three),@(_model.storeCustomer.ageFramework.five)];
            //门店顾客各年龄消费额分析
            NSArray *arrageCost = @[@(_model.storeCustomer.ageCost.one),@(_model.storeCustomer.ageCost.two),@(_model.storeCustomer.ageCost.three),@(_model.storeCustomer.ageCost.five)];
            //门店顾客不同年龄到店次数-小程序
            NSArray *arrageAccessAge = @[@(_model.storeCustomer.ageAccess.small_software.one),@(_model.storeCustomer.ageAccess.small_software.two),@(_model.storeCustomer.ageAccess.small_software.three),@(_model.storeCustomer.ageAccess.small_software.five)];
            //门店顾客不同年龄到店次数-APP
             NSArray *arrageAccessAgeAPP = @[@(_model.storeCustomer.ageAccess.app.one),@(_model.storeCustomer.ageAccess.app.two),@(_model.storeCustomer.ageAccess.app.three),@(_model.storeCustomer.ageAccess.app.five)];
            //门店顾客不同年龄人均消费分析
            NSArray *arrageAverageCost = @[@(_model.storeCustomer.ageAverageCost.one),@(_model.storeCustomer.ageAverageCost.two),@(_model.storeCustomer.ageAverageCost.three),@(_model.storeCustomer.ageAverageCost.five)];
            //门店顾客各年龄结构分析
            NSArray *arrnewsAge =@[@(_model.storeCustomer.newsAge.one),@(_model.storeCustomer.newsAge.two),@(_model.storeCustomer.newsAge.three),@(_model.storeCustomer.newsAge.five)];
            [cell setUiWithTitleArr:@[@"门店顾客年龄结构分析",@"门店顾客各年龄消费额分析",@"门店顾客不同年龄到店次数-小程序",@"门店顾客不同年龄到店次数-APP",@"门店顾客不同年龄人均消费分析",@"门店新客年龄结构分析"] NumArr:@[arrAgeFramework,arrageCost,arrageAccessAge,arrageAccessAgeAPP,arrageAverageCost,arrnewsAge]];
            
            return cell;
        }
        else{
            return [UITableViewCell new];
        }
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_selectIndex == 0){
        if(indexPath.row == 0){
            return kMEBdataTopCellHeight;
        }else if (indexPath.row == 1){
            return kMEBdataPieCellHeight;
        }else  if(indexPath.row == 2){
            return kMEBdataColumnCellHeight;
        }else  if(indexPath.row == 3){
            return kMEBdataPieCellHeight;
        }else  if(indexPath.row == 4){
            return kMEBdataColumnCellHeight;
        }else  if(indexPath.row == 5){
            return kMEBdataColumnCellHeight;
        }else{
            return 0.1;
        }
    }else if (_selectIndex == 1){
        if(indexPath.row == 0){
            return kMEBdataPieCellHeight;
        }else if (indexPath.row == 1){
            return kMEBdataColumnCellHeight;
        }else{
            return 0.1;
        }
    }else if (_selectIndex == 2){
        if(indexPath.row == 0){
            return kMEBdataStoreCustomerTopCellHeight;
        }else if (indexPath.row == 1){
            return kMEBdataColumnCellHeight;
        }else  if(indexPath.row == 2){
            return kMEBdataPieCellHeight;
        }else  if(indexPath.row == 3){
            return kMEBdataColumnCellHeight;
        }else  if(indexPath.row == 4){
            return kMEBdataLineCellHeight;
        }else{
            return 0.1;
        }
    }else{
        return 0.1;
    }
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBdataTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBdataTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBdataPieCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBdataPieCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBdataColumnCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBdataColumnCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBdataStoreCustomerTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBdataStoreCustomerTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBdataLineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBdataLineCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    }
    return _tableView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"icon-Bdata"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}
@end
