//
//  DatePaginate.h
//  MentalSnapp
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import "Paginate.h"

@interface DatePaginate : Paginate

@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *dateType;

- (DatePaginate *)initWithCreatedAt:(NSString *)createdAt andPerPageLimit:(NSInteger)limit;

- (void)updatePaginationWith:(DatePaginate *)page;
- (void)updateDatePaginateWith:(DatePaginate *)page;

+ (DatePaginate *)getPaginateFrom:(NSDictionary *)jsonDict;
@end
