//
//  UIFont+AppFont.h
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AppFont)

+ (UIFont *)appFontWithMedium;

+ (UIFont *)appFontMediumWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontWithRegular;

+ (UIFont *)appFontWithRegularWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontDefault;

+ (UIFont *)appFontWithDefaultWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontWithLight;

+ (UIFont *)appFontLightWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontLightItalicWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontWithThin;

+ (UIFont *)appFontThinWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontBoldWithSize:(CGFloat)fontSize;

+ (UIFont *)appFontWithBold;

@end
