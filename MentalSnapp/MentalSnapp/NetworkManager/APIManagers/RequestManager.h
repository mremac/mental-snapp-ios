//
//  RequestManager.h
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Paginate, RecordPost;

@interface RequestManager : NSObject

#pragma mark - Login
- (void)loginWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)signUpWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)forgotPasswordWithEmail:(NSString *)email withCompletionBlock:(completionBlock)block;

#pragma mark - User
- (void)editUserWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)changePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword withCompletionBlock:(completionBlock)block;
- (void)getUserDetailWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)userLogoutWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)userDeactivateWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)sendSupportLogs:(NSMutableDictionary *)dictionary withCompletionBlock:(completionBlock)block;

#pragma mark - Excercise
- (void)getGuidedExcerciseWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;
- (void)getSubCategoryExcerciseWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;
- (void)initWithFetchSubCategoryQuestionsExcerciseWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;

#pragma mark - Feeling data
- (void)getFeelingWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;

#pragma mark - Record Post data
- (void)getRecordPostsWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;
- (void)getSearchRecordPostsWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;
- (void)getFilteredRecordPostsWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block;
- (void)postRecordPost:(RecordPost *)post withCompletionBlock:(completionBlock)block;
- (void)deleteRecordPost:(RecordPost *)post withCompletionBlock:(completionBlock)block;

#pragma mark - Filter data
- (void)getFilterListWithPagination:(Paginate *)paginate withCompletionBlock:(completionBlock)block;

#pragma mark - Filter data
- (void)getScheduleListWithPagination:(Paginate *)paginate withCompletionBlock:(completionBlock)block;
- (void)deleteSchedule:(ScheduleModel *)schedule withCompletionBlock:(completionBlock)block;
- (void)editSchedule:(ScheduleModel *)schedule withCompletionBlock:(completionBlock)block;
- (void)createSchedule:(ScheduleModel *)schedule withCompletionBlock:(completionBlock)block;

#pragma mark - STATS data
- (void)getStatsForMonth:(NSInteger)month andYear:(NSInteger)year withCompletionBlock:(completionBlock)block;
@end
