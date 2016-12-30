//
//  DatePaginate.m
//  MentalSnapp
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import "DatePaginate.h"

@implementation DatePaginate

- (DatePaginate *)initWithCreatedAt:(NSString *)createdAt andPerPageLimit:(NSInteger)limit{
    self = [super init];
    
    if(self) {
        self.createdAt = createdAt;
        self.perPageLimit = limit;
        self.pageResults = [[NSArray alloc] init];
        self.hasMoreRecords = YES;
    }
    return self;
}

- (void)updatePaginationWith:(DatePaginate *)page{
    [super updatePaginationWith:page];
}

- (void)updateDatePaginateWith:(DatePaginate *)page {
    if ([page.dateType isEqualToString:kAfter]) {
        [self addToAfterFeedResultsFrom:page.pageResults];
    }else {
        [self addToFeedResultsFrom:page.pageResults];
    }
}

+ (DatePaginate *)getPaginateFrom:(NSDictionary *)jsonDict {
    DatePaginate *pagination = [[DatePaginate alloc] init];
    if ([jsonDict hasValueForKey:@"totalComments"] ) {
        pagination.perPage = [NSNumber numberWithInteger:[[jsonDict valueForKey:@"totalComments"] integerValue]];
    }
    
    pagination.pageResults = [NSArray new];
    return pagination;
}

#pragma mark - Private Methods

- (void)addToFeedResultsFrom:(NSArray *)array {
    NSMutableArray *mutableResults = [NSMutableArray arrayWithArray:self.pageResults];
    [mutableResults addObjectsFromArray:array];
    self.pageResults = [NSArray arrayWithArray:mutableResults];
}

- (void)addToAfterFeedResultsFrom:(NSArray *)array {
    NSMutableArray *mutableResults = [NSMutableArray arrayWithArray:array];
    [mutableResults addObjectsFromArray:self.pageResults];
    self.pageResults = [NSArray arrayWithArray:mutableResults];
}


@end
