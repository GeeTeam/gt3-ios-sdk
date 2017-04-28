//
//  TipsLabel.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "TipsLabel.h"
#import "NSAttributedString+AttributedString.h"

@implementation TipsLabel

- (instancetype)initWithFrame:(CGRect)frame tip:(NSString *)tip fontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        self.frame = CGRectMake(0, 0, 210, 70);
        self.text = tip;
        self.attributedText = [NSAttributedString generate:tip fontSize:size color:[UIColor whiteColor]];
        self.textColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        self.layer.cornerRadius = 5.0;
        self.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

+  (void)showTipOnKeyWindow:(NSString *)tip {
    TipsLabel *label = [[TipsLabel alloc] initWithFrame:CGRectZero tip:tip fontSize:14.0];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    label.center = window.center;
    [window addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

+  (void)showTipOnKeyWindow:(NSString *)tip fontSize:(CGFloat)size {
    TipsLabel *label = [[TipsLabel alloc] initWithFrame:CGRectZero tip:tip fontSize:size];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    label.center = window.center;
    [window addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

@end
