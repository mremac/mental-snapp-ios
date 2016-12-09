//
//  UIImage+fixOrientation.m
//
//  Copyright © 2016 Systango. All rights reserved.
//

typedef void (^ScaleImageBlock)(UIImage *image);
@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (CGSize)getScaledSize:(CGSize)actualSize
{
    // To get proper scaling for Retina/Non-Retina display
    CGFloat width = actualSize.width * [UIScreen mainScreen].scale;
    CGFloat height = actualSize.height * [UIScreen mainScreen].scale;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor;
    
    if (oldWidth > oldHeight) {
        scaleFactor = width / oldWidth;
    } else {
        scaleFactor = height / oldHeight;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return newSize;
}

- (UIImage *)getScaledImage:(CGSize)size
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    CGSize newSize = [self getScaledSize:CGSizeMake(width, height)];
    return [self imageWithScaledToSize:newSize];
}

- (UIImage *)imageWithScaledToSize:(CGSize)size
{
    return [self getScaledImage:size];
}

- (void)imageWithScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height usingBlock:(ScaleImageBlock)block
{
    CGSize newSize = [self getScaledSize:CGSizeMake(width, height)];
    [self imageWithScaledToSize:newSize usingBlock:block];
}

- (void)imageWithScaledToSize:(CGSize)size  usingBlock:(ScaleImageBlock)block {
    UIImage *newImage = [self getScaledImage:size];
    block(newImage);
}

// Transform the image in grayscale.
- (UIImage*)convertImageToGrayScale
{
    // Create a graphic context.
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.size, YES, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(self.size);
    }
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [self drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize withPriority:(SizePriority)sizePriority
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        switch (sizePriority) {
            case PriorityNone:
            {
                if (widthFactor < heightFactor)
                    scaleFactor = widthFactor;
                else
                    scaleFactor = heightFactor;
            }
                break;
            case PriorityWidth:
            {
                scaleFactor = widthFactor;
            }
                break;
            case PriorityHeight:
            {
                scaleFactor = heightFactor;
            }
                break;
                
            default:
                break;
        }
        
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        switch (sizePriority) {
            case PriorityNone:
            {
                if (widthFactor < heightFactor) {
                    thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
                } else if (widthFactor > heightFactor) {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                }
            }
                break;
            case PriorityWidth:
            {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
                break;
            case PriorityHeight:
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
                break;
                
            default:
                break;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize
{
    return [self imageByScalingProportionallyToSize:targetSize withPriority:PriorityNone];
}

@end
