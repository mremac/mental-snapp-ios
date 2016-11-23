//
//  UILabel+AppFontType.h
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AppFontType)

- (void)appFontWithMedium;

- (void)appFontWithRegular;

- (void)appFontWithRegularWithSize:(CGFloat)fontSize;

- (void)appFontMediumWithSize:(CGFloat)fontSize;

- (void)appFontWithLight;

- (void)appFontLightWithSize:(CGFloat)fontSize;

- (void)adjustFontSizeToFit;

- (CGFloat)getLabelWidth;

- (CGFloat)getLabelHeight;

- (CGFloat)defaultHeight;

- (CGRect)boundingRectForCharacterRange:(NSRange)range;

- (CGFloat)getLabelboundWidth;

- (CGFloat)getLabelAttributedTextboundWidth;

- (CGFloat)getLabelAtrributedTextHeight;

- (void)underline;

- (void)backgroundBlack;

- (CGSize)updateAppFontLightWithSize:(CGFloat)fontSize;

- (CGSize)updateFonts:(UIFont *)font;

@end
