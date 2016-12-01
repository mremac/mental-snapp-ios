//
//  ExcerciseRequest.h
//  MentalSnapp
//
//  Created by Systango on 01/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
#import "Paginate.h"

@interface ExcerciseRequest : Request

- (id)initWithFetchGuidedExcerciseWithPaginate:(Paginate *)paginate;

- (NSMutableDictionary *)getParams;

@end
