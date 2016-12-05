//
//  ExcercixeInterface.m
//  MentalSnapp
//
//  Created by Systango on 01/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ExcercixeInterface.h"
#import "GuidedExcercise.h"
#import "Paginate.h"

@implementation ExcercixeInterface

- (void)getGuidedExcerciseWithRequest:(ExcerciseRequest *)excerciseRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getGuidedExcerciseWithRequest:excerciseRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseGuidedExcercise:response];
    }];
}

- (void)getSubCategoryExcerciseWithRequest:(ExcerciseRequest *)excerciseRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getSubCategoryExcerciseWithRequest:excerciseRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseSubCategoryExcercise:response];
    }];
}


- (void)parseGuidedExcercise:(id)response {
    
    NSString *errorMessage;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if([(NSDictionary *)response hasValueForKey:@"success"]) {
            success = [response valueForKey:@"success"];
        }
        if ([success integerValue] == kStatusSuccess)
        {
            NSError *error;
            NSArray *array = [response objectForKey:@"guided_exercises"];
            NSMutableArray *guidedExcercises = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                GuidedExcercise *excercise = [[GuidedExcercise alloc] initWithDictionary:dictionary error:&error];
                [guidedExcercises addObject:excercise];
            }
            Paginate *pagination = [Paginate getPaginateFrom:response];
            pagination.pageResults = [NSArray arrayWithArray:guidedExcercises];
            pagination.pageNumber = [NSNumber numberWithInteger:guidedExcercises.count];
            self.block([success integerValue], pagination);
        }
        else
        {
            if([response hasValueForKey:@"message"])
            {
                errorMessage = [response valueForKey:@"message"];
            }
            _block([success integerValue], errorMessage);
        }
        
    } else if([response isKindOfClass:[NSError class]]) {
        
        errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    } else {
        errorMessage = @"Something went wrong while processing your request";
        _block(NO, errorMessage);
    }
    if (errorMessage)
    {
        [Banner showFailureBannerWithSubtitle:errorMessage];
    }
}

- (void)parseSubCategoryExcercise:(id)response {
    
    NSString *errorMessage;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if([(NSDictionary *)response hasValueForKey:@"success"]) {
            success = [response valueForKey:@"success"];
        }
        if ([success integerValue] == kStatusSuccess)
        {
            NSError *error;
            NSArray *array = [response objectForKey:@"sub_categories"];
            NSMutableArray *guidedExcercises = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                GuidedExcercise *excercise = [[GuidedExcercise alloc] initWithDictionary:dictionary error:&error];
                [guidedExcercises addObject:excercise];
            }
            Paginate *pagination = [Paginate getPaginateFrom:response];
            pagination.pageResults = [NSArray arrayWithArray:guidedExcercises];
            pagination.pageNumber = [NSNumber numberWithInteger:guidedExcercises.count];
            self.block([success integerValue], pagination);
        }
        else
        {
            if([response hasValueForKey:@"message"])
            {
                errorMessage = [response valueForKey:@"message"];
            }
            _block([success integerValue], errorMessage);
        }
        
    } else if([response isKindOfClass:[NSError class]]) {
        
        errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    } else {
        errorMessage = @"Something went wrong while processing your request";
        _block(NO, errorMessage);
    }
    if (errorMessage)
    {
        [Banner showFailureBannerWithSubtitle:errorMessage];
    }
}

@end
