//
//  FilterModel.m
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"filterId": @"id",
                                                                  @"filterName": @"name",
                                                                  @"filterType": @"type"
                                                                  }];
}

@end
