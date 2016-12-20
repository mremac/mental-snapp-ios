//
//  ScheduleManager.h
//  MentalSnapp
//
//  Created by Systango on 20/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ScheduleModel;

@interface ScheduleManager : NSObject

+ (ScheduleManager *)sharedInstance;

- (void)fetchAllSchedules;

- (void)didcleanSchedules;

- (void)removeScheduledNotifications:(ScheduleModel *)schedule;

- (void)modifyScheduledNotifications:(ScheduleModel *)schedule;

@end
