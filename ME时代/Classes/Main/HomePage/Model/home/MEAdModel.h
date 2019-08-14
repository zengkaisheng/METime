//
//  MEAdModel.h
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEAdModel : MEBaseModel

@property (nonatomic, strong) NSString * ad_id;
@property (nonatomic, strong) NSString * ad_name;
@property (nonatomic, strong) NSString * ad_img;
@property (nonatomic, assign) NSInteger ad_position_id;
@property (nonatomic, strong) NSString * ad_url;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * color_start;
@property (nonatomic, strong) NSString * color_end;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSInteger  is_need_login;
@property (nonatomic, strong) NSString * keywork;
@property (nonatomic, assign) NSInteger  show_type; //0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger show_level;
@property (nonatomic, strong) NSString * start_at;
@property (nonatomic, strong) NSString * end_at;
@property (nonatomic, assign) NSInteger tool;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger bargain_id;  //砍价活动
@property (nonatomic, assign) NSInteger activity_id; //签到活动

//在线课程相关
@property (nonatomic, assign) NSInteger audio_id;
@property (nonatomic, assign) NSInteger video_id;
@property (nonatomic, strong) NSString * createtime;

@end
