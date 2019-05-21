//
//  MEBStoreMannagerEditModel.m
//  ME时代
//
//  Created by hank on 2019/2/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBStoreMannagerEditModel.h"
#import "MEBStoreMannagerModel.h"

@implementation MEBStoreMannagerEditModel

+ (MEBStoreMannagerEditModel *)editModelWIthModel:(MEBStoreMannagerModel *)model{
    MEBStoreMannagerEditModel *editmodel = [MEBStoreMannagerEditModel new];
    editmodel.token = kMeUnNilStr(kCurrentUser.token);
    editmodel.store_name = kMeUnNilStr(model.store_name);
    editmodel.mobile = kMeUnNilStr(model.mobile);
    editmodel.id_number = kMeUnNilStr(model.id_number);
    editmodel.intro = kMeUnNilStr(model.intro);
    editmodel.address = kMeUnNilStr(model.address);
    editmodel.province = kMeUnNilStr(model.province);
    editmodel.city = kMeUnNilStr(model.city);
    editmodel.district = kMeUnNilStr(model.district);
    editmodel.latitude = kMeUnNilStr(model.latitude);
    editmodel.longitude = kMeUnNilStr(model.longitude);
    return editmodel;
}
@end
