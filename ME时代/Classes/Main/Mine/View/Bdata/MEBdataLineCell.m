//
//  MEBdataLineCell.m
//  志愿星
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBdataLineCell.h"
#import "AAChartKit.h"
#import "AAChartModel.h"
#import "MEBDataDealModel.h"

@interface MEBdataLineCell ()<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;

@end
@implementation MEBdataLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.aaChartView.backgroundColor = [UIColor whiteColor];
    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [self.aaChartView aa_drawChartWithChartModel:self.aaChartModel];
}

- (void)setUiWithTitleArr:(NSArray *)arr NumArr:(NSArray*)numArr{
    self.aaChartModel.categories = @[@"1~18岁", @"18~25岁", @"25~40岁", @"40~50岁"];
    NSMutableArray *arrModel = [NSMutableArray array];
    for (NSInteger i=0; i<arr.count; i++) {
        NSString *title = arr[i];
        NSArray *num = numArr[i];
        [arrModel addObject:AASeriesElement.new
         .nameSet(kMeUnNilStr(title))
         .dataSet(num)];
    }
    
    self.aaChartModel.seriesSet(arrModel);
    [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
}

- (AAChartModel *)aaChartModel{
    if(!_aaChartModel){
        _aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeLine)
        .titleFontSizeSet(@15)
        .titleSet(@"门店顾客各年龄段分析")
        .subtitleSet(@"")
        .yAxisTitleSet(@"")
        .colorsThemeSet(@[@"#F9553C",@"#24789D",@"#8C3F63",@"#ff88a4",@"#F9B43B",@"0F33CF"])//设置主体颜色数组
        ;
        _aaChartModel.categories = @[@"",@"",@"",@""];
        _aaChartModel.markerSymbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
        _aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
        _aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
        _aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
        _aaChartModel.subtitleAlign = AAChartSubtitleAlignTypeLeft;
        _aaChartModel.markerRadius = 0;
        _aaChartModel.legendEnabled = NO;
//        _aaChartModel.tooltipEnabled = NO;
    }
    return _aaChartModel;
}


#pragma mark -- AAChartView delegate
- (void)AAChartViewDidFinishLoad {
    NSLog(@"🔥🔥🔥🔥🔥 AAChartView content did finish load!!!");
}

@end
