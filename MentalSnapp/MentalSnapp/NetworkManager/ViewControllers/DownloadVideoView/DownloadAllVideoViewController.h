//
//  DownloadAllVideoViewController.h
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"

@class RecordPost;

@protocol DownloadVideoDelegate <NSObject>

@optional
- (void)didDownloadCompleted:(BOOL)suceess;

@end

@interface DownloadAllVideoViewController : MSViewController

@property (nonatomic, assign) id <DownloadVideoDelegate> delegate;
@property (nonatomic, assign) BOOL downloadDirectlyFromRecordPost;
@property (nonatomic, strong) RecordPost *recordPost;

@end
