//
//  TextField.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextField : UITextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType lengthLimit:(NSUInteger)length;

@end
