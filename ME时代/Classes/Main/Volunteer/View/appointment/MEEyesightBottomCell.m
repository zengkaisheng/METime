//
//  MEEyesightBottomCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEyesightBottomCell.h"
#import "TDWebViewCell.h"

@interface MEEyesightBottomCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell *webCell;

@end


@implementation MEEyesightBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.clipsToBounds = false;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-30, 38) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 38);
    maskLayer.path = maskPath.CGPath;
    _bgView.layer.mask = maskLayer;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,@""] baseURL:nil];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = kMEf5f4f4;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.scrollEnabled = NO;
}

#pragma mark -- UITableviewDelegate
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithContent:(NSString *)content {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(content).length>0?kMeUnNilStr(content):@"<p>暂无活动详情</p>"] baseURL:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

+ (CGFloat)getHeightWithContentHeight:(CGFloat)contentHeight {
    return 42+contentHeight;
}

@end
