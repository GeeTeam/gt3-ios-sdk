//
//  TextField.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "TextField.h"
#import "TipsView.h"

@interface TextField () <UITextFieldDelegate>

@property (nonatomic, assign) NSUInteger lengthLimit;

@end

@implementation TextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType lengthLimit:(NSUInteger)length {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _init];
        
        NSString *textString = placeholder ? placeholder : @"字符";
        self.attributedPlaceholder = [self createAttrString:textString];
        self.keyboardType = keyboardType ? keyboardType : UIKeyboardTypeDefault;
        _lengthLimit = length ? length : 30;
    }
    
    return self;
}

- (void)_init {
    
    self.delegate = self;
    
    [self setClipsToBounds:YES];
    self.layer.cornerRadius = 2.0;
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}

- (NSAttributedString *)createAttrString:(NSString *)aString {
    UIFont *font = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - font.lineHeight) / 2.0;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:aString attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0], NSBaselineOffsetAttributeName : @4.0}];
    
    return attrString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        if (textField.text.length == 8) {
            [textField resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField.text.length == 0 || [textField.text isEqualToString:textField.placeholder]) {
        [TipsView showTipOnKeyWindow:[NSString stringWithFormat:@"请输入正确的%@", textField.attributedPlaceholder.string]];
        return NO;
    }
    else if (textField.text.length < 8) {
        [TipsView showTipOnKeyWindow:[NSString stringWithFormat:@"请输入正确的%@", textField.attributedPlaceholder.string]];
        return NO;
    }
    else if (textField.text.length < self.lengthLimit) {
        
        return YES;
    }
    else {
        [TipsView showTipOnKeyWindow:[NSString stringWithFormat:@"请输入正确的%@", textField.attributedPlaceholder.string]];
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
