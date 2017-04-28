//
//  NSAttributedString+AttributedString.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "NSAttributedString+AttributedString.h"

@implementation NSAttributedString (AttributedString)

+ (NSAttributedString *)generate:(NSString *)aString fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.paragraphSpacingBefore = 4.0;
    style.minimumLineHeight = 10.0;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:aString attributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : color}];
    
    return attrString;
}

@end
