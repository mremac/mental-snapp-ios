//
//  UserInterface.h
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRequest.h"

@interface UserInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

    
- (void)editUserWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block;
- (void)changePasswordWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block;
- (void)getUserDetailWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block;
- (void)userDeactivate:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block;
- (void)userLogout:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block;

@end
