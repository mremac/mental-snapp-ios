//
//  StatsInterface.m
//  MentalSnapp
//
//  Created by Systango on 27/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "StatsInterface.h"
#import "StatsRequest.h"

@implementation StatsInterface

- (void)getStatsWithRequest:(StatsRequest *)statsRequest withCompletionBlock:(completionBlock)block
{
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getStatsWithRequest:statsRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseStats:response];
    }];
}

- (void)parseStats:(id)response {
    
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
            StatsModel *stats = [[StatsModel alloc] initWithDictionary:response error:&error];
            self.block([success integerValue], stats);
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
