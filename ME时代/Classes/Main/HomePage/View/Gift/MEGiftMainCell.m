//
//  MEGiftMainCell.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGiftMainCell.h"
#import "MEGiftMainContentCell.h"
#import "MEShoppingCartModel.h"
@interface MEGiftMainCell ()<UITableViewDelegate,UITableViewDataSource>{
    kMeBasicBlock _block;

}

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (nonatomic, strong) NSMutableArray *arrData;


@end

@implementation MEGiftMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.backgroundColor = [UIColor clearColor];
    _arrData = [NSMutableArray array];
    [_tableVIew registerNib:[UINib nibWithNibName:NSStringFromClass([MEGiftMainContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGiftMainContentCell class])];
    _tableVIew.rowHeight = kMEGiftMainContentCellHeight;
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableVIew.showsVerticalScrollIndicator = NO;
    _tableVIew.scrollEnabled = NO;
    _tableVIew.bounces = NO;
    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    _tableVIew.tableFooterView = [UIView new];
    // Initialization code
}

- (void)setUIWithModel:(NSArray *)model block:(kMeBasicBlock)block{
    _block = block;
    _arrData = [NSMutableArray arrayWithArray:model];
    _lblNum.text = [NSString stringWithFormat:@"共%@件",@(_arrData.count)];
    [self.tableVIew reloadData];
}

- (IBAction)continuAction:(UIButton *)sender {
    kMeCallBlock(_block);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGiftMainContentCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGiftMainContentCell class]) forIndexPath:indexPath];
    MEShoppingCartModel *goodsModel = _arrData[indexPath.row];
    kMeWEAKSELF
    cell.AddBlock = ^(UILabel *countLabel) {
        kMeSTRONGSELF
        goodsModel.goods_num = [countLabel.text integerValue];
        [strongSelf.arrData replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        [strongSelf countPrice];
    };
    cell.CutBlock = ^(UILabel *countLabel) {
        kMeSTRONGSELF
        goodsModel.goods_num = [countLabel.text integerValue];
        [strongSelf.arrData replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        [strongSelf countPrice];
    };
    MEShoppingCartModel *model = _arrData[indexPath.row];
    [cell setUIWIthModel:model];
    return cell;
}

- (void)countPrice{
    double totlePrice = 0.0;
    for (MEShoppingCartModel *goodsModel in _arrData) {
        double price = [goodsModel.money doubleValue];
        totlePrice += price * goodsModel.goods_num ;
    }
    NSString *price= [NSString stringWithFormat:@"￥%.2f", totlePrice];
    kMeCallBlock(_allPriceBlock,price);
}
    
+ (CGFloat)getCellHeightWithModel:(NSArray *)model{
    if(model.count == 0){
        return 0;
    }
    CGFloat height = 40;
    height+=model.count *kMEGiftMainContentCellHeight;
    return height;
}

@end
