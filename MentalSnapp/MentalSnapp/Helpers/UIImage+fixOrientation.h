//
//  UIImage+fixOrientation.h
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScaleImageBlock)(UIImage *image);

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

- (UIImage *)imageWithScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
- (UIImage *)imageWithScaledToSize:(CGSize)size;

- (void)imageWithScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height usingBlock:(ScaleImageBlock)block;
- (void)imageWithScaledToSize:(CGSize)size  usingBlock:(ScaleImageBlock)block;

- (UIImage*)convertImageToGrayScale;

@end