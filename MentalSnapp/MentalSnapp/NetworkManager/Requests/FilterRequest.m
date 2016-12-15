//
//  FilterRequest.m
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FilterRequest.h"
#import "Paginate.h"

@interface FilterRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation FilterRequest

- (id)initWithGetFilters:(Paginate *)paginate
{
    self = [super init];
    if (self)
    {
        _parameters = [NSMutableDictionary dictionary];
        
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];
        
        self.urlPath = kFilterListAPI;
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
