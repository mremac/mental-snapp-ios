//
//  LoginInterface.h
//  Skeleton
//
//  Created by Systango on 18/12/13.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRequest.h"

@interface LoginInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)loginWithUserRequest:(LoginRequest *)loginRequest andCompletionBlock:(completionBlock)block;

- (void)signUpWithUserRequest:(LoginRequest *)loginRequest andCompletionBlock:(completionBlock)block;

- (void)forgotPasswordWithUserRequest:(LoginRequest *)loginRequest andCompletionBlock:(completionBlock)block;

- (NSMutableArray *)getSavedSessionCookies;

- (BOOL)setSavedSessionCookies;

- (void)saveSessionCookies:(NSString *)urlPath;

- (void)clearSavedSessionCookies;

@end
