//
//  UIImage+fixOrientation.h
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SizePriority) {
    PriorityNone,            // default priority
    PriorityWidth,
    PriorityHeight
};

typedef void (^ScaleImageBlock)(UIImage *image);

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

- (UIImage *)imageWithScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
- (UIImage *)imageWithScaledToSize:(CGSize)size;

- (void)imageWithScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height usingBlock:(ScaleImageBlock)block;
- (void)imageWithScaledToSize:(CGSize)size  usingBlock:(ScaleImageBlock)block;

- (UIImage*)convertImageToGrayScale;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize withPriority:(SizePriority)sizePriority;

@end
