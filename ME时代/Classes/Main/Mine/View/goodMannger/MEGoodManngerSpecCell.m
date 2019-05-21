//
//  MEGoodManngerSpecCell.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEGoodManngerSpecCell.h"
#import "MEGoodManngerGoodSpec.h"

const static CGFloat MEGoodManngerSpecCellHeight = 27;
const static CGFloat MEGoodManngerSpecCellMargin = 10;
const static CGFloat MEGoodManngerSpecCellPadding = 30;

#define kMEGoodManngerSpecCellWdith (SCREEN_WIDTH - 30)
#define kMEGoodManngerSpecCellTitleFont kMeFont(15)

@interface MEGoodManngerSpecCell(){
    NSMutableArray *_arrBtn;
    NSMutableArray *_arrModel;
}

@end

@implementation MEGoodManngerSpecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrBtn = [NSMutableArray array];
}

- (void)setUIWihtArr:(NSArray *)arr{
    CGFloat allHeight = MEGoodManngerSpecCellMargin;
    _arrModel = [NSMutableArray arrayWithArray:arr];
    for (int i = 0; i < arr.count; i ++){
        MEGoodManngerGoodSpec *modelSpec = arr[i];
        static UIButton *recordbtn =nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = kMEGoodManngerSpecCellTitleFont;
        btn.titleLabel.textColor = kME333333;
        NSString *name = kMeUnNilStr(modelSpec.spec_name);
        [btn setTitle:name forState:UIControlStateNormal];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(kMEGoodManngerSpecCellWdith -(MEGoodManngerSpecCellMargin * 2), MEGoodManngerSpecCellHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kMEGoodManngerSpecCellTitleFont} context:nil];
        
        CGFloat BtnW = rect.size.width+MEGoodManngerSpecCellPadding;
        BtnW = BtnW>(kMEGoodManngerSpecCellWdith - (MEGoodManngerSpecCellMargin *2))?(kMEGoodManngerSpecCellWdith - (MEGoodManngerSpecCellMargin *2)):BtnW;
        
        CGFloat BtnH = MEGoodManngerSpecCellHeight;
        if (i == 0){
            btn.frame =CGRectMake(MEGoodManngerSpecCellMargin, allHeight, BtnW, BtnH);
        }else{
            //算出剩下的宽度
            CGFloat yuWidth = kMEGoodManngerSpecCellWdith - (MEGoodManngerSpecCellMargin*2) -recordbtn.frame.origin.x -recordbtn.frame.size.width;
            if (yuWidth >= BtnW) {
                //如果大于就放在同一行
                btn.frame =CGRectMake(recordbtn.frame.origin.x +recordbtn.frame.size.width + MEGoodManngerSpecCellMargin, recordbtn.frame.origin.y, BtnW, BtnH);
            }else{
                //如果不够就换行
                btn.frame =CGRectMake(MEGoodManngerSpecCellMargin, recordbtn.frame.origin.y+recordbtn.frame.size.height+MEGoodManngerSpecCellMargin, BtnW, BtnH);
            }
        }
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = kMeViewBaseTag+i;
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.borderWidth = 0.5;
        btn.cornerRadius = MEGoodManngerSpecCellHeight/2;
        btn .clipsToBounds = YES;
        if(modelSpec.isSelect){
            btn.borderColor = kMEPink;
            [btn setTitleColor:kME333333 forState:UIControlStateNormal];
        }else{
            btn.borderColor = kME999999;
            [btn setTitleColor:kME999999 forState:UIControlStateNormal];
        }
        [self addSubview:btn];
        [_arrBtn addObject:btn];
        recordbtn = btn;
    }
}

- (void)tapAction:(UIButton *)btn{
    NSInteger index = btn.tag - kMeViewBaseTag;
    MEGoodManngerGoodSpec *modelSpec = _arrModel[index];
    modelSpec.isSelect = !modelSpec.isSelect;
    if(modelSpec.isSelect){
        btn.borderColor = kMEPink;
        [btn setTitleColor:kME333333 forState:UIControlStateNormal];
        kMeCallBlock(_addBlock,modelSpec);

    }else{
        btn.borderColor = kME999999;
        [btn setTitleColor:kME999999 forState:UIControlStateNormal];
        kMeCallBlock(_divBlock,modelSpec);
    }
//    NSMutableArray *arr = [NSMutableArray array];
//    [_arrModel enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if(model.isSelect){
//            [arr addObject:model];
//        }
//    }];
}

+ (CGFloat)getCellHeightWithArr:(NSArray *)arr{
    CGFloat height = MEGoodManngerSpecCellMargin;
    if(kMeUnArr(arr).count){
        for (int i = 0; i < arr.count; i ++){
            MEGoodManngerGoodSpec *modelSpec = arr[i];
            static UIButton *recordbtn =nil;

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *name = kMeUnNilStr(modelSpec.spec_name);

        CGRect rect = [name boundingRectWithSize:CGSizeMake(kMEGoodManngerSpecCellWdith -(MEGoodManngerSpecCellMargin * 2), MEGoodManngerSpecCellHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kMEGoodManngerSpecCellTitleFont} context:nil];
            
            CGFloat BtnW = rect.size.width+MEGoodManngerSpecCellPadding;
            BtnW = BtnW>(kMEGoodManngerSpecCellWdith - (MEGoodManngerSpecCellMargin *2))?(kMEGoodManngerSpecCellWdith - (MEGoodManngerSpecCellMargin *2)):BtnW;
            
            CGFloat BtnH = MEGoodManngerSpecCellHeight;
            if (i == 0){
             btn.frame =CGRectMake(MEGoodManngerSpecCellMargin, height, BtnW, BtnH);
            }else{
                //算出剩下的宽度
                CGFloat yuWidth = kMEGoodManngerSpecCellWdith - (MEGoodManngerSpecCellMargin*2) -recordbtn.frame.origin.x -recordbtn.frame.size.width;
                if (yuWidth >= BtnW) {
                    //如果大于就放在同一行
                    btn.frame =CGRectMake(recordbtn.frame.origin.x +recordbtn.frame.size.width + MEGoodManngerSpecCellMargin, recordbtn.frame.origin.y, BtnW, BtnH);
                }else{
                    //如果不够就换行
                    btn.frame =CGRectMake(MEGoodManngerSpecCellMargin, recordbtn.frame.origin.y+recordbtn.frame.size.height+MEGoodManngerSpecCellMargin, BtnW, BtnH);
                }
            }
            height = CGRectGetMaxY(btn.frame)+MEGoodManngerSpecCellMargin;
            recordbtn = btn;
        }
    }
    return height;
}

@end
