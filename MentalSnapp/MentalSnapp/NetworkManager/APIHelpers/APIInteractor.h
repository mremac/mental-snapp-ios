//
//  APIInteractor.h
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Request;

@protocol APIInteractor <NSObject>

#pragma mark - User

- (void)editUserWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)changePasswordWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)getUserDetailWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)userDeactivateWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)userLogoutWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;

#pragma mark - Support
- (void)sendSupportRequest:(Request *)request andCompletionBlock:(completionBlock)block;

#pragma mark - Guided excercise
- (void)getGuidedExcerciseWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)getSubCategoryExcerciseWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;

#pragma mark - Record post data
- (void)getRecordPostsWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)postRecordPostWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;

#pragma mark - Feeling data
- (void)getFeelingWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;

#pragma mark - Login
- (void)loginWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)signUpWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;
- (void)forgotPasswordWithRequest:(Request *)request andCompletionBlock:(completionBlock)block;

@required

- (void)putObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)getObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)postObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)deleteObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)multiPartObjectPost:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)multiPartObjectPut:(Request *)request withCompletionBlock:(completionBlock)block;

@end
