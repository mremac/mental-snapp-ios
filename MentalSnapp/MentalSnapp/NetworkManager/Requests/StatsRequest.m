//
//  StatsRequest.m
//  MentalSnapp
//
//  Created by Systango on 27/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "StatsRequest.h"

@interface StatsRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation StatsRequest

- (id)initWithGetStatsForMonth:(NSInteger)month andYear:(NSInteger)year
{
    self = [super init];
    if (self)
    {
        _parameters = [NSMutableDictionary dictionary];
        
        [_parameters setObject:[NSNumber numberWithInteger:month] forKey:@"month"];
        [_parameters setObject:[NSNumber numberWithInteger:year] forKey:@"year"];
        
        self.urlPath = kGetStatsAPI;
    }
    return self;
}

- (NSMutableDictionary *)getParams {
    if (_parameters) {
        return _parameters;
    } else {
        return [NSMutableDictionary dictionary];
    }
}


@end
