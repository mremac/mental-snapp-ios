//
//  S3Manager.h
//  MentalSnapp
//
//  Created by Systango on 22/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UploadFileType){
    OtherType,
    LogFileType,
    ImageProfile,
    VideoFileType
};

@interface S3Manager : NSObject

- (id)initWithFileURL:(NSURL *)fileURL s3Key:(NSString *)s3Key mediaUploadProgressBarView:(UIProgressView *)mediaUploadProgressBarView progressBarLabel:(UILabel *)progressBarLabel fileType:(UploadFileType)fileType contentLength:(NSNumber *)contentLength;

- (void)uploadFileToS3CompletionBlock:(completionBlock)block;

@end
