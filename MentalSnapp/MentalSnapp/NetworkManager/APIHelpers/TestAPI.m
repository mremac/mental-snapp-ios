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

#pragma mark - Support
- (void)sendSupportRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Guided Excercise
#pragma mark - Guided Excercise
- (void)getGuidedExcerciseWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Record post data
- (void)getRecordPostsWithRequest:(Request *)request andCompletionBlock:(completionBlock)block{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}


- (void)postRecordPostWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)deleteRecordPostWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Feeling data
- (void)getFeelingWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Filter data
- (void)getFiltersWithRequest:(Request *)request andCompletionBlock:(completionBlock)block
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Schedule data
- (void)getSchedulesWithRequest:(Request *)request andCompletionBlock:(completionBlock)block
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}
- (void)deleteScheduleWithRequest:(Request *)request andCompletionBlock:(completionBlock)block
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)patchScheduleWithRequest:(Request *)request andCompletionBlock:(completionBlock)block
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)postScheduleWithRequest:(Request *)request andCompletionBlock:(completionBlock)block
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Stats data
- (void)getStatsWithRequest:(Request *)request andCompletionBlock:(completionBlock)block
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

#pragma mark - Login
- (void)loginWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)getSubCategoryExcerciseWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
}

- (void)getSubCategoryQuestionsExcerciseWithRequest:(Request *)request andCompletionBlock:(completionBlock)block {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"success", nil];
    block(YES, dict);
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
