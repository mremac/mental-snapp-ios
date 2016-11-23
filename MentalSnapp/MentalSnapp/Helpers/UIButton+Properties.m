//
//  UIButton+VMButton.m
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//
#import "UIButton+Properties.h"


@implementation UIButton (VMButton)

- (void)sd_setImageWithURLPath:(NSString *)urlPath
{
    [self sd_setImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:UIControlStateNormal];
}

- (void)sd_setImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state
{
    [self sd_setImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:state];
}

- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath
{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:UIControlStateNormal];
}

- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state
{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:state];
}

- (void)sd_setImageWithURLPath:(NSString *)urlPath placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:UIControlStateNormal placeholderImage:placeholder];
}

- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath placeholderImage:(UIImage *)placeholder
{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:UIControlStateNormal placeholderImage:placeholder];
}

- (void)sd_setImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType
{
    [self sd_imageWithURLPath:urlPath forState:UIControlStateNormal forUserType:userType isBackgroundImage:NO placeholderImage:nil withBorderColor:nil];
}

- (void)sd_setImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType withBorderColor:(UIColor *)borderColor
{
    [self sd_imageWithURLPath:urlPath forState:UIControlStateNormal forUserType:userType isBackgroundImage:NO placeholderImage:nil withBorderColor:borderColor];
}

- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType
{
    [self sd_imageWithURLPath:urlPath forState:UIControlStateNormal forUserType:userType isBackgroundImage:YES placeholderImage:nil withBorderColor:nil];
}

- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forUserType:(BOOL)userType withBorderColor:(UIColor *)borderColor
{
    [self sd_imageWithURLPath:urlPath forState:UIControlStateNormal forUserType:userType isBackgroundImage:YES placeholderImage:nil withBorderColor:borderColor];
}


- (void)sd_setImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state forUserType:(BOOL)userType
{
    [self sd_imageWithURLPath:urlPath forState:state forUserType:userType isBackgroundImage:NO placeholderImage:nil withBorderColor:nil];
}

- (void)sd_setBackgroundImageWithURLPath:(NSString *)urlPath forState:(UIControlState)state forUserType:(BOOL)userType
{
    [self sd_imageWithURLPath:urlPath forState:state forUserType:userType isBackgroundImage:YES placeholderImage:nil withBorderColor:nil];
}

- (void)sd_imageWithURLPath:(NSString *)urlPath forState:(UIControlState)state forUserType:(BOOL)userType isBackgroundImage:(BOOL)isBackgroundImage placeholderImage:(UIImage *)placeholder withBorderColor:(UIColor *)borderColor
{
   [self setBorderOnMainThread:userType withBorderColor:borderColor];
    if(urlPath)
    {
        [self sd_setImageWithURL:[NSURL URLWithEncodedString:urlPath] forState:state placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (image)
             {
                  [self setImageOnMainThread:image userType:userType isBackgroundImage:isBackgroundImage withState:state withBorderColor:borderColor];
                // [self setBorderOnMainThread:userType withBorderColor:borderColor];
             }
        }];
    }    
}

- (void)setBorderOnMainThread:(BOOL)userType withBorderColor:(UIColor *)borderColor
{
    [self setProfileOnMainThread:nil isImageRequired:NO userType:userType isBackgroundImage:NO withState:UIControlStateNormal withBorderColor:borderColor];
}

- (void)setImageOnMainThread:(UIImage *)image userType:(BOOL)userType isBackgroundImage:(BOOL)isBackgroundImage withState:(UIControlState)controlState withBorderColor:(UIColor *)borderColor
{
    [self setProfileOnMainThread:image isImageRequired:YES userType:userType isBackgroundImage:isBackgroundImage withState:controlState withBorderColor:borderColor];
}

- (void)setProfileOnMainThread:(UIImage *)image isImageRequired:(BOOL)isImageRequired userType:(BOOL)userType isBackgroundImage:(BOOL)isBackgroundImage withState:(UIControlState)controlState withBorderColor:(UIColor *)borderColor
{
    dispatch_main_sync_safe(^{
        if(isImageRequired)
        {
            if(isBackgroundImage)
                [self setBackgroundImage:image forState:controlState];
            else
                [self setImage:image forState:controlState];
        }
        
        if(borderColor)
        {
            self.layer.borderColor = [borderColor CGColor];
            self.layer.borderWidth = 1.0f;
        }        
        
        self.layer.cornerRadius = userType?0.0f:(self.bounds.size.width / 2.0);
        self.layer.masksToBounds = YES;
    });
}

- (void)setProfileImage:(UIImage *)profileImage userType:(BOOL)userType
{
    [self setImageOnMainThread:profileImage userType:userType isBackgroundImage:NO withState:UIControlStateNormal withBorderColor:nil];
}

- (void)highlightedEffect
{
    [self setHighlighted:YES];
    [self performSelector:@selector(resetPostButton) withObject:nil afterDelay:0.2];
}

- (void)resetPostButton
{
    [self setHighlighted:NO];
}

- (void)allowSingleTap
{
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(unFreezeButton) withObject:nil afterDelay:0.5];
}

- (void)unFreezeButton
{
    self.userInteractionEnabled = YES;
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setTextSpacingWithHighLightedBackground{
    
    NSAttributedString *attributedString =
    [[NSAttributedString alloc]
     initWithString:[self titleForState:UIControlStateNormal]
     attributes:
     @{
       NSFontAttributeName : self.titleLabel.font,
       NSForegroundColorAttributeName : [UIColor appOrangeColor],
       NSKernAttributeName : @(3.0f)
       }];
    
    NSAttributedString *attributedHighlightedString =
    [[NSAttributedString alloc]
     initWithString:[self titleForState:UIControlStateNormal]
     attributes:
     @{
       NSFontAttributeName : self.titleLabel.font,
       NSForegroundColorAttributeName : [UIColor whiteColor],
       NSKernAttributeName : @(3.0f)
       }];
    
    NSAttributedString *attributedDisabledString =
    [[NSAttributedString alloc]
     initWithString:[self titleForState:UIControlStateNormal]
     attributes:
     @{
       NSFontAttributeName : self.titleLabel.font,
       NSForegroundColorAttributeName : [UIColor lightGrayColor],
       NSKernAttributeName : @(3.0f)
       }];
    
    [self setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self setAttributedTitle:attributedHighlightedString forState:UIControlStateHighlighted];
    [self setAttributedTitle:attributedDisabledString forState:UIControlStateDisabled];
    
    [self setBackgroundImage:[self imageWithColor:[UIColor appOrangeColor]] forState:UIControlStateHighlighted];
}

- (void)setInvertHighLightedBackground{
    [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self setBackgroundImage:[self imageWithColor:[self titleColorForState:UIControlStateNormal]] forState:UIControlStateHighlighted];
}


@end
