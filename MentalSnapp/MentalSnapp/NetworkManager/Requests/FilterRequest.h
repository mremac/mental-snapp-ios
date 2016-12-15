//
//  FilterRequest.h
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
@class Paginate;

@interface FilterRequest : Request

- (id)initWithGetFilters:(Paginate *)paginate;

- (NSMutableDictionary *)getParams;

@end
