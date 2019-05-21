//
//  MESearchHistoryModel.m
//  ME时代
//
//  Created by hank on 2018/10/31.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESearchHistoryModel.h"

@implementation MESearchHistoryModel

+ (MESearchHistoryModel *)getSaveModel{
    MESearchHistoryModel *saveModel = [MESearchHistoryModel getObjctForKey:kMESearchHistoryModelPath path:TCodingPathDocument];
    if(!saveModel){
        saveModel = [MESearchHistoryModel new];
    }
    return saveModel;
}

+ (void)saveSearchHistory:(NSArray *)arrSearchHistory{
    MESearchHistoryModel *saveModel = [self getSaveModel];
    saveModel.arrSearchHistory = arrSearchHistory;
    [saveModel writeObjectForKey:kMESearchHistoryModelPath path:TCodingPathDocument];
    
}

+ (NSArray *)arrSearchHistory{
    MESearchHistoryModel *saveModel = [self getSaveModel];
    return kMeUnArr(saveModel.arrSearchHistory);
}

+ (void)saveSearchStoreHistory:(NSArray *)arrSearchStoreHistory{
    MESearchHistoryModel *saveModel = [self getSaveModel];
    saveModel.arrSearchStoreHistory = arrSearchStoreHistory;
    [saveModel writeObjectForKey:kMESearchHistoryModelPath path:TCodingPathDocument];
}

+ (NSArray *)arrSearchStoreHistory{
    MESearchHistoryModel *saveModel = [self getSaveModel];
    return kMeUnArr(saveModel.arrSearchStoreHistory);
}

- (NSArray *)arrSearchHistory{
    if(!_arrSearchHistory){
        _arrSearchHistory = [NSArray array];
    }
    return _arrSearchHistory;
}

- (NSArray *)arrSearchStoreHistory{
    if(!_arrSearchStoreHistory){
        _arrSearchStoreHistory = [NSArray array];
    }
    return _arrSearchStoreHistory;
}

@end
