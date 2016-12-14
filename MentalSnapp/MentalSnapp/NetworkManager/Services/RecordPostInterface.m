//
//  RecordPostInterface.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RecordPostInterface.h"
#import "Paginate.h"


@implementation RecordPostInterface

- (void)getRecordPostsWithRequest:(RecordPostRequest *)recordPostRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getRecordPostsWithRequest:recordPostRequest andCompletionBlock:^(BOOL success, id response) {
        [self parserecordPostListData:response];
    }];
}

- (void)postRecordPostWithRequest:(RecordPostRequest *)recordPostRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postRecordPostWithRequest:recordPostRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseRecordPostData:response];
    }];
}

- (void)parserecordPostListData:(id)response
{
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
            NSArray *array = [response objectForKey:@"posts"];
            NSMutableArray *recordPostList = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                RecordPost *recordPost = [[RecordPost alloc] initWithDictionary:dictionary error:&error];
                [recordPostList addObject:recordPost];
            }
            Paginate *pagination = [Paginate getPaginateFrom:response];
            pagination.pageResults = [NSArray arrayWithArray:recordPostList];
            pagination.pageNumber = [NSNumber numberWithInteger:recordPostList.count];
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

- (void)parseRecordPostData:(id)response {
    
    NSString *errorMessage;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if([(NSDictionary *)response hasValueForKey:@"success"]) {
            success = [response valueForKey:@"success"];
        }
        if ([success integerValue] == kStatusSuccess)
        {
            self.block([success integerValue], response);
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
