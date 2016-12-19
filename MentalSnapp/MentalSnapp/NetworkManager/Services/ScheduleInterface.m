//
//  ScheduleInterface.m
//  MentalSnapp
//
//  Created by Systango on 19/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ScheduleInterface.h"
#import "ScheduleRequest.h"
#import "Paginate.h"

@implementation ScheduleInterface

- (void)getSchedulesWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getSchedulesWithRequest:scheduleRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseScheduleList:response];
    }];
}

- (void)deleteScheduleWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider deleteScheduleWithRequest:scheduleRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseScheduleList:response];
    }];
}

- (void)editScheduleWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider patchScheduleWithRequest:scheduleRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseScheduleList:response];
    }];
}

- (void)createScheduleWithRequest:(ScheduleRequest *)scheduleRequest withCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postScheduleWithRequest:scheduleRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseScheduleList:response];
    }];
}

- (void)parseScheduleList:(id)response {
    
    NSString *errorMessage;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if([(NSDictionary *)response hasValueForKey:@"success"]) {
            success = [response valueForKey:@"success"];
        }
        if ([success integerValue] == kStatusSuccess)
        {
            NSError *error;
            NSArray *array = [response objectForKey:@"schedules"];
            NSMutableArray *scheduleList = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                ScheduleModel *schedule = [[ScheduleModel alloc] initWithDictionary:dictionary error:&error];
                [scheduleList addObject:schedule];
            }
            Paginate *pagination = [Paginate getPaginateFrom:response];
            pagination.pageResults = [NSArray arrayWithArray:scheduleList];
            pagination.pageNumber = [NSNumber numberWithInteger:scheduleList.count];
            self.block([success integerValue], pagination);
        }
        else
        {
            if([response hasValueForKey:@"message"])
            {
                errorMessage = [response valueForKey:@"message"];
            }
            _block([success integerValue], errorMessage);
        }
        
    } else if([response isKindOfClass:[NSError class]]) {
        
        errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    } else {
        errorMessage = @"Something went wrong while processing your request";
        _block(NO, errorMessage);
    }
    if (errorMessage)
    {
        [Banner showFailureBannerWithSubtitle:errorMessage];
    }
}

@end
