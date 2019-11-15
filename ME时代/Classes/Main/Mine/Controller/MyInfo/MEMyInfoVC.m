//
//  MEMyInfoVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyInfoVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MEMyInfoListCell.h"
#import "MEMyInfoModel.h"
#import "MEEditMyInfoVC.h"

@interface MEMyInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MEMyInfoModel *model;

@end

@implementation MEMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self requestMyInfoWithNetWork];
}

- (void)loadBaseInformation {
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    //基本资料
    MEAddCustomerInfoModel *headerPicModel = [self creatModelWithTitle:@"头像" andValue:kMeUnNilStr(self.model.header_pic)];
    headerPicModel.isShowImage = YES;
    
    MEAddCustomerInfoModel *nickNameModel = [self creatModelWithTitle:@"昵称" andValue:kMeUnNilStr(self.model.nick_name)];
    nickNameModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *signatureModel = [self creatModelWithTitle:@"公益签名" andValue:kMeUnNilStr(self.model.signature)];
    signatureModel.isHideArrow = NO;
    signatureModel.maxInputWord = 20;
    
//    NSString *name = [self replaceStringWithOrgStr:kMeUnNilStr(self.model.name) range:NSMakeRange(0, 1)];
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"姓名" andValue:kMeUnNilStr(self.model.name)];
    
    MEAddCustomerInfoModel *idCardTypeModel = [self creatModelWithTitle:@"证件类型" andValue:@"内地舒居民身份证"];
    
//    NSString *idCard = [self replaceStringWithOrgStr:kMeUnNilStr(self.model.id_number) range:NSMakeRange(8, 5)];
    MEAddCustomerInfoModel *idCardModel = [self creatModelWithTitle:@"证件号码" andValue:kMeUnNilStr(self.model.id_number)];
    
    NSString *time = [kMeUnNilStr(self.model.created_at) componentsSeparatedByString:@" "].firstObject;
    MEAddCustomerInfoModel *timeModel = [self creatModelWithTitle:@"注册日期" andValue:kMeUnNilStr(time)];
    NSString *sex = @"";
    switch (self.model.sex) {
        case 1:
            sex = @"男";
            break;
        case 2:
            sex = @"女";
            break;
        case 3:
            sex = @"保密";
            break;
        default:
            break;
    }
    MEAddCustomerInfoModel *sexModel = [self creatModelWithTitle:@"性别" andValue:sex];
    
    [self.dataSource addObjectsFromArray:@[headerPicModel,nickNameModel,signatureModel,nameModel,idCardTypeModel,idCardModel,timeModel,sexModel]];
    [self.tableView reloadData];
}

- (NSString *)replaceStringWithOrgStr:(NSString *)orgString range:(NSRange)range {
    NSMutableString *mutString = [NSMutableString stringWithString:orgString];
    if (range.length == 1) {
        [mutString replaceCharactersInRange:range withString:@"*"];
    }else if (range.length == 5) {
        [mutString replaceCharactersInRange:range withString:@"*****"];
    }
    
    return mutString.copy;
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andValue:(NSString *)value {
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = value;
    model.isTextField = NO;
    model.isHideArrow = YES;
    return model;
}

#pragma mark -- Networking
//个人资料
- (void)requestMyInfoWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetMyInfoWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEMyInfoModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf loadBaseInformation];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMyInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyInfoListCell class]) forIndexPath:indexPath];
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    [cell setUIWithCustomerModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 67;
    }
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 2) {
        MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
        MEEditMyInfoVC *vc = [[MEEditMyInfoVC alloc] initWithModel:model];
        kMeWEAKSELF
        vc.finishBlock = ^{
            kMeSTRONGSELF
            [strongSelf requestMyInfoWithNetWork];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyInfoListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyInfoListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
//        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
