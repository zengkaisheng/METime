//
//  MEVisterTodyCell.m
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEVisterTodyCell.h"
#import "AAChartKit.h"
#import "AAChartModel.h"

@interface MEVisterTodyCell ()<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;
@property (weak, nonatomic) IBOutlet UIView *viewForAA;

@end

@implementation MEVisterTodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _viewForAA.layer.shadowColor = kMEPink.CGColor;
    _viewForAA.layer.shadowOpacity = 0.5;
    _viewForAA.layer.shadowOffset = CGSizeMake(0, 0);
    _viewForAA.layer.shadowRadius = 2;;
    
    self.aaChartView.backgroundColor = [UIColor whiteColor];
    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [self.aaChartView aa_drawChartWithChartModel:self.aaChartModel];
}


- (void)setUiWithModel:(NSNumber *)model posterCount:(NSNumber*)posterCount{
    self.aaChartModel
    .yAxisTickIntervalSet(@5)
    .yAxisMinSet(@(0))//Y轴最小值
    .seriesSet(@[
                 AASeriesElement.new
                 .nameSet(@"")
                 .dataSet(@[]),
                 AASeriesElement.new
                 .nameSet(@"")
                 .dataSet(@[]),
                 AASeriesElement.new
                 .nameSet(@"人数")
                 .dataSet(@[model,posterCount]),
                 AASeriesElement.new
                 .nameSet(@"")
                 .dataSet(@[]),
                 AASeriesElement.new
                 .nameSet(@"")
                 .dataSet(@[]),
                 ]
               );
    [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
}



- (AAChartModel *)aaChartModel{
    if(!_aaChartModel){
        _aaChartModel= AAChartModel.new
        .yAxisAllowDecimalsSet(NO)//是否允许Y轴坐标值小数
        .chartTypeSet(AAChartTypeColumn)//图表类型
        .titleSet(@"")//图表主标题
        .subtitleSet(@"")//图表副标题
        .yAxisLineWidthSet(@0)//Y轴轴线线宽为0即是隐藏Y轴轴线
        .colorsThemeSet(@[@"#ff88a4"])//设置主体颜色数组
        .yAxisTitleSet(@"")//设置 Y 轴标题
        .backgroundColorSet(@"#ffffff")
        .yAxisGridLineWidthSet(@1)
        .seriesSet(@[
                     AASeriesElement.new
                     .nameSet(@"人数")
                     .dataSet(@[@0,@0])
                     .lineWidthSet(@10),
                     ]
                   );
        //y轴横向分割线宽度为0(即是隐藏分割线)
        _aaChartModel.categories = @[@"文章",@"海报"];//设置 X 轴坐标文字内容
        _aaChartModel.animationType = AAChartAnimationBounce;//图形的渲染动画为弹性动画
        _aaChartModel.yAxisTitle = @"";
        _aaChartModel.animationDuration = @10;//图形渲染动画时长为1200毫秒
        _aaChartModel.legendEnabled = NO;
        _aaChartModel.tooltipEnabled = NO;
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
