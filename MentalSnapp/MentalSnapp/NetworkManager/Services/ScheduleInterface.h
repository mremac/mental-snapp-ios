//
//  ScheduleInterface.h
//  MentalSnapp
//
//  Created by Systango on 19/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ScheduleRequest;

@interface ScheduleInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getSchedulesWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block;
- (void)deleteScheduleWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block;
- (void)editScheduleWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block;
- (void)createScheduleWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block;

@end
