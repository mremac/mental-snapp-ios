//
//  ScheduleManager.m
//  MentalSnapp
//
//  Created by Systango on 20/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ScheduleManager.h"
#import "Paginate.h"
#import "RequestManager.h"
#import "GuidedExcercise.h"

@interface ScheduleManager()

@property (strong, nonatomic) Paginate *schedulesPaginate;

@end

@implementation ScheduleManager

- (id)init
{
    if ((self = [super init])) {
        [self initPaginate];
    }
    
    return self;
}

+ (ScheduleManager *)sharedInstance
{
    static ScheduleManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Private methods

- (void)initPaginate {
    _schedulesPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:1000];
}

- (void)removeAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)addNotificationWithSchedule:(ScheduleModel *)schedule
{
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:[schedule.executeAt integerValue]];
    localNotification.alertBody = schedule.exercise.excerciseName;
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSMutableDictionary *dictionary = [[schedule toDictionary] mutableCopy];
    localNotification.userInfo = [NSMutableDictionary dictionaryWithObject:dictionary forKey:@"schedules"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)updateNotifications
{
    [self removeAllNotifications];
    
    for (ScheduleModel *schedule in self.schedulesPaginate.pageResults)
    {
        [self addNotificationWithSchedule:schedule];
    }
}

#pragma mark - Public methods
- (void)fetchAllSchedules
{
    [[RequestManager alloc] getScheduleListWithPagination:self.schedulesPaginate withCompletionBlock:^(BOOL success, id response) {
        if(success)
        {
            [self.schedulesPaginate updatePaginationWith:response];
            if([self.schedulesPaginate.pageResults count] > 0)
            {
                if(self.schedulesPaginate.hasMoreRecords)
                {
                    [self fetchAllSchedules];
                }
                else
                {
                    [self updateNotifications];
                }
            }
            else
            {
                [self updateNotifications];
            }
        }
    }];
}

- (void)didcleanSchedules
{
    [self initPaginate];
}

- (void)removeScheduledNotifications:(ScheduleModel *)schedule
{
    [[UIApplication sharedApplication] cancelLocalNotification:nil];
}

- (void)modifyScheduledNotifications:(ScheduleModel *)schedule
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
