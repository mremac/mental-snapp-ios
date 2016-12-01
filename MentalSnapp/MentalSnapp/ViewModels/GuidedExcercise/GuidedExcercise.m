//
//  GuidedExcercise.m
//  MentalSnapp
//
//  Created by Systango on 01/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "GuidedExcercise.h"

@implementation GuidedExcercise

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"excerciseId": @"id",
                                                                  @"excerciseName": @"name",
                                                                  @"excerciseCoverURL": @"cover_url",
                                                                  @"excerciseSmallCoverURL": @"small_cover_url",
                                                                  @"excerciseDescription": @"description",
                                                                  @"superExcerciseId": @"exercise_id",
                                                                  @"userId": @"created_at",
                                                                  @"excerciseStringType": @"type"
                                                                  }];
}


@end
