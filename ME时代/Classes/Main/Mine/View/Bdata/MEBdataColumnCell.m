//
//  MEBdataColumnCell.m
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBdataColumnCell.h"
#import "AAChartKit.h"
#import "AAChartModel.h"
#import "MEBDataDealModel.h"

@interface MEBdataColumnCell ()<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;


@end

@implementation MEBdataColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.aaChartView.backgroundColor = [UIColor whiteColor];
    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [self.aaChartView aa_drawChartWithChartModel:self.aaChartModel];
    // Initialization code
}

- (void)setUiWithModel:(NSArray *)model Xtitle:(NSArray *)Xtitle title:(NSString *)title company:(NSString*)company{
    _aaChartModel.title = kMeUnNilStr(title);
    _aaChartModel.categories = Xtitle;
    self.aaChartModel
    .yAxisTickIntervalSet(@5)
    .yAxisMinSet(@(0))//Y轴最小值
    .seriesSet(@[
                 AASeriesElement.new
                 .nameSet(kMeUnNilStr(company))
                 .dataSet(model)
                 .colorByPointSet(@true),
                 ]
               );
    [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
}
- (void)setUiGoodNumWithModel:(NSArray *)model title:(NSString *)title company:(NSString*)company{
    NSMutableArray *Xtitle = [NSMutableArray array];
    NSMutableArray *nummodel = [NSMutableArray array];
    
    for (NSInteger i =0; i<model.count; i++) {
        MEBDataDealGoodsNum *cmodel =model[i];
        [Xtitle addObject:kMeUnNilStr(cmodel.product_name)];
        [nummodel addObject:@(cmodel.count)];
    }

    if(model.count == 0){
        [Xtitle addObject:@""];
        [nummodel addObject:@(0)];
    }
    _aaChartModel.title = kMeUnNilStr(title);
    _aaChartModel.categories = Xtitle;
    self.aaChartModel
    .yAxisTickIntervalSet(@5)
    .yAxisMinSet(@(0))//Y轴最小值
    .seriesSet(@[
                 AASeriesElement.new
                 .nameSet(kMeUnNilStr(company))
                 .dataSet(nummodel)
                 ]
               );
    [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
}

- (void)setUiWithModel:(NSArray *)model title:(NSString *)title company:(NSString*)company{
    NSMutableArray *Xtitle = [NSMutableArray array];
    NSMutableArray *nummodel = [NSMutableArray array];

    for (NSInteger i =0; i<model.count; i++) {
        MEBDataDealAchievementCatagery *cmodel =model[i];
        [Xtitle addObject:kMeUnNilStr(cmodel.category_name)];
        [nummodel addObject:@(cmodel.percent)];
    }
    if(model.count == 0){
        [Xtitle addObject:@""];
        [nummodel addObject:@(0)];
    }
    _aaChartModel.title = kMeUnNilStr(title);
    _aaChartModel.categories = Xtitle;
    self.aaChartModel
    .yAxisTickIntervalSet(@5)
    .yAxisMinSet(@(0))//Y轴最小值
    .seriesSet(@[
                 AASeriesElement.new
                 .nameSet(kMeUnNilStr(company))
                 .dataSet(nummodel),
                 ]
               );
    [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
}

- (AAChartModel *)aaChartModel{
    if(!_aaChartModel){
        _aaChartModel= AAChartModel.new
        .yAxisAllowDecimalsSet(NO)//是否允许Y轴坐标值小数
        .chartTypeSet(AAChartTypeColumn)//图表类型
        .titleFontSizeSet(@15)
        .titleSet(@"")//图表主标题
        .subtitleSet(@"")//图表副标题
        .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
        .colorsThemeSet(@[@"#F9B43B",@"#F9553C",@"#8C3F63",@"#24789D"])//设置主体颜色数组
        .easyGradientColorsSet(true)
        .yAxisTitleSet(@"")//设置 Y 轴标题
        .backgroundColorSet(@"#ffffff")
        .yAxisGridLineWidthSet(@1)
        .yAxisLineWidthSet(@1)
        .seriesSet(@[
                     AASeriesElement.new
                     .nameSet(@"人数")
                     .dataSet(@[@0,@0])
                     .lineWidthSet(@10),
                     ]
                   );
        //y轴横向分割线宽度为0(即是隐藏分割线)
        _aaChartModel.animationType = AAChartAnimationBounce;//图形的渲染动画为弹性动画
        _aaChartModel.yAxisTitle = @"";
        _aaChartModel.animationDuration = @10;//图形渲染动画时长为1200毫秒
        _aaChartModel.legendEnabled = NO;
//        _aaChartModel.tooltipEnabled = NO;
        _aaChartModel.yAxisGridLineWidth =@1;
        _aaChartModel.dataLabelEnabled = YES;
        _aaChartModel.dataLabelFontColor = @"#818181";
        
    }
    return _aaChartModel;
}

#pragma mark -- AAChartView delegate
- (void)AAChartViewDidFinishLoad {
    NSLog(@"🔥🔥🔥🔥🔥 AAChartView content did finish load!!!");
}

@end
