//
//  Feed.h
//  FeelShare
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paginate : NSObject

@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *socialUserType;
@property (nonatomic, strong) NSString *hashTagText;
@property (nonatomic, strong) NSArray *pageResults;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSNumber *perPage;
@property (nonatomic, assign) NSInteger perPageLimit;
@property (nonatomic, strong) NSDate *lastUpdatedAt;

@property (nonatomic) BOOL hasMoreRecords;

+ (Paginate *)getPaginateFrom:(NSDictionary *)jsonDict;
- (Paginate *)initWithPageNumber:(NSNumber *)number withMoreRecords:(BOOL)boolean andPerPageLimit:(NSInteger)limit;
- (Paginate *)initWithSocialPageNumber:(NSNumber *)number withMoreRecords:(BOOL)boolean andPerPageLimit:(NSInteger)limit andType:(NSString *)type;
- (Paginate *)initPaginationWith:(NSArray *)results pageNumber:(NSNumber *)pageNumber andPerPage:(NSNumber *)perPage;
- (Paginate *)initWithLastUpdatedAt:(NSDate *)lastUpdatedAt andPerPageLimit:(NSInteger)limit;
- (Paginate *)initWithHashTagPageNumber:(NSNumber *)number withMoreRecords:(BOOL)boolean andPerPageLimit:(NSInteger)limit andHashTag:(NSString *)hashTag;

- (void)updatePaginationWith:(Paginate *)page;
@end
