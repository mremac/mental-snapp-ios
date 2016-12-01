//
//  ExcerciseRequest.m
//  MentalSnapp
//
//  Created by Systango on 01/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ExcerciseRequest.h"

@interface ExcerciseRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation ExcerciseRequest

- (id)initWithFetchGuidedExcerciseWithPaginate:(Paginate *)paginate {
    self = [super init];
    if (self) {
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJlimit];

        self.urlPath = KGetGuidedExcercise;
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
