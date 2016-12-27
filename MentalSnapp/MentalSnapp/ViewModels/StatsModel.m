//
//  StatsModel.m
//  MentalSnapp
//
//  Created by Systango on 27/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "StatsModel.h"

@implementation StatsModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"barChartMoodData": @"bar_chart",
                                                                  @"monthMoodData": @"month_data",
                                                                  @"weekDataInfo": @"week_data",
                                                                  @"posts": @"posts"
                                                                  }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"posts"])
        return YES;
    
    return NO;
}
@end
