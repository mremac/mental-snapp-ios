//
//  S3Manager.m
//  MentalSnapp
//
//  Created by Systango on 22/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "S3Manager.h"
#import <AWSS3/AWSS3.h>
#import <AVFoundation/AVFoundation.h>

@interface S3Manager()

@property (nonatomic, strong) UIProgressView *mediaUploadProgressBarView;
@property (nonatomic, strong) UILabel *progressBarLabel;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSString * s3Key;
@property (nonatomic, assign) UploadFileType fileType;
@property (nonnull, strong) NSNumber *contentLength;

@end

@implementation S3Manager

- (id)initWithFileURL:(NSURL *)fileURL s3Key:(NSString *)s3Key mediaUploadProgressBarView:(UIProgressView *)mediaUploadProgressBarView progressBarLabel:(UILabel *)progressBarLabel fileType:(UploadFileType)fileType contentLength:(NSNumber *)contentLength
{
    self = [super init];
    if(self)
    {
        _fileURL = fileURL;
        _s3Key = s3Key;
        _mediaUploadProgressBarView = mediaUploadProgressBarView;
        _fileType = fileType;
        _progressBarLabel = progressBarLabel;
        _contentLength = contentLength;
    }
    
    return self;
}

- (void)uploadFileToS3CompletionBlock:(completionBlock)block
{
    AppSettings *appSettings = [AppSettingsManager sharedInstance].appSettings;
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    NSString *bucketName = kEmptyString;
    
    if (self.fileType == VideoFileType)
    {
        bucketName = ([appSettings.NetworkMode isEqualToString:kLiveEnviroment]) ? kLiveVideoBucket : kStagingVideoBucket;
    }
    else if (self.fileType == ImageProfile)
    {
        bucketName = ([appSettings.NetworkMode isEqualToString:kLiveEnviroment]) ? kLiveProfileImageBucket : kStagingProfileImageBucket;
    }
    
    uploadRequest.key = self.s3Key;
    uploadRequest.body = self.fileURL;
    uploadRequest.bucket = bucketName;
    uploadRequest.contentLength = self.contentLength;
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    
    [[SMobiLogger sharedInterface] info:@"Started uploading file to S3." withDescription:[NSString stringWithFormat:@"At: %s, \n(URL: %@). \n  \n", __FUNCTION__, [NSString stringWithFormat:@"%@/%@", uploadRequest.bucket, uploadRequest.key]]];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    uploadRequest.uploadProgress =  ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update progress.
            [weakSelf uploadProgress:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        });
    };
    
    [self.mediaUploadProgressBarView setProgress:0];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                       withBlock:^id(AWSTask *task) {
                                                           if (task.error)
                                                           {
                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                   switch (task.error.code) {
                                                                       case AWSS3TransferManagerErrorCancelled:
                                                                       case AWSS3TransferManagerErrorPaused:
                                                                           break;
                                                                           
                                                                       default:
                                                                           [[SMobiLogger sharedInterface] error:@"Failed uploading file to S3." withDescription:[NSString stringWithFormat:@"At: %s, \n(URL: %@) \n[Error: %@]. \n  \n", __FUNCTION__, [NSString stringWithFormat:@"%@/%@", uploadRequest.bucket, uploadRequest.key], task.error]];
                                                                           NSLog([NSString stringWithFormat:@"Error: %@", task.error ]);
                                                                           break;
                                                                   }
                                                               } else {
                                                                   // Unknown error.
                                                                   NSLog([NSString stringWithFormat:@"Error: %@", task.error ]);
                                                                   
                                                                   [[SMobiLogger sharedInterface] error:@"Failed uploading file to S3." withDescription:[NSString stringWithFormat:@"At: %s, \n(URL: %@) \n[Error: %@]. \n  \n", __FUNCTION__, [NSString stringWithFormat:@"%@/%@", uploadRequest.bucket, uploadRequest.key], task.error]];
                                                               }
                                                               
                                                               block (NO, nil);
                                                               return nil;
                                                           }
                                                           else if (task.result)
                                                           {
                                                               NSLog(@"Upload completed");
                                                               self.progressBarLabel.hidden = YES;
                                                               self.mediaUploadProgressBarView.hidden = YES;
                                                           }
                                                           
                                                           [[SMobiLogger sharedInterface] info:@"Successfully uploaded file to S3." withDescription:[NSString stringWithFormat:@"At: %s, \n(URL: %@). \n  \n", __FUNCTION__, [NSString stringWithFormat:@"%@/%@", uploadRequest.bucket, uploadRequest.key]]];
                                                           
                                                           block (YES, uploadRequest.key);
                                                           
                                                           return nil;
                                                       }];
    
}

- (void)uploadProgress:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    self.progressBarLabel.text = [NSString stringWithFormat:@"%.0f%%", ((float)totalBytesSent/(float)totalBytesExpectedToSend)*100];
    [self.mediaUploadProgressBarView setProgress:((float)totalBytesSent/(float)totalBytesExpectedToSend) animated:YES];
    
    NSLog([NSString stringWithFormat:@"Progress: %f", ((float)totalBytesSent/(float)totalBytesExpectedToSend)])
}

@end
