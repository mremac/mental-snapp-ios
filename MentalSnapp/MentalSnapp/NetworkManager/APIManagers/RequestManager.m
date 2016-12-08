//
//  RequestManager.m
//  MentalSnapp
//

#import "RequestManager.h"
#import "UserInterface.h"
#import "UserRequest.h"
#import "LoginInterface.h"
#import "LoginRequest.h"
#import "SupportRequest.h"
#import "SupportInterface.h"
#import "ExcercixeInterface.h"
#import "ExcerciseRequest.h"
#import "FeelingRequest.h"
#import "FeelingInterface.h"
#import "RecordPostRequest.h"
#import "RecordPostInterface.h"

NSString *const kDefaultErrorMessage =  @"Error! Please try again.";

@implementation RequestManager

#pragma mark - Login
- (void)loginWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[LoginInterface alloc] loginWithUserRequest:[[LoginRequest alloc]initWithLoginUserModel:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }else {
        block(NO, nil);
    }
}

- (void)signUpWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[LoginInterface alloc] signUpWithUserRequest:[[LoginRequest alloc] initWithSignUpUserModel:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }else {
        block(NO, nil);
    }
}

- (void)forgotPasswordWithEmail:(NSString *)email withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[LoginInterface alloc] forgotPasswordWithUserRequest:[[LoginRequest alloc] initWithForgotPassEmail:email] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }else {
            block(NO, nil);
    }
}

#pragma mark - User
- (void)editUserWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
        if ([ApplicationDelegate hasNetworkAvailable]) {
            [[UserInterface alloc] editUserWithRequest:[[UserRequest alloc] initForEditUser:userModel] andCompletionBlock:^(BOOL success, id response) {
                block(success,response);
            }];
        }else {
            block(NO, nil);
        }
}

- (void)getUserDetailWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getUserDetailWithRequest:[[UserRequest alloc] initForUserDetail:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }else {
        block(NO, nil);
    }
}


- (void)changePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] changePasswordWithRequest:[[UserRequest alloc] initForChangePassword:currentPassword andNewPassword:newPassword] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }else {
        block(NO, nil);
    }
}

- (void)userLogoutWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] userLogout:[[UserRequest alloc] initForUserDetail:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }else {
        block(NO, nil);
    }
}

- (void)userDeactivateWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] userDeactivate:[[UserRequest alloc] initForUserDeactivate:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }else {
        block(NO, nil);
    }
}

#pragma mark - support
- (void)sendSupportLogs:(NSMutableDictionary *)dictionary withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[SupportInterface alloc] sendSupportRequest:[[SupportRequest alloc] initWithSupportDetails:dictionary] withCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];

    }else {
        block(NO, nil);
    }
}

#pragma mark - Guided Excercise
- (void)getGuidedExcerciseWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block{
    if ([ApplicationDelegate hasNetworkAvailable]) {
        
        [[ExcercixeInterface alloc] getGuidedExcerciseWithRequest:[[ExcerciseRequest alloc] initWithFetchGuidedExcerciseWithPaginate:paginate] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
        
    }else {
        block(NO, nil);
    }
}

- (void)getSubCategoryExcerciseWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block{
    if ([ApplicationDelegate hasNetworkAvailable]) {
        
        [[ExcercixeInterface alloc] getSubCategoryExcerciseWithRequest:[[ExcerciseRequest alloc] initWithFetchSubCategoryExcerciseWithPaginate:paginate] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
        
    }else {
        block(NO, nil);
    }
    
}

#pragma mark - Record Post data
- (void)postRecordPost:(RecordPost *)post withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
            [[RecordPostInterface alloc] postRecordPostWithRequest:[[RecordPostRequest alloc] initForPostRecordPost:post] andCompletionBlock:^(BOOL success, id response) {
                block(success, response);
            }];
        
    }else {
        block(NO, nil);
    }
}

#pragma mark - Feeling data
- (void)getFeelingWithPaginate:(Paginate *)paginate withCompletionBlock:(completionBlock)block{
    if ([ApplicationDelegate hasNetworkAvailable]) {
        
        [[FeelingInterface alloc] getFeelingWithRequest:[[FeelingRequest alloc] initWithFetchFeelingsWithPaginate:paginate] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
        
    }else {
        block(NO, nil);
    }
}

@end
