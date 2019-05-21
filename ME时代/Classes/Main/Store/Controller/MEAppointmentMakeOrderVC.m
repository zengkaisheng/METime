//
//  MEAppointmentMakeOrderVC.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentMakeOrderVC.h"
#import "MEAppointmentInfoVC.h"
#import "MEAppointmentSelectStoreVC.h"
#import "MEOrderSelectStoreCell.h"
#import "MEAppointOrderMainCell.h"
#import "MEAppointAttrModel.h"
#import "MEStoreModel.h"
#import "MEStoreDetailModel.h"
#import "MEServiceDetailsModel.h"
#import "MEServiceDetailsVC.h"

const static CGFloat kSubmitBtnHeight = 50;
const static CGFloat kSectionHeight = 40;

@interface MEAppointmentMakeOrderVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_selectStoreStr;
    NSString *_timeStr;
    NSArray *_arrType;
    MEServiceDetailsModel *_serviceDetailModel;

}
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) MEAppointAttrModel              *attrModel;
@end

@implementation MEAppointmentMakeOrderVC

- (instancetype)initWithAttrModel:(MEAppointAttrModel *)attrModel serviceDetailModel:(MEServiceDetailsModel *)serviceDetailModel{
    if(self = [super init]){
        _serviceDetailModel = serviceDetailModel;
        self.attrModel = attrModel;
        _timeStr = self.attrModel.arrive_time;
        _selectStoreStr = self.attrModel.storeName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    _arrType = @[@"预约门店",@"预约时间"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnSubmit];
    // Do any additional setup after loading the view.
}

- (void)toSubmit:(UIButton *)btn{
    if(!kMeUnNilStr(self.attrModel.storeName).length){
        [MEShowViewTool showMessage:@"请选择门店" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.attrModel.arrive_time).length){
        [MEShowViewTool showMessage:@"请选择时间" view:kMeCurrentWindow];
        return;
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postCreatAppointWithAttrModel:self.attrModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if(strongSelf.attrModel.is_first_buy){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kcheckFirstBuy];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [MEPublicNetWorkTool getUserCheckFirstBuyWithSuccessBlock:nil failure:nil];
        MEServiceDetailsVC *dvc = (MEServiceDetailsVC *)[MECommonTool getClassWtihClassName:[MEServiceDetailsVC class] targetVC:strongSelf];
        if(dvc){
            [strongSelf.navigationController popToViewController:dvc animated:YES];
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return _arrType.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSString *title = _arrType[indexPath.row];
        MEOrderSelectStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderSelectStoreCell class]) forIndexPath:indexPath];
        [cell setUIWithSubtitle:indexPath.row?_timeStr:_selectStoreStr title:title];
        return cell;
    }else if (indexPath.section == 1){
        MEAppointOrderMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointOrderMainCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:_serviceDetailModel attrModel:self.attrModel];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kMEOrderSelectStoreCellHeight;
    }else{
        return kMEAppointOrderMainCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0 ){
            //首页进入可点
            if(!self.attrModel.isFromStroe){
                MEAppointmentSelectStoreVC *ssVC = [[MEAppointmentSelectStoreVC alloc]initWithStoreId:self.attrModel.store_id];
                kMeWEAKSELF
                ssVC.stroeBlock = ^(MEStoreModel *model) {
                    kMeSTRONGSELF
                    strongSelf.attrModel.store_id = model.store_id;
                    strongSelf.attrModel.storeName = kMeUnNilStr(model.store_name);
                    strongSelf->_selectStoreStr = kMeUnNilStr(model.store_name);
                    [strongSelf.tableView reloadData];
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:ssVC animated:YES];
            }
        }else if (indexPath.row == 1){
            MEAppointmentInfoVC *infoVC = [[MEAppointmentInfoVC alloc]init];
            kMeWEAKSELF
            infoVC.block = ^(METimeModel *object) {
                kMeSTRONGSELF
                strongSelf->_timeStr = [NSString stringWithFormat:@"%@ %@",kMeUnNilStr(object.yearAndMonth),kMeUnNilStr(object.time)];
                strongSelf.attrModel.arrive_time = strongSelf->_timeStr;
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:infoVC animated:YES];
        }else{
            
        }
    }else{
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSectionHeight)];
        sectionView.backgroundColor =kMEHexColor(@"eeeeee");
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, kSectionHeight)];
        lbl.textColor = kMEHexColor(@"333333");
        lbl.font =kMeFont(14);
        lbl.text = @"填写预约信息";
        [sectionView addSubview:lbl];
        return sectionView;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEHexColor(@"eeeeee");
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return kSectionHeight;
    }else{
        return 10;
    }
}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kSubmitBtnHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderSelectStoreCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderSelectStoreCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointOrderMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointOrderMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)btnSubmit{
    if(!_btnSubmit){
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSubmit.frame = CGRectMake(0, SCREEN_HEIGHT - kSubmitBtnHeight, SCREEN_WIDTH, kSubmitBtnHeight);
        [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        _btnSubmit.titleLabel.font = kMeFont(15);
        [_btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSubmit setBackgroundColor:kMEHexColor(@"cc9e69")];
        [_btnSubmit addTarget:self action:@selector(toSubmit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}

//- (UIView *)sectionView{
//    if(_sectionView){
//        _sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSectionHeight)];
//        _sectionView.backgroundColor =kMEHexColor(@"eeeeee");
//        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, kSectionHeight)];
//        lbl.textColor = kMEHexColor(@"333333");
//        lbl.font =kMeFont(14);
//        lbl.text = @"填写预约信息";
//        [_sectionView addSubview:lbl];
//    }
//    return _sectionView;
//}

@end
