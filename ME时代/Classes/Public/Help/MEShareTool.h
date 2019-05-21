//
//  MEShareTool.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 用来标识分享内容的类型，各类型对应的值如下
 网页分享 ：1
 分享文本 ：2
 分享图片 ：3
 分享图片和文字 ：4
 */
typedef NS_ENUM(NSUInteger, kShareContentType) {
    kShareWebPageContentType = 1,
    kShareTextContentType = 2,
    kShareImageContentType = 3,
    kShareImageAndTextContentType = 4,
};

@interface MEShareTool : NSObject
@property (copy ,nonatomic) NSString *shareTitle;
@property (copy ,nonatomic) NSString *shareDescriptionBody;
@property (copy ,nonatomic) NSString *sharWebpageUrl;
@property (strong ,nonatomic) UIImage *shareImage;
@property (strong ,nonatomic) NSString *shareImgUrl;

@property (strong ,nonatomic) NSString *posterId;
@property (strong ,nonatomic) NSString *articelId;
//调用面板
- (void)showShareView:(kShareContentType)type success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//图片分享
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
