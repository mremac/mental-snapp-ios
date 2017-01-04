//
//  ExcercixeInterface.h
//  MentalSnapp
//
//  Created by Systango on 01/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExcerciseRequest.h"

@interface ExcercixeInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getGuidedExcerciseWithRequest:(ExcerciseRequest *)excerciseRequest andCompletionBlock:(completionBlock)block;
- (void)getSubCategoryExcerciseWithRequest:(ExcerciseRequest *)excerciseRequest andCompletionBlock:(completionBlock)block;
- (void)getSubCategoryQuestionsExcerciseWithRequest:(ExcerciseRequest *)excerciseRequest andCompletionBlock:(completionBlock)block;

@end
