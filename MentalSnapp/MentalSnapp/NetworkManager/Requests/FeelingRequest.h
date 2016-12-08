//
//  FeelingRequest.h
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
#import "Paginate.h"

@interface FeelingRequest : Request

- (id)initWithFetchFeelingsWithPaginate:(Paginate *)paginate;

- (NSMutableDictionary *)getParams;


@end
