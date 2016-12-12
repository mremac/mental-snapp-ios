//
//  SupportInterface.m
//  MentalSnapp
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import "SupportInterface.h"
#import "RealAPI.h"
#import "TestAPI.h"
#import "APIInteractorProvider.h"
#import "SupportRequest.h"

@implementation SupportInterface

- (void)sendSupportRequest:(SupportRequest *)supportRequest withCompletionBlock:(SupportInterfaceCompletionBlock)block {
    
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider sendSupportRequest:supportRequest andCompletionBlock:^(BOOL success, id response) {
        [self sendSupportLogRequestCallback:response];
    }];
}

- (void)sendSupportLogRequestCallback:(id)response {
    NSInteger status;
        id result = nil;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if ([response hasValueForKey:@"success"])
        {
            success = [response valueForKey:@"success"];
            status = [success integerValue];
                if (status == kStatusSuccess) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [Banner showSuccessBannerWithSubtitle:@"Sent sucessfully."];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [Banner hideAllBanners];
                        });
                        
                    });
                } else {
                    result = ([response hasValueForKey:@"message"])?[response valueForKey:@"message"]:@"Erorr!";
                }
        }
    }
    else
    {
         NSString *errorMessage = ((NSError *)response).localizedDescription;
        result = errorMessage;
        status = 0;
    }
    _block(status, result);
}

@end
