//
//  RecordPostRequest.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RecordPostRequest.h"
#import "Paginate.h"

@interface RecordPostRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation RecordPostRequest

- (id)initWithGetRecordPostsWithPaginate:(Paginate *)paginate {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];
        
        self.urlPath = kRecordPostAPI;
    }
    return self;
}

- (id)initWithGetSearchRecordPostsWithPaginate:(Paginate *)paginate {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];
        
        if(paginate.details.length > 0)
        {
            [_parameters setObject:paginate.details forKey:kJSearchText];
            
            if(paginate.hashTagText.length > 0)
            {
                [_parameters setObject:paginate.hashTagText forKey:kJExerciseId];
            }
        }
        
        self.urlPath = kSearchRecordPostAPI;
    }
    return self;
}

- (id)initWithGetFilteredRecordPostsWithPaginate:(Paginate *)paginate {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if (paginate.hasMoreRecords) {
            [_parameters setObject:paginate.pageNumber forKey:kJPage];
        }
        [_parameters setObject:[NSNumber numberWithInteger:paginate.perPageLimit] forKey:kJPerPage];
        
        if(paginate.details.length > 0)
            [_parameters setObject:paginate.details forKey:kJExerciseId];
        
        self.urlPath = kFilteredRecordPosts;
    }
    return self;
}

- (id)initForPostRecordPost:(RecordPost *)post {
    self = [super init];
    if (self) {
        NSMutableDictionary *dictionary = [[post toDictionary] mutableCopy];
        _parameters = [NSMutableDictionary dictionaryWithObject:dictionary forKey:@"posts"];
        self.urlPath = kRecordPostAPI;
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
