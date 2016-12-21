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
    localNotification.alertBody = [NSString stringWithFormat:@"You have exercise scheduled for: %@", schedule.exercise.excerciseName];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSMutableDictionary *dictionary = [[schedule toDictionary] mutableCopy];
    localNotification.userInfo = [NSMutableDictionary dictionaryWithObject:dictionary forKey:@"schedule"];
    
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
    NSArray *notifications = [[NSMutableArray alloc] init];
    UIApplication *app = [UIApplication sharedApplication];
    notifications = app.scheduledLocalNotifications;
    for (UILocalNotification *event in notifications)
    {
        NSDictionary *userInfoCurrent = event.userInfo;
        if([userInfoCurrent hasValueForKey:@"schedule"])
        {
            NSDictionary *scheduleInfo = [userInfoCurrent valueForKey:@"schedule"];
            ScheduleModel *scheduleNotif = [[ScheduleModel alloc] initWithDictionary:scheduleInfo error:nil];
            if([schedule.scheduleId isEqualToString:scheduleNotif.scheduleId])
            {
                [app cancelLocalNotification:event];
            }
        }
    }
}

- (void)modifyScheduledNotifications:(ScheduleModel *)schedule
{
    [self removeScheduledNotifications:schedule];
    [self addNotificationWithSchedule:schedule];
}

- (void)didReceiveScheduleNotification:(ScheduleModel *)schedule withState:(UIApplicationState)appState
{
    if (appState == UIApplicationStateActive) {
        //Show the notification in case of active app
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mental Snapp" message:[NSString stringWithFormat:@"You have exercise scheduled for: %@", schedule.exercise.excerciseName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Util openCameraForRecordExercise:schedule.exercise];
            });
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[ApplicationDelegate window] rootViewController] presentViewController:alertController animated:YES completion:nil];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Util openCameraForRecordExercise:schedule.exercise];
        });
    }
}

@end
