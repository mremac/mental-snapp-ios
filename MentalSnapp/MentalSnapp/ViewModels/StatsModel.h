//
//  StatsModel.h
//  MentalSnapp
//
//  Created by Systango on 27/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RecordPost.h"
@class MoodDataModel;

@interface StatsModel : JSONModel
@property(strong, nonatomic) MoodDataModel <Optional> *barChartMoodData;
@property(strong, nonatomic) MoodDataModel <Optional> *monthMoodData;
@property(strong, nonatomic) NSDictionary <Optional> *weekDataInfo;
@property(strong, nonatomic) NSArray<RecordPost> *posts;
@property(strong, nonatomic) NSDate <Ignore>*selectedDate;

@end
