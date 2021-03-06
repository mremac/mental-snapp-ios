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
    ImageProfile,
    VideoThumbnailImageType,
    VideoFileType
};

@interface S3Manager : NSObject

- (id)initWithFileURL:(NSURL *)fileURL s3Key:(NSString *)s3Key mediaUploadProgressBarView:(UIProgressView *)mediaUploadProgressBarView progressBarLabel:(UILabel *)progressBarLabel fileType:(UploadFileType)fileType contentLength:(NSNumber *)contentLength;

- (void)uploadFileToS3CompletionBlock:(completionBlock)block;
- (void)downloadFileToS3CompletionBlock:(completionBlock)block;
-(void)cancelAllDownloads;
-(void)pauseAllDownloads;
-(void)resumeAllDownloads;
-(void) deleteObjectFromS3;

@end
