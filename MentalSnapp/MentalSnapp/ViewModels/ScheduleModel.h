//
//  ScheduleModel.h
//  MentalSnapp
//
//  Created by Systango on 19/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ScheduleModel : JSONModel
@property(strong, nonatomic) NSString <Optional> *scheduleId;
@property(strong, nonatomic) NSString <Optional> *executeAt;
@property(strong, nonatomic) GuidedExcercise <Optional> *exercise;

@end
