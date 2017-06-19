//
//  TipsView.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsView : UITextView <UITextViewDelegate>

+ (void)showTipOnKeyWindow:(NSString *)tip;
+ (void)showTipOnKeyWindow:(NSString *)tip fontSize:(CGFloat)size;

@end
