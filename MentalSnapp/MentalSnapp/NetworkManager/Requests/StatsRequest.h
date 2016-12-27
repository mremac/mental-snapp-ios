//
//  StatsRequest.h
//  MentalSnapp
//
//  Created by Systango on 27/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"

@interface StatsRequest : Request

- (id)initWithGetStatsForMonth:(NSInteger)month andYear:(NSInteger)year;

@end
