//
//  TestAPI.m
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "TestAPI.h"
#import "APIInteractor.h"

@interface TestAPI () <APIInteractor>

@end

@implementation TestAPI

#pragma mark - User
    
- (void)editUserWithRequest:(Request *)request andCompletionBlock:(completionBlock)block  {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
        block(YES, dict);
}

- (void)changePasswordWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)getUserDetailWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)userDeactivateWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}
- (void)userLogoutWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Login

- (void)loginWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    
}

- (void)signUpWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    
}

- (void)forgotPasswordWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    
}

#pragma mark -
    
- (void)putObject:(Request *)request withCompletionBlock:(completionBlock)block {

}

- (void)getObject:(Request *)request withCompletionBlock:(completionBlock)block {

}

- (void)postObject:(Request *)request withCompletionBlock:(completionBlock)block {

}

- (void)deleteObject:(Request *)request withCompletionBlock:(completionBlock)block {

}

- (void)multiPartObjectPost:(Request *)request withCompletionBlock:(completionBlock)block {

}

- (void)multiPartObjectPut:(Request *)request withCompletionBlock:(completionBlock)block {

}

@end
