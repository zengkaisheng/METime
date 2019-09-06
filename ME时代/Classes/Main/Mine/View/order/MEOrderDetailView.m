//
//  MEOrderDetailView.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEOrderDetailView.h"
#import "MEOrderDetailModel.h"
//#import "MELogisticsVC.h"
#import "MEMyOrderDetailVC.h"
#import "MEAppointDetailModel.h"
//#import "MEOrderExpressDetailVC.h"
#import "MEOrderExpressDetailVC.h"
#import "ZLWebVC.h"

@interface MEOrderDetailView(){
    NSArray *_arrType;
    NSArray *_arrAppointType;
    MEOrderDetailModel *_modle;
}
@property (weak, nonatomic) IBOutlet UILabel *lblOrderStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIView *viewForLogist;
@property (weak, nonatomic) IBOutlet UILabel *lblLogist;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logistViewConsHeight;

@property (weak, nonatomic) IBOutlet UIView *topUpView;
@property (weak, nonatomic) IBOutlet UILabel *topUpStatusLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topUpViewConsHeight;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewConsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewConsBottom;

@end

@implementation MEOrderDetailView

- (void)awakeFromNib{
    [super awakeFromNib];
   _arrType = MEOrderStyleTitle;
    _arrAppointType = MEAppointmenyStyleTitle;
    _lblName.adjustsFontSizeToFitWidth = YES;
    _viewForLogist.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logistAction:)];
    [_viewForLogist addGestureRecognizer:ges];
    _topUpViewConsHeight.constant = 0.0;
    _topUpView.hidden = YES;
}

- (void)logistAction:(UITapGestureRecognizer *)ges{
    MEMyOrderDetailVC *orderVC = (MEMyOrderDetailVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyOrderDetailVC class] targetResponderView:self];
    if(orderVC){
        NSArray *arr = kMeUnArr(_modle.express_detail);
        if(arr.count==1){
            MEexpressDetailModel *detailmodel = [arr firstObject];
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                            (CFStringRef)kMeUnNilStr(detailmodel.express_url),(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
            ZLWebVC *vc = [[ZLWebVC alloc]initWithUrl:encodedString];
            vc.title = @"物流信息";
            [orderVC.navigationController pushViewController:vc animated:YES];
        }else if(arr.count>1){
            MEOrderExpressDetailVC *logistVC = [[MEOrderExpressDetailVC alloc]initWithModel:_modle];
            [orderVC.navigationController pushViewController:logistVC animated:YES];
        }else{
            
        }
    }
}

- (void)setUIWithModel:(MEOrderDetailModel *)model orderType:(MEOrderStyle)type{
    _modle = model;
//    if(type == MEAllNeedReceivedOrder || type == MEAllFinishOrder){
        _viewForLogist.hidden = NO;
        _viewForLogist.userInteractionEnabled = YES;
//        MELogistModel *lmodel = model.logistics;
        NSArray *arr = kMeUnArr(model.express_detail);
        if(arr.count>0){
            _viewForLogist.hidden = NO;
            _logistViewConsHeight.constant = 72.0;
            _viewForLogist.userInteractionEnabled = YES;
//            MELogistDataModel *ldModel = [lmodel.data firstObject];
            _lblLogist.text = @"查看物流";
        }else{
//            _lblLogist.text = @"暂无快递信息";
            _logistViewConsHeight.constant = 0.0;
            _viewForLogist.hidden = YES;
            _viewForLogist.userInteractionEnabled = NO;
        }
//    }else{
//        _viewForLogist.hidden = YES;
//        _viewForLogist.userInteractionEnabled = NO;
//    }
//    _lblOrderStatus.text = [NSString stringWithFormat:@"订单%@",_arrType[type]];
    _lblOrderStatus.text = [NSString stringWithFormat:@"订单%@",kMeUnNilStr(model.order_status_name)];

    _lblOrderNum.text = [NSString stringWithFormat:@"订单编号:%@",kMeUnNilStr(model.order_sn)];
    _lblName.text = kMeUnNilStr(model.address.name);
    _lblPhone.text = kMeUnNilStr(model.address.mobile);
    _lblCreatTime.text = [NSString stringWithFormat:@"创建时间:%@",kMeUnNilStr(model.created_at)];;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.address.province_id),kMeUnNilStr(model.address.city_id),kMeUnNilStr(model.address.area_id),kMeUnNilStr(model.address.detail)];
    _lblAddress.text  = address;
    
    if (model.order_type == 17) {
        if (model.isTopUp) {
            _logistViewConsHeight.constant = 0.0;
            _viewForLogist.hidden = YES;
            _viewForLogist.userInteractionEnabled = NO;
            _lblOrderStatus.text = kMeUnNilStr(model.top_up_status_name);
            
            _addressViewConsHeight.constant = 0.0;
            _addressViewConsBottom.constant = 0.0;
            _addressView.hidden = YES;
        }else {
            _addressViewConsHeight.constant = 72.0;
            _addressViewConsBottom.constant = 10.0;
            _addressView.hidden = NO;
        }
        if ([model.order_status integerValue] == MEAllNeedPayOrder || [model.order_status integerValue] == MEAllCancelOrder) {
            _topUpViewConsHeight.constant = 0.0;
            _topUpView.hidden = YES;
        }else {
            _topUpView.hidden = NO;
            _topUpViewConsHeight.constant = 68.0;
            if (kMeUnNilStr(model.top_up_status_name)) {
                _topUpStatusLbl.text = kMeUnNilStr(model.top_up_status_name);
            }
        }
    }else {
        _topUpView.hidden = YES;
        _topUpViewConsHeight.constant = 0.0;
    }
}

- (void)setAppointUIWithModel:(MEAppointDetailModel *)model orderType:(MEAppointmenyStyle)type{
    _viewForLogist.hidden = YES;
    _viewForLogist.userInteractionEnabled = NO;
    _lblOrderStatus.text = [NSString stringWithFormat:@"订单%@",_arrAppointType[type]];
    
//    _lblOrderNum.text = kMeUnNilStr(model.reserve_sn);
    _lblOrderNum.text = [NSString stringWithFormat:@"订单编号:%@",kMeUnNilStr(model.reserve_sn)];
    _lblCreatTime.text = [NSString stringWithFormat:@"创建时间:%@",kMeUnNilStr(model.created_at)];;
    _lblName.text = kMeUnNilStr(model.true_name);
    _lblPhone.text = kMeUnNilStr(model.cellphone);
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
    _lblAddress.text  = address;
}

+ (CGFloat)getViewHeightWithType:(MEOrderStyle)type Model:(MEOrderDetailModel *)model{
    NSArray *arr = kMeUnArr(model.express_detail);
    if(arr.count>0){
        if (model.order_type == 17) {
            if (model.isTopUp) {
                return kMEOrderDetailViewHeight+kMEOrderDetailViewTopUpHeight-82;
            }else {
                if (model.order_status.integerValue == MEAllNeedPayOrder || [model.order_status integerValue] == MEAllCancelOrder) {
                    return kMEOrderDetailViewHeight+kMEOrderDetailViewLogistHeight;
                }
                return kMEOrderDetailViewHeight+kMEOrderDetailViewLogistHeight+kMEOrderDetailViewTopUpHeight;
            }
        }
        return kMEOrderDetailViewHeight + kMEOrderDetailViewLogistHeight;
    }else{
        if (model.order_type == 17) {
            if (model.isTopUp) {
                return kMEOrderDetailViewHeight+kMEOrderDetailViewTopUpHeight-82;
            }else {
                if (model.order_status.integerValue == MEAllNeedPayOrder || [model.order_status integerValue] == MEAllCancelOrder) {
                    return kMEOrderDetailViewHeight;
                }
                return kMEOrderDetailViewHeight+kMEOrderDetailViewTopUpHeight;
            }
        }
        return kMEOrderDetailViewHeight;
    }
}

- (IBAction)topUpAction:(id)sender {
    kMeCallBlock(self.topUpBlock);
}

@end
