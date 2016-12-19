//
//  ScheduleRequest.h
//  MentalSnapp
//
//  Created by Systango on 19/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
@class Paginate;

@interface ScheduleRequest : Request

- (id)initWithGetSchedules:(Paginate *)paginate;
- (id)initWithEditSchedule:(ScheduleModel *)schedule;
- (id)initWithDeleteSchedule:(ScheduleModel *)schedule;

@end
