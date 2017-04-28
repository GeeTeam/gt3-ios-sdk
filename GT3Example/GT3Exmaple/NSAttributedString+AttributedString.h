//
//  NSAttributedString+AttributedString.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

@import UIKit;

@interface NSAttributedString (AttributedString)

+ (NSAttributedString *)generate:(NSString *)aString fontSize:(CGFloat)fontSize color:(UIColor *)color;

@end
