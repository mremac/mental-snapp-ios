//
//  UIFont+AppFont.m
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UIFont+Properties.h"

@implementation UIFont (AppFont)

+ (UIFont *)appFontWithMedium
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
}

+ (UIFont *)appFontBoldWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

+ (UIFont *)appFontWithBold
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
}

+ (UIFont *)appFontMediumWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
}

+ (UIFont *)appFontWithRegular
{
    return [self appFontDefault];
//    return [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0];
}

+ (UIFont *)appFontWithRegularWithSize:(CGFloat)fontSize
{
    return [self appFontWithDefaultWithSize:fontSize];
//    return [UIFont fontWithName:@"HelveticaNeue-Regular" size:fontSize];
}

+ (UIFont *)appFontDefault
{
    return [UIFont fontWithName:@"HelveticaNeue" size:12.0];
}

+ (UIFont *)appFontWithDefaultWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+ (UIFont *)appFontWithLight
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
}

+ (UIFont *)appFontLightWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIFont *)appFontLightItalicWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:fontSize];
}

+ (UIFont *)appFontWithThin
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:12.0];
}

+ (UIFont *)appFontThinWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:fontSize];
}

//@"HelveticaNeue-Thin"

@end
