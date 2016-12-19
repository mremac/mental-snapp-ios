//
//  ScheduleModel.m
//  MentalSnapp
//
//  Created by Systango on 19/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ScheduleModel.h"

@implementation ScheduleModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"scheduleId": @"id",
                                                                  @"executeAt": @"execute_at",
                                                                  @"exercise": @"exercise"
                                                                  }];
}

@end
