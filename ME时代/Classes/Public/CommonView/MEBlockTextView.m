//
//  MEBlockTextView.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBlockTextView.h"

@interface MEBlockTextView()<UITextViewDelegate>

@end

@implementation MEBlockTextView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *text = kMeUnNilStr(textView.text);
//    if(text.length ==0){
//        return;
//    }
    kMeCallBlock(self.contentBlock,[text trimSpace]);
    
}

@end



