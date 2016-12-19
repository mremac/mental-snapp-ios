//
//  FeelingRequest.m
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FeelingRequest.h"
#import "Paginate.h"

@interface FeelingRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation FeelingRequest

- (id)initWithFetchFeelingsWithPaginate:(Paginate *)paginate {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];
        
        self.urlPath = KFeelingList;
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
