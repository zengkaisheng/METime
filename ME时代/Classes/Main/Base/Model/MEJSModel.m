//
//  MEJSModel.m
//  ME时代
//
//  Created by gao lei on 2019/6/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEJSModel.h"

@implementation MEJSModel

- (void)name:(NSString *)name Something:(NSString *)something
{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:name message:@"" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:action];
//    [self.VC presentViewController:alert animated:YES completion:nil];
    self.token = name;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token" message:self.token delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    });
}

- (void)test
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"试试" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self.VC presentViewController:alert animated:YES completion:nil];
}

@end
