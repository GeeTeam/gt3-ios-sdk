//
//  TipsView.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "TipsView.h"
#import "NSAttributedString+AttributedString.h"

@implementation TipsView

- (instancetype)initWithFrame:(CGRect)frame tip:(NSString *)tip fontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
            self.frame = CGRectMake(0, 0, 210, 70);
            self.attributedText = [NSAttributedString generate:tip fontSize:size color:[UIColor whiteColor]];
            self.textColor = [UIColor whiteColor];
            [self setClipsToBounds:YES];
            self.layer.cornerRadius = 5.0;
            self.textAlignment = NSTextAlignmentCenter;
        });
    }
    
    return self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

+ (void)showTipOnKeyWindow:(NSString *)tip {
    TipsView *view = [[TipsView alloc] initWithFrame:CGRectZero tip:tip fontSize:14.0];
    
    [view layoutTipsView];
}

+ (void)showTipOnKeyWindow:(NSString *)tip fontSize:(CGFloat)size {
    TipsView *view = [[TipsView alloc] initWithFrame:CGRectZero tip:tip fontSize:size];
    
    [view layoutTipsView];
}

- (void)layoutTipsView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIControl *control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [control addTarget:self action:@selector(userDidTouchControl) forControlEvents:UIControlEventTouchUpInside];
        self.center = control.center;
        [control addSubview:self];
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        control.center = window.center;
        [window addSubview:control];
    });
}

- (void)userDidTouchControl {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIControl class]]) {
            [obj removeFromSuperview];
        }
    }];
}

@end
