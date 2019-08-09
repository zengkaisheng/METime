//
//  MEShareCouponVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEShareCouponVC.h"
#import "MECoupleModel.h"
#import "MEPinduoduoCoupleInfoModel.h"
#import "MEJDCoupleModel.h"
#import "ZLWebViewVC.h"

@interface MEShareCouponVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *couponLbl;
@property (weak, nonatomic) IBOutlet UILabel *commissionLbl;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissionWidthCons;

@property (nonatomic, strong) MECoupleModel *tbModel;;
@property (nonatomic, strong) MEPinduoduoCoupleInfoModel *pddModel;
@property (nonatomic, strong) MEJDCoupleModel *jdModel;
@property (nonatomic, copy) NSString *codeword;

@end

@implementation MEShareCouponVC

- (instancetype)initWithTBModel:(MECoupleModel *)model  codeword:(NSString *)codeword{
    if (self = [super init]) {
        self.tbModel = model;
        self.codeword = codeword;
    }
    return self;
}

- (instancetype)initWithPDDModel:(MEPinduoduoCoupleInfoModel *)model  codeword:(NSString *)codeword{
    if (self = [super init]) {
        self.pddModel = model;
        self.codeword = codeword;
    }
    return self;
}

- (instancetype)initWithJDModel:(MEJDCoupleModel *)model  codeword:(NSString *)codeword{
    if (self = [super init]) {
        self.jdModel = model;
        self.codeword = codeword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品分享";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    _imageTopCons.constant += kMeNavBarHeight;
    _textView.editable = NO;
    
    if (self.tbModel) {
        [self setUIWithModel:self.tbModel];
    }else if (self.pddModel) {
        [self setPinduoduoUIWithModel:self.pddModel];
    }else if (self.jdModel) {
        [self setJDUIWithModel:self.jdModel];
    }
}

- (void)setUIWithModel:(MECoupleModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.pict_url));
    _titleLbl.text = kMeUnNilStr(model.title);
    _appIcon.image = [UIImage imageNamed:@"icon_taobao"];
    //原价
    [_originalPriceLbl setLineStrWithStr:[NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.zk_final_price).floatValue)]];
    //卷后价
    _priceLbl.text = [NSString stringWithFormat:@"¥%.2f",kMeUnNilStr(model.truePrice).floatValue];
    //卷价格
    _couponLbl.text = [NSString stringWithFormat:@"%@元券",kMeUnNilStr(model.couponPrice)];
    _commissionLbl.text = [NSString stringWithFormat:@"预估佣金￥%.2f",model.min_ratio];
    _countLbl.text = [NSString stringWithFormat:@"%@人已买",kMeUnNilStr(model.volume).length>0?kMeUnNilStr(model.volume):@"0"];
    
    CGFloat width = [_couponLbl.text boundingRectWithSize:CGSizeMake(300, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    _couponWidthCons.constant = width+6;
    width = [_commissionLbl.text boundingRectWithSize:CGSizeMake(300, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    _commissionWidthCons.constant = width+6;
    
    _textView.text = [NSString stringWithFormat:@"%@\n【价格】%@元\n【券后价】%.2f元\n%@\n复制邀请码：%@\n下载APP：https://a.app.qq.com/o/simple.jsp?pkgname=com.times.metimes领取更多优惠",model.title,@(kMeUnNilStr(model.zk_final_price).floatValue),kMeUnNilStr(model.truePrice).floatValue,self.codeword,kMeUnNilStr(kCurrentUser.invite_code)];
}

- (void)setPinduoduoUIWithModel:(MEPinduoduoCoupleInfoModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.goods_thumbnail_url));
    _titleLbl.text = kMeUnNilStr(model.goods_name);
    _appIcon.image = [UIImage imageNamed:@"icon_pingduoduo"];
    //原价
//    [_originalPriceLbl setLineStrWithStr:[NSString stringWithFormat:@"¥%@",[MECommonTool changeformatterWithFen:@(model.min_group_price)]]];
    [_originalPriceLbl setLineStrWithStr:[NSString stringWithFormat:@"¥%@",[MECommonTool changeformatterWithFen:@(model.min_group_price)]]];
    //卷后价
    _priceLbl.text = [NSString stringWithFormat:@"¥%@",[MECommonTool changeformatterWithFen:@(model.min_group_price-model.coupon_discount)]];
    //卷价格
    _couponLbl.text =[NSString stringWithFormat:@"%@元券",[MECommonTool changeformatterWithFen:@(model.coupon_discount)]];
    
    _countLbl.text = [NSString stringWithFormat:@"%@人已买",kMeUnNilStr(model.sales_tip).length>0?kMeUnNilStr(model.sales_tip):@"0"];
    _commissionLbl.text = [NSString stringWithFormat:@"预估佣金￥%@",[MECommonTool changeformatterWithFen:@(model.min_ratio)]];
    
    CGFloat width = [_couponLbl.text boundingRectWithSize:CGSizeMake(300, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    _couponWidthCons.constant = width+6;
    width = [_commissionLbl.text boundingRectWithSize:CGSizeMake(300, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    _commissionWidthCons.constant = width+6;
    _textView.text = [NSString stringWithFormat:@"%@\n【价格】%@元\n【券后价】%@元\n领券地址：%@\n复制邀请码：%@\n下载APP：https://a.app.qq.com/o/simple.jsp?pkgname=com.times.metimes领取更多优惠",model.goods_name,[MECommonTool changeformatterWithFen:@(model.min_group_price)],[MECommonTool changeformatterWithFen:@(model.min_group_price-model.coupon_discount)],self.codeword,kMeUnNilStr(kCurrentUser.invite_code)];
}

- (void)setJDUIWithModel:(MEJDCoupleModel *)model{
    NSString *str = @"";
    if(kMeUnArr(model.imageInfo.imageList).count>0){
        ImageContentInfo *imageInfo = model.imageInfo.imageList[0];
        str = kMeUnNilStr(imageInfo.url);
    }
    kSDLoadImg(_imgPic, str);
    _titleLbl.text = kMeUnNilStr(model.skuName);
    _appIcon.image = [UIImage imageNamed:@"icon_jingdong"];
    //原价
//    _originalPriceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.priceInfo.price)];
    [_originalPriceLbl setLineStrWithStr:[NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.priceInfo.price)]];
    CouponContentInfo *couponInfoModel = [CouponContentInfo new];
    if(kMeUnArr(model.couponInfo.couponList).count>0){
        couponInfoModel = model.couponInfo.couponList[0];
    }
    ////卷后价
    CGFloat oPrice = [kMeUnNilStr(model.priceInfo.price) floatValue];
    CGFloat dPrice = [kMeUnNilStr(couponInfoModel.discount) floatValue];
    CGFloat price =  oPrice- dPrice;
    if(price<0){
        price = 0;
    }
    NSString *strPrice = [NSString stringWithFormat:@"%.2f",price];
    _priceLbl.text =[NSString stringWithFormat:@"¥%@",strPrice];
    //卷价格
    _couponLbl.text =[NSString stringWithFormat:@"%@元券",kMeUnNilStr(couponInfoModel.discount)];
    _countLbl.text = [NSString stringWithFormat:@"%@人评论",kMeUnNilStr(model.comments).length>0?kMeUnNilStr(model.comments):@"0"];
    _commissionLbl.text = [NSString stringWithFormat:@"预估佣金￥%.2f",price*model.commissionInfo.commissionShare/100* model.percent];
    
    CGFloat width = [_couponLbl.text boundingRectWithSize:CGSizeMake(300, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    _couponWidthCons.constant = width+6;
    width = [_commissionLbl.text boundingRectWithSize:CGSizeMake(300, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    _commissionWidthCons.constant = width+6;
    
    _textView.text = [NSString stringWithFormat:@"%@\n【价格】%@元\n【券后价】%@元\n领券地址：%@\n复制邀请码：%@\n下载APP：https://a.app.qq.com/o/simple.jsp?pkgname=com.times.metimes领取更多优惠",model.skuName,kMeUnNilStr(model.priceInfo.price),strPrice,self.codeword,kMeUnNilStr(kCurrentUser.invite_code)];
}

- (IBAction)copyContentAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kMeUnNilStr(_textView.text);
    [MEShowViewTool showMessage:@"复制成功,请发给朋友" view:self.view];
}
- (IBAction)shareToWeChatAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kMeUnNilStr(_textView.text);

    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    
    if (self.tbModel) {
        //https://test.meshidai.com/shopShare/newAuth.html
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@shopShare/newAuth.html?name=%@&price=%.2f&oprice=%@&type=1&image=%@&url=%@&command=%@&discount=%@",baseUrl,kMeUnNilStr(self.tbModel.title),kMeUnNilStr(self.tbModel.truePrice).floatValue,@(kMeUnNilStr(self.tbModel.zk_final_price).floatValue),kMeUnNilStr(self.tbModel.pict_url),kMeUnNilStr(self.codeword),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" ",kMeUnNilStr(self.tbModel.couponPrice)];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.tbModel.title;
        shareTool.shareDescriptionBody = self.tbModel.title;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.tbModel.pict_url)]]];
        
    }else if (self.pddModel) {
        //https://test.meshidai.com/shopShare/newAuth.html
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@shopShare/newAuth.html?name=%@&price=%@&oprice=%@&type=2&image=%@&url=%@&command=%@&discount=%@",baseUrl,kMeUnNilStr(self.pddModel.goods_name),[MECommonTool changeformatterWithFen:@(self.pddModel.min_group_price-self.pddModel.coupon_discount)],[MECommonTool changeformatterWithFen:@(self.pddModel.min_group_price)],kMeUnNilStr(self.pddModel.goods_thumbnail_url),kMeUnNilStr(self.codeword),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" ",[MECommonTool changeformatterWithFen:@(self.pddModel.coupon_discount)]];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.pddModel.goods_name;
        shareTool.shareDescriptionBody = self.pddModel.goods_name;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.pddModel.goods_thumbnail_url)]]];
        
    }else if (self.jdModel) {
        CouponContentInfo *couponInfoModel = [CouponContentInfo new];
        if(kMeUnArr(self.jdModel.couponInfo.couponList).count>0){
            couponInfoModel = self.jdModel.couponInfo.couponList[0];
        }
        ////卷后价
        CGFloat oPrice = [kMeUnNilStr(self.jdModel.priceInfo.price) floatValue];
        CGFloat dPrice = [kMeUnNilStr(couponInfoModel.discount) floatValue];
        CGFloat price =  oPrice- dPrice;
        if(price<0){
            price = 0;
        }
        NSString *strPrice = [NSString stringWithFormat:@"%.2f",price];
        
        NSString *str = @"";
        if(kMeUnArr(self.jdModel.imageInfo.imageList).count>0){
            ImageContentInfo *imageInfo = self.jdModel.imageInfo.imageList[0];
            str = kMeUnNilStr(imageInfo.url);
        }
        
        //https://test.meshidai.com/shopShare/newAuth.html
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@shopShare/newAuth.html?name=%@&price=%@&oprice=%.2f&type=3&image=%@&url=%@&command=%@&discount=%@",baseUrl,kMeUnNilStr(self.jdModel.skuName),strPrice,oPrice,str,kMeUnNilStr(self.codeword),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" ",kMeUnNilStr(couponInfoModel.discount)];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.jdModel.skuName;
        shareTool.shareDescriptionBody = self.jdModel.skuName;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
    }
    
    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession success:^(id data) {
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}
- (IBAction)shareToTimeLineAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kMeUnNilStr(_textView.text);
    
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    
    if (self.tbModel) {
        //https://test.meshidai.com/shopShare/newAuth.html
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@shopShare/newAuth.html?name=%@&price=%.2f&oprice=%@&type=1&image=%@&url=%@&command=%@&discount=%@",baseUrl,kMeUnNilStr(self.tbModel.title),kMeUnNilStr(self.tbModel.truePrice).floatValue,@(kMeUnNilStr(self.tbModel.zk_final_price).floatValue),kMeUnNilStr(self.tbModel.pict_url),kMeUnNilStr(self.codeword),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" ",kMeUnNilStr(self.tbModel.couponPrice)];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.tbModel.title;
        shareTool.shareDescriptionBody = self.tbModel.title;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.tbModel.pict_url)]]];
        
    }else if (self.pddModel) {
        //https://test.meshidai.com/shopShare/newAuth.html
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@shopShare/newAuth.html?name=%@&price=%@&oprice=%@&type=2&image=%@&url=%@&command=%@&discount=%@",baseUrl,kMeUnNilStr(self.pddModel.goods_name),[MECommonTool changeformatterWithFen:@(self.pddModel.min_group_price-self.pddModel.coupon_discount)],[MECommonTool changeformatterWithFen:@(self.pddModel.min_group_price)],kMeUnNilStr(self.pddModel.goods_thumbnail_url),kMeUnNilStr(self.codeword),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" ",[MECommonTool changeformatterWithFen:@(self.pddModel.coupon_discount)]];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.pddModel.goods_name;
        shareTool.shareDescriptionBody = self.pddModel.goods_name;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.pddModel.goods_thumbnail_url)]]];
        
    }else if (self.jdModel) {
        CouponContentInfo *couponInfoModel = [CouponContentInfo new];
        if(kMeUnArr(self.jdModel.couponInfo.couponList).count>0){
            couponInfoModel = self.jdModel.couponInfo.couponList[0];
        }
        ////卷后价
        CGFloat oPrice = [kMeUnNilStr(self.jdModel.priceInfo.price) floatValue];
        CGFloat dPrice = [kMeUnNilStr(couponInfoModel.discount) floatValue];
        CGFloat price =  oPrice- dPrice;
        if(price<0){
            price = 0;
        }
        NSString *strPrice = [NSString stringWithFormat:@"%.2f",price];
        
        NSString *str = @"";
        if(kMeUnArr(self.jdModel.imageInfo.imageList).count>0){
            ImageContentInfo *imageInfo = self.jdModel.imageInfo.imageList[0];
            str = kMeUnNilStr(imageInfo.url);
        }
        
        //https://test.meshidai.com/shopShare/newAuth.html
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@shopShare/newAuth.html?name=%@&price=%@&oprice=%.2f&type=3&image=%@&url=%@&command=%@&discount=%@",baseUrl,kMeUnNilStr(self.jdModel.skuName),strPrice,oPrice,str,kMeUnNilStr(self.codeword),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" ",kMeUnNilStr(couponInfoModel.discount)];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.jdModel.skuName;
        shareTool.shareDescriptionBody = self.jdModel.skuName;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
    
    }
    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine success:^(id data) {
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}


@end
