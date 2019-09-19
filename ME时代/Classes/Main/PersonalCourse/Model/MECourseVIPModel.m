//
//  MECourseVIPModel.m
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseVIPModel.h"

@implementation MECourseVIPDetailModel

MEModelIdToIdField

@end


@implementation MECourseVIPModel

MEModelObjectClassInArrayWithDic((@{@"vip" : [MECourseVIPDetailModel class]}))

- (CGFloat)ruleHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.vip_rule)] baseURL:nil];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    return height;
}

@end
