//
//  MEPolarChartMixedCell.m
//  ME时代
//
//  Created by hank on 2019/3/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEPolarChartMixedCell.h"
#import "AAChartKit.h"
#import "AAChartModel.h"
#import "MEBrandAbilityAnalysisModel.h"

@interface MEPolarChartMixedCell ()<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;


@end

@implementation MEPolarChartMixedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.aaChartView.backgroundColor = [UIColor whiteColor];
    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [self.aaChartView aa_drawChartWithChartModel:self.aaChartModel];
    // Initialization code
}

- (void)setUiWithModel:(MEBrandAbilityAnalysisModel *)model{
    NSInteger allCount = model.total_store;
    NSMutableArray *arrdata = [NSMutableArray array];
    if(allCount){
        CGFloat sale_rank =1-((CGFloat) model.sale_rank/allCount);
        [arrdata addObject:@(sale_rank)];
        CGFloat communicate_rank = 1 - ((CGFloat)model.communicate_rank/allCount);
        [arrdata addObject:@(communicate_rank)];
        CGFloat product_rank = 1 - ((CGFloat)model.product_rank/allCount);
        [arrdata addObject:@(product_rank)];
        CGFloat activity_rank =1 - ((CGFloat) model.activity_rank/allCount);
        [arrdata addObject:@(activity_rank)];
        CGFloat sale_num_rank = 1 - ((CGFloat)model.sale_num_rank/allCount);
        [arrdata addObject:@(sale_num_rank)];
        CGFloat access_rank =1 - ((CGFloat) model.access_rank/allCount);
        [arrdata addObject:@(access_rank)];
    }else{
        for (NSInteger i =0 ; i<6; i++) {
            [arrdata addObject:@(0)];
        }
    }
    self.aaChartModel.categories = @[@"销售能力", @"客户互动力", @"产品推广力", @"活动推广力", @"客户跟进力", @"获客能力"];
    self.aaChartModel.series =
    @[
      AASeriesElement.new
      .nameSet(@"能力")
      .typeSet(AAChartTypeArea)
      .dataSet(arrdata)
      ];
    [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
}

- (AAChartModel *)aaChartModel{
    if(!_aaChartModel){
        _aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeColumn)
        .polarSet(true)
        .titleSet(@"");
    }
    return _aaChartModel;
}


#pragma mark -- AAChartView delegate
- (void)AAChartViewDidFinishLoad {
    NSLog(@"🔥🔥🔥🔥🔥 AAChartView content did finish load!!!");
}


@end
