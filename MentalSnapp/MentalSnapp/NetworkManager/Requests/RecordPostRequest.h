//
//  RecordPostRequest.h
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
#import "RecordPost.h"

@class Paginate;

@interface RecordPostRequest : Request

- (id)initWithGetRecordPostsWithPaginate:(Paginate *)paginate;
- (id)initWithGetSearchRecordPostsWithPaginate:(Paginate *)paginate;
- (id)initForPostRecordPost:(RecordPost *)post;
- (NSMutableDictionary *)getParams;


@end
