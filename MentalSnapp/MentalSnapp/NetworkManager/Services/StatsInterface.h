//
//  StatsInterface.h
//  MentalSnapp
//
//  Created by Systango on 27/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsRequest.h"

@interface StatsInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getStatsWithRequest:(StatsRequest *)statsRequest withCompletionBlock:(completionBlock)block;

@end
