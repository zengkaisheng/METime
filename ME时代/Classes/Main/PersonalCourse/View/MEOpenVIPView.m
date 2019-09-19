//
//  MEOpenVIPView.m
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOpenVIPView.h"
#import "MECourseVIPModel.h"
#import "TDWebViewCell.h"

@interface MEOpenVIPView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLblConsTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell *webCell;

@property (nonatomic, strong) MECourseVIPModel *model;

@end

@implementation MEOpenVIPView

- (void)awakeFromNib {
    [super awakeFromNib];
    kSDLoadImg(_headerPic, kMeUnNilStr(kCurrentUser.header_pic));
    _nameLbl.text = [NSString stringWithFormat:@"用户:%@",kMeUnNilStr(kCurrentUser.name)];
    _phoneLbl.text = [NSString stringWithFormat:@"手机号:%@",kMeUnNilStr(kCurrentUser.mobile)];
    _priceLblConsTop.constant = 85*kMeFrameScaleY();
    
    CAGradientLayer *layer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:195/255.0 green:164/255.0 blue:109/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:180/255.0 green:147/255.0 blue:89/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:164/255.0 green:130/255.0 blue:68/255.0 alpha:1.0].CGColor] locations:@[@(0),@(0.4f),@(1.0f)] frame:_vipBtn.bounds];
    [_vipBtn.layer insertSublayer:layer atIndex:0];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,@""] baseURL:nil];
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

- (void)setUIWithModel:(MECourseVIPModel *)model {
    self.model = model;
    if (model.vip.count <= 0) {
        return;
    }
    MECourseVIPDetailModel *detailModel = model.vip.firstObject;
    _priceLbl.text = kMeUnNilStr(detailModel.name);
    _amountLbl.text = [NSString stringWithFormat:@"%@元",kMeUnNilStr(detailModel.price)];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(model.vip_rule)] baseURL:nil];
    
    [_tableView reloadData];
}

- (IBAction)payAction:(id)sender {
    kMeCallBlock(self.finishBlock);
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
    return self.model.ruleHeight;
    //    return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

+ (CGFloat)getViewHeightWithRuleHeight:(CGFloat)ruleHeight {
    CGFloat height = 660 - 194;
    
    height += ruleHeight>194?ruleHeight:194;
    return height;
}

@end
