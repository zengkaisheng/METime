//
//  ZLRefreshTool.h
//  我要留学
//
//  Created by Hank on 10/13/16.
//  Copyright © 2016 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLFailLoadView.h"


@protocol RefreshToolDelegate <NSObject>
//数据链接地址
- (NSDictionary *)requestParameter;
//返回响应数据
- (void)handleResponse:(id)data;

@optional
//返回错误信息
- (void)failureResponse:(NSError *)error;
@end

@interface ZLRefreshTool : NSObject

@property (nonatomic,weak) id <RefreshToolDelegate>delegate;
//刷新的view
@property (nonatomic,strong)UIScrollView *contentView;
//当前页索引 第几页
@property (nonatomic,assign) NSInteger pageIndex;
//表格数据数组
@property (nonatomic,strong) NSMutableArray *arrData;
//是否显示错误视图
@property (nonatomic,assign) BOOL showFailView;
//是否显示膜层视图
@property (nonatomic,assign) BOOL showMaskView;
//设置yes 用objec NO 为objects
//@property (nonatomic,assign) BOOL isNeedObject;
//总信息数
@property (nonatomic,assign) NSInteger allRows;
//接口地址
@property (nonatomic,copy) NSString *url;
//返回的所有参数
@property (nonatomic,copy) MENetListModel *response;
@property (nonatomic,copy) kMeBasicBlock blockRefresh;

@property (nonatomic, assign) BOOL errViewNotRefresh;

//每页的size值,默认为20
@property (nonatomic,assign) NSNumber *numOfsize;

@property (nonatomic,assign) BOOL isDataInside;
@property (nonatomic,assign) BOOL isCouple;//优惠卷搜索
@property (nonatomic,assign) BOOL isCoupleMater;//优惠卷物料搜索
@property (nonatomic,assign) BOOL isPinduoduoCoupleMater;//pinduoduo优惠卷物料搜索
@property (nonatomic,assign) BOOL isGet;


- (instancetype ) initWithContentView:(UIScrollView *)scrollView url:(NSString *)url;

- (void)setBlockEditFailVIew:(editFailLoadVIewBlock)blockEditFailVIew;

- (void)addHeadRefreshView;
- (void)addRefreshView;
- (void)addFooterRefreshView;

-(void)reload;



@end
