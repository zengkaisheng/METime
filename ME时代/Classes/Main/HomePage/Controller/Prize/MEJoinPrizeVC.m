//
//  MEJoinPrizeVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEJoinPrizeVC.h"
#import "MEPrizeDetailsModel.h"
#import "MEPrizeHeaderView.h"
#import "MEJoinPrizeCell.h"
#import "MEJoinPrizePeopleCell.h"
#import "MEWaitPublishPrizeCell.h"
#import "MEPublishPrizeCell.h"
#import "MECheckAllPrizePeopleVC.h"
#import "METhridProductDetailsVC.h"

@interface MEJoinPrizeVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_imgUrl;
}
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, strong) MEPrizeDetailsModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEPrizeHeaderView *headerView;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MEJoinPrizeVC

- (instancetype)initWithActivityId:(NSString *)activityId {
    if (self = [super init]) {
        self.activityId = activityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.title = @"签到活动";
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self requestNetWork];
    [self getShareCode];
    [self.view addSubview:self.bottomView];
}

- (void)getShareCode{
    kMeWEAKSELF
    [MEPublicNetWorkTool getUserGetCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_imgUrl = kMeUnNilStr(responseObject.data);
    } failure:^(id object) {
    }];
}

- (void)requestNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetPrizeDetailWithActivityId:self.activityId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEPrizeDetailsModel mj_objectWithKeyValues:responseObject.data];
            [strongSelf.headerView setUIWithModel:strongSelf.model];
            if (strongSelf.model.join_type == 3) {
                [strongSelf.moreBtn setTitle:@"立即领取" forState:UIControlStateNormal];
            }else {
                [strongSelf.moreBtn setTitle:@"参与更多抽奖" forState:UIControlStateNormal];
            }
        }else{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//参加抽奖
- (void)joinPrize {
    kMeWEAKSELF
    [MEPublicNetWorkTool postJoinPrizeWithActivityId:self.activityId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
        if([responseObject isKindOfClass:[ZLRequestResponse class]]){
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"参与成功"];
            if (strongSelf.finishBlock) {
                strongSelf.finishBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf requestNetWork];
            });
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)moreBtnAction {
    if (self.model.join_type == 3) {
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:self.model.product_id];
        details.isReceivePrize = YES;
        details.activity_id = _activityId;
        [self.navigationController pushViewController:details animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shareActionWithIndex:(NSInteger)index {
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    
    //https://test.meshidai.com/cjsrc/newAuth.html?id=21&fid=88086&img=xxx.jpg
    shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@cjsrc/newAuth.html?id=%@&fid=%@&img=%@",baseUrl,_activityId,kMeUnNilStr(kCurrentUser.uid),_imgUrl];
    NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
    
    shareTool.shareTitle = self.model.title;
    shareTool.shareDescriptionBody = @"好友邀请您免费抽奖！";
    shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.image]]];
//    kMeGetAssetImage(@"icon-wgvilogo");
    //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    //    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    [shareTool shareWebPageToPlatformType:index+1 success:^(id data) {
        NSLog(@"分享成功%@",data);
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        NSLog(@"分享失败%@",error);
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}

//查看图文详情
- (void)checkDetails {
    kMeWEAKSELF
    [MEPublicNetWorkTool postCheckPrizeContentWithActivityId:self.activityId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)responseObject.data;
            MEBaseVC *vc = [[MEBaseVC alloc] init];
            vc.title = strongSelf.model.title;
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            [webView loadHTMLString:dict[@"content"] baseURL:nil];
            [vc.view addSubview:webView];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id object) {
    }];
}

- (void)checkAllPrizePeopleWithType:(NSInteger)type {
    NSInteger count = 0;
    switch (type) {
        case 1://全部参与
            count = self.model.join_number;
            break;
        case 2://全部中奖
            count = self.model.lucky.count;
            break;
        case 3://全部邀请
            count = self.model.inviteNum;
            break;
        default:
            break;
    }
    
    MECheckAllPrizePeopleVC *vc = [[MECheckAllPrizePeopleVC alloc] initWithType:type count:count activityId:self.model.idField];
    kMeWEAKSELF
    vc.reloadBlock = ^{
        kMeSTRONGSELF
        [strongSelf requestNetWork];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model.status == 1) {//未开奖
        return 2;
    }
    return 1;//已开奖
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    kMeWEAKSELF
    if (self.model.status == 2) {
        MEPublishPrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPublishPrizeCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.model];
        cell.checkAllBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if (index == 0) {
                //查看所有中奖人
                [strongSelf checkAllPrizePeopleWithType:2];
            }else if (index == 1) {
                //查看所有参与人
                [strongSelf checkAllPrizePeopleWithType:1];
            }
        };
        cell.checkDetailBlock = ^{
           //查看图文详情
            kMeSTRONGSELF
            [strongSelf checkDetails];
        };
        return cell;
    }
    //未开奖
    if (self.model.join_type == 2) {//参加
        if (indexPath.row == 0) {
            MEWaitPublishPrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEWaitPublishPrizeCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:self.model];
            cell.checkBlock = ^{
                kMeSTRONGSELF
                //查看全部邀请
                [strongSelf checkAllPrizePeopleWithType:3];
            };
            cell.indexBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                //0邀请好友 1分享到朋友圈
                if (index) {
                    [strongSelf shareActionWithIndex:1];
                }else {
                    [strongSelf shareActionWithIndex:0];
                }
            };
            return cell;
        }
    }else {//未参加
        if (indexPath.row == 0) {
            MEJoinPrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEJoinPrizeCell class]) forIndexPath:indexPath];
            cell.joinBlock = ^{
                //参加抽奖
                kMeSTRONGSELF
                [strongSelf joinPrize];
            };
            return cell;
        }
    }
    MEJoinPrizePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEJoinPrizePeopleCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.model];
    cell.checkAllBlock = ^{
        kMeSTRONGSELF
        //查看全部参与
        [strongSelf checkAllPrizePeopleWithType:1];
    };
    cell.checkDetailBlock = ^{
        //查看详情
        kMeSTRONGSELF
        [strongSelf checkDetails];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.status == 2) {
        return (kMEPublishPrizeCellHeight - (self.model.prizeLog.count<=0?71:0))*kMeFrameScaleY();
    }
    if (self.model.join_type == 2) {
        if (indexPath.row == 0) {
            return kMEWaitPublishPrizeCellHeight;
        }
    }else {
        if (indexPath.row == 0) {
            return kMEJoinPrizeCellHeight;
        }
    }
    return kMEJoinPrizePeopleCellHeight;
}

- (CAGradientLayer *)getLayerWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors locations:(NSArray *)locations frame:(CGRect)frame {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = endPoint;//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = colors;
    layer.locations = locations;//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = frame;
    return layer;
}

#pragma helper
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight - 75) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEJoinPrizeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEJoinPrizeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEJoinPrizePeopleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEJoinPrizePeopleCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEWaitPublishPrizeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEWaitPublishPrizeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPublishPrizeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPublishPrizeCell class])];
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (MEPrizeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEPrizeHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEPrizeHeaderViewHeight);
        kMeWEAKSELF
        _headerView.tapBlock = ^{
            //点击购买
            kMeSTRONGSELF
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:strongSelf.model.product_id];
            [strongSelf.navigationController pushViewController:details animated:YES];
        };
    }
    return _headerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-75, SCREEN_WIDTH, 75)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        //阴影效果
        _bottomView.layer.shadowColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:0.24].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0,-7);
        _bottomView.layer.shadowOpacity = 1;
        _bottomView.layer.shadowRadius = 8;
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setFrame:CGRectMake(14, 15, SCREEN_WIDTH - 28, 45)];
        [moreBtn setTitle:@"参与更多抽奖" forState:UIControlStateNormal];
        [moreBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Bold" size:14]];
        [moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        CAGradientLayer *btnLayer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:255/255.0 green:194/255.0 blue:76/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:181/255.0 blue:64/255.0 alpha:1.0].CGColor] locations:@[@(0.0),@(1.0)] frame:moreBtn.layer.bounds];
        [moreBtn.layer insertSublayer:btnLayer atIndex:0];
        
        moreBtn.layer.cornerRadius = 5;
        moreBtn.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:183/255.0 blue:65/255.0 alpha:0.9].CGColor;
        moreBtn.layer.shadowOffset = CGSizeMake(0,3);
        moreBtn.layer.shadowOpacity = 1;
        moreBtn.layer.shadowRadius = 7;
        self.moreBtn = moreBtn;
        [_bottomView addSubview:moreBtn];
    }
    return _bottomView;
}

@end
