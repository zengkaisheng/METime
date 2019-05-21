//
//  MEShoppingCartAttrModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//  加入购物车参数model

#import "MEBaseModel.h"

@class MEGoodDetailModel;
/*
 token    是    string    登陆后返回的token
 goodsId    是    int    商品ID
 goodsNum    是    int    商品数量
 userid    是    int    用户ID
 specId    是    int    属性ID，来源于商品详情返回的属性ID
 store_id    是    int    门店ID，门店ID写死，主小程序的值为1，其他子小程序在创建的时候就写死依次2,3,4,5
 */

@interface MEShoppingCartAttrModel : MEBaseModel

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger goodsNum;
//@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, assign) NSInteger specId;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger type;
//来自好友的分享
@property (nonatomic, copy) NSString *uid;
- (instancetype)initWithGoodmodel:(MEGoodDetailModel *)model;

@end
