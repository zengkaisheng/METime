//
//  MEMyVIPDetailView.m
//  志愿星
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyVIPDetailView.h"
#import "MEMyCourseVIPInfoModel.h"
#import "TDWebViewCell.h"
#import "MEMyCourseVIPModel.h"

@interface MEMyVIPDetailView ()<UITableViewDelegate,UITableViewDataSource>
//C端
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipBGImageV;

//B端
@property (weak, nonatomic) IBOutlet UIImageView *b_headerPic;
@property (weak, nonatomic) IBOutlet UILabel *b_nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *b_phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *b_tipsLbl;
@property (weak, nonatomic) IBOutlet UIButton *b_vipBtn;
@property (weak, nonatomic) IBOutlet UIImageView *b_vipBGImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b_vipBGImageConsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b_vipBGImageConsTop;

@property (weak, nonatomic) IBOutlet UIButton *payRecordBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConsHeight;

@property (strong, nonatomic) TDWebViewCell *webCell;
@property (nonatomic, strong) MEMyCourseVIPInfoModel *model;

@property (nonatomic, strong) MEMyCourseVIPModel *vipModel;

@end

@implementation MEMyVIPDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    kSDLoadImg(_headerPic, kMeUnNilStr(kCurrentUser.header_pic));
    _nameLbl.text = [NSString stringWithFormat:@"用户:%@",kMeUnNilStr(kCurrentUser.name)];
    _phoneLbl.text = [NSString stringWithFormat:@"手机号:%@",kMeUnNilStr(kCurrentUser.mobile)];
    
//    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];//customer  business
    if (kCurrentUser.user_type == 4) {
        _b_headerPic.hidden = YES;
        _b_nameLbl.hidden = YES;
        _b_phoneLbl.hidden = YES;
        _b_tipsLbl.hidden = YES;
        _b_vipBtn.hidden = YES;
        _b_vipBGImageConsHeight.constant = 0.0;
        _b_vipBGImageConsTop.constant = 0.0;
        _b_vipBGImageV.hidden = YES;
    }else {
        _b_headerPic.hidden = NO;
        _b_nameLbl.hidden = NO;
        _b_phoneLbl.hidden = NO;
        _b_tipsLbl.hidden = NO;
        _b_vipBtn.hidden = NO;
        _b_vipBGImageV.hidden = NO;
        _b_vipBGImageConsHeight.constant = 175*kMeFrameScaleX();
        _b_vipBGImageConsTop.constant = 25.0;
        
        kSDLoadImg(_b_headerPic, kMeUnNilStr(kCurrentUser.header_pic));
        _b_nameLbl.text = [NSString stringWithFormat:@"用户:%@",kMeUnNilStr(kCurrentUser.name)];
        _b_phoneLbl.text = [NSString stringWithFormat:@"手机号:%@",kMeUnNilStr(kCurrentUser.mobile)];
    }
    
//    CAGradientLayer *layer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:195/255.0 green:164/255.0 blue:109/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:180/255.0 green:147/255.0 blue:89/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:164/255.0 green:130/255.0 blue:68/255.0 alpha:1.0].CGColor] locations:@[@(0),@(0.4f),@(1.0f)] frame:_vipBtn.bounds];
//    [_vipBtn.layer insertSublayer:layer atIndex:0];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
    
    _tableView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(0,3);
    _tableView.layer.shadowRadius = 6;
    _tableView.layer.shadowOpacity = 1;
    _tableView.layer.masksToBounds = false;
    _tableView.layer.cornerRadius = 9;
    _tableView.clipsToBounds = false;
    
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

- (void)setUIWithModel:(MEMyCourseVIPInfoModel *)model {
    self.model = model;
    _tipsLbl.text = kMeUnNilStr(model.expire_time).length>0?kMeUnNilStr(model.expire_time):@"您当前不是VIP";
//    if (model.is_buy == 1) {
//        _payRecordBtn.hidden = NO;
//    }else {
//        _payRecordBtn.hidden = YES;
//    }
    if (model.is_vip == 1) {
        [_vipBtn setTitle:@"立即续费" forState:UIControlStateNormal];
    }else {
        [_vipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(model.vip_rule)] baseURL:nil];
    
    kMeWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        kMeSTRONGSELF
        CGFloat height = [[strongSelf.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        strongSelf->_tableViewConsHeight.constant = height>194?height:194;
        [strongSelf->_tableView reloadData];
    });
}

- (void)setUIWithVIPModel:(MEMyCourseVIPModel *)model {
    self.vipModel = model;
    MEMyCourseVIPSubModel *c_vipModel = self.vipModel.C_vip;
    MEMyCourseVIPDetailModel *c_vip_detail = c_vipModel.vip.firstObject;
    
    _tipsLbl.text = kMeUnNilStr(c_vip_detail.expire_time).length>0?kMeUnNilStr(c_vip_detail.expire_time):@"您当前不是VIP";
    if (c_vip_detail.is_vip == 1) {
        [_vipBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        _vipBGImageV.image = [UIImage imageNamed:@"c_vip_bgImage"];
        _nameLbl.textColor = _phoneLbl.textColor = _tipsLbl.textColor = [UIColor colorWithHexString:@"#75623F"];
    }else {
        [_vipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        _vipBGImageV.image = [UIImage imageNamed:@"c_unvip_bgImage"];
        _nameLbl.textColor = _phoneLbl.textColor = _tipsLbl.textColor = [UIColor whiteColor];
    }
    
    MEMyCourseVIPSubModel *b_vipModel = self.vipModel.B_vip;
    MEMyCourseVIPDetailModel *b_vip_detail = b_vipModel.vip.firstObject;
    
    _b_tipsLbl.text = kMeUnNilStr(b_vip_detail.expire_time).length>0?kMeUnNilStr(b_vip_detail.expire_time):@"您当前不是VIP";
    if (b_vip_detail.is_vip == 1) {
        [_b_vipBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        _b_vipBGImageV.image = [UIImage imageNamed:@"b_vip_bgImage"];
        _b_nameLbl.textColor = _b_phoneLbl.textColor = _b_tipsLbl.textColor = [UIColor colorWithHexString:@"#692031"];
    }else {
        [_b_vipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        _b_vipBGImageV.image = [UIImage imageNamed:@"b_unvip_bgImage"];
        _b_nameLbl.textColor = _b_phoneLbl.textColor = _b_tipsLbl.textColor = [UIColor whiteColor];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(c_vipModel.vip_rule)] baseURL:nil];
    
    kMeWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        kMeSTRONGSELF
        CGFloat height = [[strongSelf.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        strongSelf->_tableViewConsHeight.constant = height>194?height:194;
        [strongSelf->_tableView reloadData];
    });
    if (b_vipModel.vip.count <= 0) {
        _b_headerPic.hidden = YES;
        _b_nameLbl.hidden = YES;
        _b_phoneLbl.hidden = YES;
        _b_tipsLbl.hidden = YES;
        _b_vipBtn.hidden = YES;
        _b_vipBGImageConsHeight.constant = 0.0;
        _b_vipBGImageConsTop.constant = 0.0;
        _b_vipBGImageV.hidden = YES;
    }
}

- (IBAction)openVIPAction:(id)sender {
    kMeCallBlock(self.indexBlock,1);
}
- (IBAction)checkRecordAction:(id)sender {
    kMeCallBlock(self.indexBlock,2);
}
- (IBAction)openBVIPAction:(id)sender {
    kMeCallBlock(self.indexBlock,3);
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.webCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_webCell){
        return 0;
    }
    return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

+ (CGFloat)getViewHeightWithRuleHeight:(CGFloat)ruleHeight {
    CGFloat height = 727 - 194;
    
//    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
    if (kCurrentUser.user_type == 4) {
        height -= 200;
    }

    height += ruleHeight>194?ruleHeight:194;
    return height*kMeFrameScaleX();
}

@end
