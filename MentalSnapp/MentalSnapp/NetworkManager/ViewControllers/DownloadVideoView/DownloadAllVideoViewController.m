//
//  DownloadAllVideoViewController.m
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "DownloadAllVideoViewController.h"
#import "RequestManager.h"
#import "Paginate.h"
#import "S3Manager.h"
#import "RecordPost.h"

@interface DownloadAllVideoViewController ()
{
    Paginate *paginate;
    int count;
    S3Manager *manager;
}
@property (strong, nonatomic) IBOutlet UIView *DownloadView;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressbar;
- (IBAction)closeDownloadAction:(id)sender;

@end

@implementation DownloadAllVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!self.downloadDirectlyFromRecordPost)
    {
        count = 0;
        [self getDownloadVideos];
    }
    else if(self.recordPost)
    {
        [self downloadVideoFromRecordPost];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDownloadVideos {
    [[RequestManager alloc] getRecordPostsWithPaginate:[[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:100]withCompletionBlock:^(BOOL success, id response) {
        if(success){
            paginate = response;
            if(paginate.pageResults.count > 0){
                [self downloadAllVideo:paginate.pageResults];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                [self downloadCompletion:NO];
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            [self downloadCompletion:NO];
        }
    }];
}

-(void)downloadAllVideo:(NSArray *)array
{
    RecordPost *record = [array objectAtIndex:count];
    [self downloadVideoFromRecordPost:record withCompletionBlock:^(BOOL success, id response)
     {
         if(success)
         {
             count++;
             if(count >= array.count)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [self downloadCompletion:YES];
                 });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self downloadAllVideo:paginate.pageResults];
                 });
             }
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self downloadAllVideo:paginate.pageResults];
                 [self downloadCompletion:NO];
             });
         }
     }];
}

-(void)downloadVideoFromRecordPost:(RecordPost *)record withCompletionBlock:(completionBlock)block
{
    if(ApplicationDelegate.hasNetworkAvailable)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@",[record.videoURL lastPathComponent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.TitleLabel setText:fileName];
            [self.progressbar setProgress:0 animated:YES];
        });
        manager = [[S3Manager alloc] initWithFileURL:nil s3Key:fileName mediaUploadProgressBarView:self.progressbar progressBarLabel:nil fileType:VideoFileType contentLength:0];
        
        [manager downloadFileToS3CompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        [self downloadCompletion:NO];
    }
}

-(void)downloadCompletion:(BOOL) success{
    if(_delegate && [_delegate respondsToSelector:@selector(didDownloadCompleted:)]){
        [_delegate didDownloadCompleted:success];
    }
}

-(void)downloadVideoFromRecordPost
{
    [self downloadVideoFromRecordPost:self.recordPost withCompletionBlock:^(BOOL success, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self downloadCompletion:success];
        });
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)closeDownloadAction:(id)sender {
    [manager pauseAllDownloads];
    
    if(self.downloadDirectlyFromRecordPost)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self downloadCompletion:YES];
            [manager cancelAllDownloads];
        });
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mental Snapp" message:@"Are you sure want to stop downloading and delete profile?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
                [self downloadCompletion:YES];
                [manager cancelAllDownloads];
            });
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [manager resumeAllDownloads];
            });
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

@end
