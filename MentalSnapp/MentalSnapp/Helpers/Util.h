//
//  Util.h
//  Skeleton
//
//  Created by Systango on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S3Manager.h"

@interface Util : NSObject

+ (void)postNotification:(NSString *)name withDict:(NSDictionary *)dict;
+ (void)saveCustomObject:(id)object toUserDefaultsForKey:(NSString *)key;
+ (id)fetchCustomObjectForKey:(NSString *)key;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)validatePhone:(NSString *)phoneNumber;
- (UIImage *)didFinishPickingImageFile:(UIImage *)image fileType:(UploadFileType)fileType completionBlock:(completionBlock)block;
- (NSData *)didFinishPickingVideoFile:(NSData *)videoData fileType:(UploadFileType)fileType completionBlock:(completionBlock)block;
+ (BOOL)formatePhoneNumberOftextField:(UITextField *)textField withRange:(NSRange)range ReplacemenString:(NSString *)string;
+ (void)openCameraView:(id)target WithAnimation:(BOOL)animate;

@end
