//
//  UIButton+VMButton.h
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (VMButton)

// this method call sdWebImage lib method internally
- (void)sd_setImageWithURLPath:(NSString *)urlPath;
- (void)sd_setImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state;
- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath;
- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state;
- (void)sd_setImageWithURLPath:(NSString *)urlPath placeholderImage:(UIImage *)placeholder;
- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath placeholderImage:(UIImage *)placeholder;
- (void)sd_setImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType;
- (void)sd_setImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType withBorderColor:(UIColor *)borderColor;
- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType;
- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType withBorderColor:(UIColor *)borderColor;
- (void)sd_setImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state forUserType:(BOOL)userType;
- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state forUserType:(BOOL)userType;
- (void)sd_imageWithURLPath:(NSString *)urlPath forState:(UIControlState)state forUserType:(BOOL)userType isBackgroundImage:(BOOL)isBackgroundImage placeholderImage:(UIImage *)placeholder withBorderColor:(UIColor *)borderColor;

// this method set ciular/rectangle image as per userType
- (void)setProfileImage:(UIImage *)profileImage userType:(BOOL)userType;

// common methods
- (void)highlightedEffect;
- (void)allowSingleTap;
- (void)setTextSpacingWithHighLightedBackground;
- (void)setInvertHighLightedBackground;
@end
