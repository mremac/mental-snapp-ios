//
//  VideoTableViewCell.h
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordPost;

@interface VideoTableViewCell : UITableViewCell

- (void)assignRecordPost:(RecordPost *)recordPost playBlock:(completionBlock)playBlock downloadBlock:(completionBlock)downloadBlock;

@end
