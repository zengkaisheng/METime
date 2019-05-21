//
//  TDWebViewCell.m
//  TDEarthVillage
//
//  Created by Hank on 2017/7/11.
//  Copyright © 2017年 Hank. All rights reserved.
//

#import "TDWebViewCell.h"

@interface TDWebViewCell()<UIWebViewDelegate>

@end

@implementation TDWebViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    // Initialization code
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    MEWebVIewImgAutoFit
    [[NSNotificationCenter defaultCenter] postNotificationName:kTDWebViewCellDidFinishLoad object:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTDWebViewCellDidFinishLoad object:nil];
}

@end
