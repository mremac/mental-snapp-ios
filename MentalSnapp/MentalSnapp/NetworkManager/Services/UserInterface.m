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
            [self parseEditUserResponse:response];
        }];
}

- (void)getUserDetailWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getUserDetailWithRequest:userRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseUserResponse:response];
    }];
}

- (void)userDeactivate:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider userDeactivateWithRequest:userRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseUserResponse:response];
    }];
}

- (void)userLogout:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider userLogoutWithRequest:userRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseUserResponse:response];
    }];
}

- (void)changePasswordWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider changePasswordWithRequest:userRequest andCompletionBlock:^(BOOL success, id response) {
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
            NSError *error;
            UserModel *user = [[UserModel alloc] initWithDictionary:[response objectForKey:@"user"] error:&error];
            self.block([success integerValue], user);
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

- (void)parseEditUserResponse:(id)response {
    
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

- (void)parseChangePasswordResponse:(id)response {
    
    NSString *errorMessage;
    
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if([(NSDictionary *)response hasValueForKey:@"success"]) {
            success = [response valueForKey:@"success"];
        }
        if ([success integerValue] == kStatusSuccess)
        {
            [Banner showSuccessBannerWithSubtitle:@"Password hasbeen chaned successfully."];
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
        [Banner showFailureBannerWithSubtitle:errorMessage];
    }
}
    
@end
