//
//  FilterInterface.h
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FilterRequest;

@interface FilterInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getFiltersWithRequest:(FilterRequest *)filterRequest withCompletionBlock:(completionBlock)block;

@end
