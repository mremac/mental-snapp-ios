//
//  FeelingInterface.m
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FeelingInterface.h"
#import "FeelingRequest.h"
#import "Feeling.h"
#import "Paginate.h"

@implementation FeelingInterface

- (void)getFeelingWithRequest:(FeelingRequest *)feelingRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getFeelingWithRequest:feelingRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseFeelingData:response];
    }];
}

- (void)parseFeelingData:(id)response {
    
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
            NSArray *array = [response objectForKey:@"feelings"];
            NSMutableArray *feelings = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                Feeling *feeling = [[Feeling alloc] initWithDictionary:dictionary error:&error];
                [feelings addObject:feeling];
            }
            Paginate *pagination = [Paginate getPaginateFrom:response];
            pagination.pageResults = [NSArray arrayWithArray:feelings];
            pagination.pageNumber = [NSNumber numberWithInteger:feelings.count];
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
