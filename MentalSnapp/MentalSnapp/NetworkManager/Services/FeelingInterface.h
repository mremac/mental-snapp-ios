//
//  FeelingInterface.h
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeelingRequest.h"

@interface FeelingInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getFeelingWithRequest:(FeelingRequest *)feelingRequest andCompletionBlock:(completionBlock)block;

@end
