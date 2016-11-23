//
//  UserInterface.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UserInterface.h"
#import "APIInteractorProvider.h"

@implementation UserInterface

- (void)editUserWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block {
        _block = block;
        id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
        [apiInteractorProvider editUserWithRequest:userRequest andCompletionBlock:^(BOOL success, id response) {
            [self parseUserResponse:response];
        }];
}
    
- (void)parseUserResponse:(id)response {
    
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
        } else
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
        //[BannerManager showFailureBannerWithSubtitle:errorMessage];
    }
}

    
@end
