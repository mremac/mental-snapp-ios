//
//  Feeling.m
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Feeling.h"

@implementation Feeling

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"feelingId": @"id",
                                                                  @"feelingName": @"name"
                                                                  }];
}


@end
