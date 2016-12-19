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
        _parameters = [NSMutableDictionary dictionary];
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];

        self.urlPath = KGetGuidedExcercise;
    }
    return self;
}

- (id)initWithFetchSubCategoryExcerciseWithPaginate:(Paginate *)paginate {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];
        
        self.urlPath = [NSString stringWithFormat:KGetSubCategoryExcercise,paginate.details];
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
