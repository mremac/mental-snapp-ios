//
//  FilterInterface.m
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FilterInterface.h"
#import "FilterRequest.h"
#import "Paginate.h"

@implementation FilterInterface

- (void)getFiltersWithRequest:(FilterRequest *)filterRequest withCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getFiltersWithRequest:filterRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseFilterList:response];
    }];
}

- (void)parseFilterList:(id)response {
    
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
            NSArray *array = [response objectForKey:@"filters"];
            NSMutableArray *filters = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                FilterModel *filter = [[FilterModel alloc] initWithDictionary:dictionary error:&error];
                [filters addObject:filter];
            }
            Paginate *pagination = [Paginate getPaginateFrom:response];
            pagination.pageResults = [NSArray arrayWithArray:filters];
            pagination.pageNumber = [NSNumber numberWithInteger:filters.count];
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
