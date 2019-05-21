//
//  MEServiceDetailsVC.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEServiceDetailsVC.h"
#import "MEServiceDetailsHeaderView.h"
#import "TDWebViewCell.h"
#import "MEProductDetailsSectionView.h"
#import "MEProductDetalsBuyedCell.h"
#import "MEProductDetalsBuyedCell.h"
#import "MEServiceDetailsBottomView.h"
#import "MEServiceDetailTelAddressCell.h"
#import "MEGoodDetailModel.h"
#import "MERCConversationVC.h"
#import "MELoginVC.h"
#import "MEAppointmentInfoVC.h"
#import "MEServiceDetailsModel.h"
#import "MEStoreDetailModel.h"
#import "MEAppointAttrModel.h"

@interface MEServiceDetailsVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _detailsId;;
    NSArray *_arrTitle;
    MEStoreDetailModel *_storeDetailModel;
    NSString *_customId;
    BOOL _isFromStore;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) MEServiceDetailsBottomView *bottomView;
@property (nonatomic, strong) MEServiceDetailsHeaderView *headerView;;
@property (strong, nonatomic) TDWebViewCell                  *webCell;
@property (nonatomic, strong) UIView *tableViewBottomView;
@property (nonatomic, strong) MEServiceDetailsModel *model;
@property (nonatomic, strong) MEAppointAttrModel *attrModel;
@end

@implementation MEServiceDetailsVC

- (void)dealloc{
    kTDWebViewCellDidFinishLoadNotificationCancel
}

- (instancetype)initWithId:(NSInteger)detailsId{
    if(self = [super init]){
        _detailsId = detailsId;
//        _storeDetailModel = storeDetailModel;
        _isFromStore = NO;
    }
    return self;
}

- (instancetype)initWithId:(NSInteger)detailsId storeDetailModel:(MEStoreDetailModel *)storeDetailModel{
    if(self = [super init]){
        _detailsId = detailsId;
        _storeDetailModel = storeDetailModel;
        _isFromStore = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务详情";
    _arrTitle = @[@"产品介绍",@"ME时代美店",@"预约了这件商品的人也预约了"];
    [self initWithSomeThing];
    kTDWebViewCellDidFinishLoadNotification
    // Do any additional setup after loading the view.
}

- (void)initWithSomeThing{
    kMeWEAKSELF
    [MEPublicNetWorkTool postServiceDetailWithServiceId:_detailsId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MEServiceDetailsModel *model = [MEServiceDetailsModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf setUIWithModel:model];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUIWithModel:(MEServiceDetailsModel *)model{
    self.model = model;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.tableViewBottomView;
    [self.headerView setUIWithModel:self.model.serviceDetail];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kMEServiceDetailsBottomViewHeight));
        make.width.equalTo(@(self.view.width));
        make.top.equalTo(@(self.view.bottom-kMEServiceDetailsBottomViewHeight));
    }];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.model.serviceDetail.content)] baseURL:nil];
    [MBProgressHUD showMessage:@"加载详情" toView:self.view];
}

kTDWebViewCellDidFinishLoadNotificationMethod

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return self.webCell;
    }else if(indexPath.section == 1){
        if(_isFromStore){
            MEServiceDetailTelAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEServiceDetailTelAddressCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:_storeDetailModel];
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }else if(indexPath.section == 2){
        MEProductDetalsBuyedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class]) forIndexPath:indexPath];
        [cell setServiceUIWithArr:kMeUnArr(_model.recommendService) storeDetailModel:_storeDetailModel];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else if(indexPath.section == 1){
        return _isFromStore?kMEServiceDetailTelAddressCellHeight:0.1;
    }else if(indexPath.section == 2){
        return kMEProductDetalsBuyedCellHeight;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.section);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kMEProductDetailsSectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEProductDetailsSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEProductDetailsSectionView class])];
    headview.lblTitle.text = kMeUnArr(_arrTitle)[section];
    return headview;
}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEServiceDetailsBottomViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetalsBuyedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEServiceDetailTelAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEServiceDetailTelAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetailsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEProductDetailsSectionView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEServiceDetailsBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MEServiceDetailsBottomView" owner:nil options:nil] lastObject];
        kMeWEAKSELF
        _bottomView.appointMentBlock = ^{
//            kMeSTRONGSELF
//            [MECommonTool showWithTellPhone:kMeUnNilStr(strongSelf->_storeDetailModel.cellphone) inView:strongSelf.view];
            if([MEUserInfoModel isLogin]){
                kMeSTRONGSELF
                strongSelf.attrModel.store_id = strongSelf->_storeDetailModel.store_id;
                strongSelf.attrModel.storeName = strongSelf->_storeDetailModel.store_name;
                MEAppointmentInfoVC *infoVC = [[MEAppointmentInfoVC alloc]initWithAttrModel:strongSelf.attrModel serviceDetailModel:strongSelf.model];
                [strongSelf.navigationController pushViewController:infoVC animated:YES];
            }else{
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    strongSelf.attrModel.store_id = strongSelf->_storeDetailModel.store_id;
                    strongSelf.attrModel.storeName = strongSelf->_storeDetailModel.store_name;
                    MEAppointmentInfoVC *infoVC = [[MEAppointmentInfoVC alloc]initWithAttrModel:strongSelf.attrModel serviceDetailModel:strongSelf.model];
                    [strongSelf.navigationController pushViewController:infoVC animated:YES];
                } failHandler:nil];
            }
        };
        _bottomView.customBlock = ^{
            kMeSTRONGSELF
            if([MEUserInfoModel isLogin]){
                [strongSelf toCustom];
            }else{
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    [strongSelf toCustom];
                } failHandler:nil];
            }
        };
    }
    return _bottomView;
}

- (void)toCustom{
//    if(kMeUnNilStr(_customId).length){
//        MERCConversationVC *conversationVC = [[MERCConversationVC alloc]init];
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        conversationVC.targetId =  kMeUnNilStr(_customId);//RONGYUNCUSTOMID;
//        conversationVC.title = @"客服";
//        if([kMeUnNilStr(_customId) isEqualToString:kCurrentUser.uid]){
//            [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self.view];
//        }else{
//            [self.navigationController pushViewController:conversationVC animated:YES];
//        }
//    }else{
//        kMeWEAKSELF
//        [MEPublicNetWorkTool postGetCustomIdWithsuccessBlock:^(ZLRequestResponse *responseObject) {
//            kMeSTRONGSELF
//            NSNumber *custom =kMeUnNilNumber(responseObject.data);
//            strongSelf->_customId = kMeUnNilStr(custom.description);
//            MERCConversationVC *conversationVC = [[MERCConversationVC alloc]init];
//            conversationVC.conversationType = ConversationType_PRIVATE;
//            conversationVC.targetId = strongSelf->_customId ;//RONGYUNCUSTOMID;
//            conversationVC.title = @"客服";
//            if([kMeUnNilStr(strongSelf->_customId) isEqualToString:kCurrentUser.uid]){
//                [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self.view];
//            }else{
//                [self.navigationController pushViewController:conversationVC animated:YES];
//            }
//        } failure:^(id object) {
//            
//        }];
//    }
}

- (MEServiceDetailsHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEServiceDetailsHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEServiceDetailsHeaderView getViewHeight]);
    }
    return _headerView;
}

- (UIView *)tableViewBottomView{
    if(!_tableViewBottomView){
        _tableViewBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableViewBottomView.backgroundColor = kMEHexColor(@"eeeeee");
        UIImageView *img = [[UIImageView alloc]initWithImage:kMeGetAssetImage(@"icon-utkkyung")];
        img.frame = _tableViewBottomView.bounds;
        [_tableViewBottomView addSubview:img];
    }
    return _tableViewBottomView;
}


- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

- (MEAppointAttrModel *)attrModel{
    if(!_attrModel){
        _attrModel = [[MEAppointAttrModel alloc]initAttr];
        _attrModel.product_id = _detailsId;
        _attrModel.isFromStroe = _isFromStore;
    }
    return _attrModel;
}


@end
